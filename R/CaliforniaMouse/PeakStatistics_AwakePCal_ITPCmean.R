## ITPC mean response

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


# Noise Burst 

# load data
P_ITPCNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/PMA_NoiseBurst_ITPCmean.csv")
V_ITPCNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/VMA_NoiseBurst_ITPCmean.csv")  
  
ITPCNB <- bind_rows(V_ITPCNB, P_ITPCNB) %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="ITPC_mean") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean", "Beta_mean",
                                "GammaLow_mean", "GammaHigh_mean")))

## Multi-level ANOVA with log values 
ITPCNB_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject), ITPCNB,
       REML=TRUE)
write.csv(anova(ITPCNB_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/pCal_NoiseITPC_ANOVA.csv")

# post hoc contrasts 
ITPCNB_emm <- emmeans(ITPCNB_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
# effect size
ITPCNB_ef <-
  eff_size(ITPCNB_emm, sigma=sigma(ITPCNB_lmer),
           edf=df.residual(ITPCNB_lmer))
write_csv(left_join(as_tibble(ITPCNB_emm$contrasts),
                    mutate(as_tibble(ITPCNB_ef),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/pCal_NoiseITPC_emmeans.csv")

# bar plots 
emm_4plot <- emmeans(ITPCNB_lmer, specs=c("Layer", "Freq", "Group"))
emm_4plot %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)), width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Noise Burst 1 Hz ITPC means")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/pCal_NoiseITPC.png")


## CLICKS 5 Hz ASSR

VMA_peakCT <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/VMA_ClickTrain_ITPCmean.csv")
PMA_peakCT <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/PMA_ClickTrain_ITPCmean.csv")

# bind groups into one dataset
ITPC_CT <- bind_rows(VMA_peakCT, PMA_peakCT) %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="ITPC_mean") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean", "Beta_mean",
                                "GammaLow_mean", "GammaHigh_mean")))

# Multilevel Anova
peakCT_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_CT,
       subset = (Stimulus %in% c(5)),
       REML=TRUE)
write.csv(anova(peakCT_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_CTpeaksITPC_ANOVA.csv")

# posthoc contrasts
peakCT_emm <-
  emmeans(peakCT_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakCT_emm, sigma=sigma(peakCT_lmer),
           edf=df.residual(peakCT_lmer))
write_csv(left_join(as_tibble(peakCT_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_CTpeaksITPC_emmeans.csv")

# bar plots
peakCT_emm_4fig <-
  emmeans(peakCT_lmer, specs=c("Layer", "Freq", "Group"))

peakCT_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Click Train 5 Hz ITPC means")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_CTpeaksITPC.png")

