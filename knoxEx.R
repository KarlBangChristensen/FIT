colpal <- c("#CFCFC2", "#95DA4C", "#3F8058", "#2980B9", "#F67400", "#7F8C8D", "#FDBC4B", "#3DAEE9", "#27AEAE", "#7A7C7D", "#7F8C8D", "#A43340", "#2980B9", "#F67400", "#DA4453", "#0099FF", "#F67400", "#8E44AD", "#27AE60", "#C45B00", "#CFCFC2", "#CFCFC2", "#27AE60", "#27AE60", "#2980B9", "#3DAEE9", "#DA4453", "#F44F4F", "#27AEAE", "#DA4453", "#DA4453")
library(ggplot2)

#============================= AMTS ============================================

#install.packages("devtools")
#devtools::install_github("ERRTG/RASCHplot")
library(RASCHplot)

library(pairwise)
data(KCT)
dim(KCT)
novar <- which(apply(KCT, 2, function(x) var(x) == 0))
dat <- KCT[, -novar]
test <- which(rowSums(dat) %in% c(0,ncol(dat)))
dat <- dat[-test, ]
novar <- which(apply(dat, 2, function(x) var(x) == 0))

fit <- RASCHfits(method.item = "PCML",
                 method.person = "WML",
                 dat = dat)
beta <- fit$beta
theta <- fit$theta
#names(beta) <- colnames(amts)[4:13]

stats <- RASCHstats(beta, theta, dat)
outfits <- data.frame(x = stats$Outfit,
                      y = rep(0, length(stats$Outfit)))

theta <- read.csv("Knox_pp.csv")[,1]
beta <- read.csv("Knox_ip.csv")[,1]

x <- simRASCHstats(beta, theta,
                   method.item = "PCML",
                   method.person = "WML",
                   B = 1000)

save(x, file = "knoxstats.RData")

my_colors <- colpal[c(12, 28, 1)]
names(my_colors) <- c("2.5%", "5%", "other")

theme_set(theme_minimal() + theme(legend.title = element_blank(),
                                  plot.title = element_text(size = 8, hjust = 0.5),
                                  text = element_text(size = 8)))
plot(x, type = "FitResid")

plot(x, extreme = "max", type = "FitResid")

p1 <- plot(x, type = "FitResid", colours = my_colors, title = "")

ggsave("knoxFitResidMin.pdf", width = 11, height = 8, units = "cm")

p2 <- plot(x, type = "FitResid", extreme = "max", colours = my_colors, title = "") #+
  #geom_point(data = outfits,
  #           size = 1.5) +
  #geom_text(data = outfits, aes(label = 1:nrow(outfits)), vjust = -2, size = 2)

ggsave("knoxFitResidMax.pdf", width = 11, height = 8, units = "cm")

ggpubr::ggarrange(p1, p2, legend = "bottom", common.legend = TRUE)

ggsave("knoxFitResid.pdf", width = 11, height = 8, units = "cm")

