# Local patches for RASCHplot (v0.1.0, github.com/ERRTG/RASCHplot).
#
# These patch bugs in the package's polytomous (RMP) machinery so that
# RMPstats() and rRMPstats() actually run. Session-scoped: they override
# the loaded package in memory, not the installed package files on disk.
# Source this once, after library(RASCHplot), in any script that needs
# RMPstats()/rRMPstats().
#
# Reported upstream: https://github.com/ERRTG/RASCHplot

library(RASCHplot)

# --- Helper: patching an EXPORTED function needs two writes, not one -------
# assignInNamespace() updates the function inside the package's namespace,
# so RASCHplot:::name and RASCHplot::name see the patch immediately. But for
# an exported name, library(RASCHplot) also copies that binding onto the
# search path (as package:RASCHplot) at attach time - a separate copy that
# assignInNamespace() does NOT touch. An ordinary unqualified call, e.g.
# rRMPstats(...) in your own script, resolves via that search-path copy, so
# without this second write it would keep silently running the *original,
# unpatched* function. (Internal, non-exported helpers like pcmfct() have no
# such copy - assignInNamespace() alone is enough for those.)
patch_exported <- function(name, fn, ns) {
  assignInNamespace(name, fn, ns = ns)
  pkgenv <- as.environment(paste0("package:", ns))
  unlockBinding(name, pkgenv)
  assign(name, fn, envir = pkgenv)
  lockBinding(name, pkgenv)
}

# --- Bug 1: pcmfct() ---------------------------------------------------------
# pcmfct() is the internal helper both RMPstats() and rRMPstats() use to
# compute model-implied category probabilities for one item. Item-parameter
# matrices (delta, and beta from delta2beta()) are items x thresholds
# (rows = items, columns = category thresholds; see ?rRMP's own
# K <- nrow(delta) and mi <- apply(delta, 1, ...) convention, and
# beta2delta()'s actual output).
#
# The original pcmfct() gets both of these wrong:
#   M <- nrow(delta)        # should be ncol(delta): M = thresholds, not items
#   beta[, ii]               # should be beta[ii, ]: item ii's thresholds are row ii
# This throws "subscript out of bounds" (via rRMP()/rRMPstats()) or
# "non-conformable arrays" (via RMPstats()) whenever there are more items
# than threshold columns - i.e. almost always for a real scale.
pcmfct_fixed <- function(delta, theta, ii) {
  if (!all(any(class(delta) %in% c("matrix", "data.frame")))) {
    stop("delta is not a matrix or data.frame")
  }
  N <- length(theta)
  M <- ncol(delta)
  beta <- RASCHplot::delta2beta(delta = delta)
  beta0 <- 0
  matb <- matrix(c(beta0, beta[ii, ]), nrow = N, ncol = M + 1, byrow = TRUE)
  matx <- matrix(0:M, nrow = N, ncol = M + 1, byrow = TRUE)
  eta <- exp(theta * matx + matb)
  eta / rowSums(eta, na.rm = TRUE)
}
assignInNamespace("pcmfct", pcmfct_fixed, ns = "RASCHplot")

# --- Bug 2: rRMPstats() orientation, plus a retry wrapper -------------------
# Inside its bootstrap loop, rRMPstats() re-fits RASCHfits() on each simulated
# dataset and feeds the result straight into RMPstats(). But RASCHfits()'s
# polytomous delta comes back as thresholds x items - the opposite
# orientation RMPstats()/pcmfct() expect (items x thresholds) - so every
# replicate fails with "non-conformable arrays" unless it's transposed first.
#
# On top of that fix, this version wraps each replicate in a retry loop: if a
# replicate throws an error (e.g. a degenerate simulated sample that makes
# estimation fail outright), it redraws a fresh simulated dataset for just
# that replicate and tries again, up to max_retries times, rather than
# aborting the whole run. In testing (100 unseeded replicates on the
# package's own SPADI example, after fixing pcmfct() and this orientation
# bug) every replicate succeeded on the first attempt - the retry wrapper is
# a safety net for rare cases, not something expected to fire often.
#
# Known residual caveat this does NOT address: a replicate can succeed
# (no error) while still being numerically unstable - e.g. a near-singular
# Hessian during CML re-estimation producing extreme fit-statistic values
# (a max-Outfit in the hundreds of thousands was observed in testing,
# alongside "NaNs produced" warnings from the person/item SE computation).
# The retry wrapper only catches actual errors, not implausible-but-valid
# results; treat max-percentile output with that in mind, especially at
# smaller sample sizes.
rRMPstats_fixed <- function(delta, theta, method.item = c("PCML", "CML", "JML", "MML"),
                             method.person = c("WML", "MLE"), B, trace.it = 0,
                             max_retries = 10) {
  method.item <- match.arg(method.item)
  method.person <- match.arg(method.person)
  if (!all(any(class(delta) %in% c("matrix", "data.frame")))) {
    stop("delta is not a matrix or data.frame")
  }
  statobj <- vector(mode = "list", length = B)
  if (trace.it) cat("Simulating\n")
  for (b in 1:B) {
    attempt <- 0
    repeat {
      attempt <- attempt + 1
      result <- tryCatch({
        Xb <- RASCHplot::rRMP(delta = delta, theta = theta, B = 1)[[1]]
        fit <- RASCHplot::RASCHfits(method.item, method.person, dat = Xb)
        delta.sim <- t(fit$delta)
        theta.sim <- fit$theta
        RASCHplot::RMPstats(delta = delta.sim, theta = theta.sim, dat = Xb)
      }, error = function(e) e)
      if (!inherits(result, "error")) {
        statobj[[b]] <- result
        break
      }
      if (attempt >= max_retries) {
        stop(sprintf("Replicate %d failed after %d attempts; last error: %s",
                      b, attempt, conditionMessage(result)))
      }
    }
    if (trace.it) message(paste0(b, " (", attempt, " attempt", if (attempt > 1) "s", ")"))
  }
  stats <- list(statobj = statobj, method.item = method.item, method.person = method.person)
  class(stats) <- "RASCHstats"
  stats
}
patch_exported("rRMPstats", rRMPstats_fixed, ns = "RASCHplot")
