color_palette <- c("#CFCFC2", "#95DA4C", "#3F8058", "#2980B9", "#F67400", "#7F8C8D", "#FDBC4B", "#3DAEE9", "#27AEAE", "#7A7C7D", "#7F8C8D", "#A43340", "#2980B9", "#F67400", "#DA4453", "#0099FF", "#F67400", "#8E44AD", "#27AE60", "#C45B00", "#CFCFC2", "#CFCFC2", "#27AE60", "#27AE60", "#2980B9", "#3DAEE9", "#DA4453", "#F44F4F", "#27AEAE", "#DA4453", "#DA4453")
library(ggplot2); library(readr)

#install.packages("iarm")
library(iarm)
data(amts)

#install.packages("devtools")
#devtools::install_github("ERRTG/RASCHplot")
library(RASCHplot)

amts_items          <- amts[,4:13]
amts_items_complete <- amts_items[complete.cases(amts_items), ]
extreme_score_idx   <- which(rowSums(amts_items_complete) %in% c(0,ncol(amts_items_complete)))
amts_data           <- amts_items_complete[-extreme_score_idx,]

###################################
# RUMM-ish                        #
###################################

fit_pcml   <- RASCHfits(method.item = "PCML",
                        method.person = "WML",
                        dat = amts_data)
delta_pcml <- fit_pcml$delta
theta_pcml <- fit_pcml$theta
names(delta_pcml) <- colnames(amts)[4:13]

stats_pcml <- RMDstats(delta = delta_pcml, theta = theta_pcml, dat = amts_data)

fitresid_df_pcml <- data.frame(x = stats_pcml$FitResid, y = rep(0, length(stats_pcml$FitResid)))

sim_pcml <- rRMDstats(delta = delta_pcml,
                      theta = theta_pcml,
                      method.item = "PCML",
                      method.person = "WML",
                      B = 2000)

save(sim_pcml, file = "amtsstats_pcml.RData")

legend_colors <- color_palette[c(12, 28, 1)]
names(legend_colors) <- c("2.5%", "5%", "other")

theme_set(theme_minimal() + theme(legend.title = element_blank(),
                                  plot.title = element_text(size = 8, hjust = 0.5),
                                  text = element_text(size = 8)))
plot(sim_pcml)

plot(sim_pcml, extreme = "min")

# FitResid

p_fitresid_min_pcml <- plot(sim_pcml, type = "FitResid", extreme = "min", colours = legend_colors, title = "")
ggsave("amtsFitResidMin.pdf", plot = p_fitresid_min_pcml, width = 11, height = 8, units = "cm")
p_fitresid_max_pcml <- plot(sim_pcml, type = "FitResid", extreme = "max", colours = legend_colors, title = "")
ggsave("amtsFitResidMax.pdf", plot = p_fitresid_max_pcml, width = 11, height = 8, units = "cm")
ggpubr::ggarrange(p_fitresid_min_pcml, p_fitresid_max_pcml, legend = "bottom", common.legend = TRUE)
ggsave("amtsFitResid.pdf", width = 11, height = 8, units = "cm")

###################################
# winsteps-ish                    #
###################################


fit_jml   <- RASCHfits(method.item = "JML",
                       method.person = "MLE",
                       dat = amts_data)
delta_jml <- fit_jml$delta
theta_jml <- fit_jml$theta

write_csv(data.frame(delta = delta_jml), 'amtsdelta.csv')
write_csv(data.frame(theta = theta_jml), 'amtstheta.csv')

names(delta_jml) <- colnames(amts)[4:13]

stats_jml <- RMDstats(delta = delta_jml, theta = theta_jml, dat = amts_data)

outfit_df_jml <- data.frame(x = stats_jml$Outfit, y = rep(0, length(stats_jml$Outfit)))
infit_df_jml  <- data.frame(x = stats_jml$Infit, y = rep(0, length(stats_jml$Infit)))

write_csv(data.frame(outfit = stats_jml$Outfit), 'amtsoutfit.csv')

delta_jml <- read_csv("amtsdelta.csv")$delta
theta_jml <- read_csv("amtstheta.csv")$theta

sim_jml <- rRMDstats(delta = delta_jml,
                     theta = theta_jml,
                     method.item = "JML",
                     method.person = "MLE",
                     B = 2000)

save(sim_jml, file = "amtsstats_jml.RData")

legend_colors <- color_palette[c(12, 28, 1)]
names(legend_colors) <- c("2.5%", "5%", "other")

theme_set(theme_minimal() + theme(legend.title = element_blank(),
                                  plot.title = element_text(size = 8, hjust = 0.5),
                                  text = element_text(size = 8)))
plot(sim_jml)

plot(sim_jml, extreme = "min")

# Outfit

p_outfit_min_jml <- plot(sim_jml, colours = legend_colors, title = "")
ggsave("amtsOutfitMin.pdf", plot = p_outfit_min_jml, width = 11, height = 8, units = "cm")
p_outfit_max_jml <- plot(sim_jml, extreme = "max", colours = legend_colors, title = "")
ggsave("amtsOutfitMax.pdf", plot = p_outfit_max_jml, width = 11, height = 8, units = "cm")
ggpubr::ggarrange(p_outfit_min_jml, p_outfit_max_jml, legend = "bottom", common.legend = TRUE)
ggsave("amtsOutfit.pdf", width = 11, height = 8, units = "cm")

# Infit

p_infit_min_jml <- plot(sim_jml, type = "Infit", colours = legend_colors, title = "")
ggsave("amtsInfitMin.pdf", plot = p_infit_min_jml, width = 11, height = 8, units = "cm")
p_infit_max_jml <- plot(sim_jml, type = "Infit", extreme = "max", colours = legend_colors, title = "")
ggsave("amtsInfitMax.pdf", plot = p_infit_max_jml, width = 11, height = 8, units = "cm")
ggpubr::ggarrange(p_infit_min_jml, p_infit_max_jml, legend = "bottom", common.legend = TRUE)
ggsave("amtsInfit.pdf", width = 11, height = 8, units = "cm")





