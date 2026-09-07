# Local patches for RASCHplot (v0.1.0, github.com/ERRTG/RASCHplot).
#
# These patch two bugs in the package's polytomous (RMP) machinery so that
# RMPstats() and rRMPstats() actually run. Both fixes are session-scoped
# (assignInNamespace overrides the loaded package in memory, not the
# installed package files on disk) - source this once, after library(RASCHplot),
# in any script that needs RMPstats()/rRMPstats().
#
# Reported upstream: https://github.com/ERRTG/RASCHplot

library(RASCHplot)

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

# --- Bug 2: rRMPstats() ------------------------------------------------------
# Inside its bootstrap loop, rRMPstats() re-fits RASCHfits() on each simulated
# dataset and feeds the result straight into RMPstats(). But RASCHfits()'s
# polytomous delta comes back as thresholds x items - the opposite
# orientation RMPstats()/pcmfct() expect (items x thresholds) - so every
# replicate fails with "non-conformable arrays" unless it's transposed first.
rRMPstats_fixed <- function(delta, theta, method.item = c("PCML", "CML", "JML", "MML"),
                             method.person = c("WML", "MLE"), B, trace.it = 0) {
  method.item <- match.arg(method.item)
  method.person <- match.arg(method.person)
  if (!all(any(class(delta) %in% c("matrix", "data.frame")))) {
    stop("delta is not a matrix or data.frame")
  }
  X <- RASCHplot::rRMP(delta = delta, theta = theta, B = B)
  statobj <- vector(mode = "list", length = B)
  if (trace.it) cat("Simulating\n")
  for (b in 1:B) {
    fit <- RASCHplot::RASCHfits(method.item, method.person, dat = X[[b]])
    delta.sim <- t(fit$delta)
    theta.sim <- fit$theta
    statobj[[b]] <- RASCHplot::RMPstats(delta = delta.sim, theta = theta.sim, dat = X[[b]])
    if (trace.it) message(paste(b))
  }
  stats <- list(statobj = statobj, method.item = method.item, method.person = method.person)
  class(stats) <- "RASCHstats"
  stats
}
assignInNamespace("rRMPstats", rRMPstats_fixed, ns = "RASCHplot")

# --- Known residual caveat ---------------------------------------------------
# Even patched, an individual bootstrap replicate can hit a degenerate
# simulated sample (an item drawing a rare/unstable category pattern) and
# error out - the loop above has no per-replicate retry. Not seen as a
# deterministic bug, just a robustness gap; ask for a retry-wrapped version
# if a large-B production run needs to tolerate this.
