colpal <- c("#CFCFC2", "#95DA4C", "#3F8058", "#2980B9", "#F67400", "#7F8C8D", "#FDBC4B", "#3DAEE9", "#27AEAE", "#7A7C7D", "#7F8C8D", "#A43340", "#2980B9", "#F67400", "#DA4453", "#0099FF", "#F67400", "#8E44AD", "#27AE60", "#C45B00", "#CFCFC2", "#CFCFC2", "#27AE60", "#27AE60", "#2980B9", "#3DAEE9", "#DA4453", "#F44F4F", "#27AEAE", "#DA4453", "#DA4453")
library(ggplot2); library(readr)

#============================= AMTS ============================================

#install.packages("iarm")
library(iarm)
data(amts)

#install.packages("devtools")
#devtools::install_github("ERRTG/RASCHplot")
library(RASCHplot)

it.AMTS <- amts[,4:13]
it.AMTSc <- it.AMTS[complete.cases(it.AMTS), ]
idx <- which(rowSums(it.AMTSc) %in% c(0,ncol(it.AMTSc)))
dat <- it.AMTSc[-idx,]

fit <- RASCHfits(method.item = "PCML",
                 method.person = "WML",
                 dat = dat)
beta <- fit$beta
theta <- fit$theta
#names(beta) <- colnames(amts)[4:13]

stats <- RASCHstats(beta, theta, dat)
outfits <- data.frame(x = stats$Outfit,
                      y = rep(0, length(stats$Outfit)))

write_csv(data.frame(beta = beta), 'amtsbeta.csv')
write_csv(data.frame(theta = theta), 'amtstheta.csv')
write_csv(data.frame(outfit = stats$Outfit), 'amtsoutfit.csv')

beta  <- read_csv("amtsbeta.csv")$beta
theta <- read_csv("amtstheta.csv")$theta

x <- simRASCHstats(beta, theta,
                   method.item = "PCML",
                   method.person = "WML",
                   B = 1000)

save(x, file = "amtsstats.RData")

my_colors <- colpal[c(12, 28, 1)]
names(my_colors) <- c("2.5%", "5%", "other")

theme_set(theme_minimal() + theme(legend.title = element_blank(),
                                  plot.title = element_text(size = 8, hjust = 0.5),
                                  text = element_text(size = 8)))
plot(x)

plot(x, extreme = "max")

# Outfit

p1 <- plot(x, colours = my_colors, title = "") 

ggsave("amtsOutfitMin.pdf", plot = p1, width = 11, height = 8, units = "cm")

p2 <- plot(x, extreme = "max", colours = my_colors, title = "") 

ggsave("amtsOutfitMax.pdf", plot = p2, width = 11, height = 8, units = "cm")

ggpubr::ggarrange(p1, p2, legend = "bottom", common.legend = TRUE)

ggsave("amtsOutfit.pdf", width = 11, height = 8, units = "cm")

# Infit

p3 <- plot(x, type = "Infit", colours = my_colors, title = "") 

ggsave("amtsInfitMin.pdf", plot = p3, width = 11, height = 8, units = "cm")

p4 <- plot(x, type = "Infit", extreme = "max", colours = my_colors, title = "") 

ggsave("amtsInfitMax.pdf", plot = p4, width = 11, height = 8, units = "cm")

ggpubr::ggarrange(p3, p4, legend = "bottom", common.legend = TRUE)

ggsave("amtsInfit.pdf", width = 11, height = 8, units = "cm")
