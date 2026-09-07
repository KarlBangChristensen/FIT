percentile_RASCHstats <- function(x, value, type = "Outfit", extreme = c("min", "max")) {
  extreme <- match.arg(extreme)
  z <- switch(extreme,
              min = sapply(x$statobj, function(s) min(s[[type]])),
              max = sapply(x$statobj, function(s) max(s[[type]])))
  mean(z[!is.na(z)] <= value)
}

percentile_RASCHstats(sim_pcml, value = -2.65, type = "FitResid", extreme = "min")
1-percentile_RASCHstats(sim_pcml, value = 2.30, type = "FitResid", extreme = "max")

percentile_RASCHstats(sim_jml, value = 0.57, type = "Outfit", extreme = "min")
1-percentile_RASCHstats(sim_pcml, value = 1.34, type = "Outfit", extreme = "max")

percentile_RASCHstats(sim_jml, value = 0.66, type = "Infit", extreme = "min")
1-percentile_RASCHstats(sim_pcml, value = 1.25, type = "Infit", extreme = "max")

