# adapted from Michael A Erickson

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)
library(pbkrtest)


# Load Data
AWT_itpcNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AWT_NoiseBurst_ITPCmean.csv")
AKO_itpcNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AKO_NoiseBurst_ITPCmean.csv")
CKH_itpcNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/CKH_NoiseBurst_ITPCmean.csv")
MWT_itpcNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/MWT_NoiseBurst_ITPCmean.csv")
MKO_itpcNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/MKO_NoiseBurst_ITPCmean.csv")

# bind groups into one dataset
itpcNB <- bind_rows(AWT_itpcNB, AKO_itpcNB, CKH_itpcNB)


itpcNB <- itpcNB %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean",
                                "Beta_mean", "GammaLow_mean", "GammaHigh_mean")))

# Multilevel Anova
itpcNB_lmer <-
  lmer(Power ~ Layer * Freq * Group + (1 | Subject),
       data=itpcNB,
       REML=TRUE)
write.csv(anova(itpcNB_lmer),"E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_NBitpcs_ANOVA.csv")


# posthoc contrasts
itpcNB_emm <-
  emmeans(itpcNB_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
itpcNB_eff <-
  eff_size(itpcNB_emm, sigma=sigma(itpcNB_lmer),
           edf=df.residual(itpcNB_lmer))
write_csv(left_join(as_tibble(itpcNB_emm$contrasts),
                    mutate(as_tibble(itpcNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_NBitpcs_emmeans.csv")

# bar plots
itpcNB_emm_4fig <-
  emmeans(itpcNB_lmer, specs=c("Layer", "Freq", "Group"))

itpcNB_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL), # use asymp.LCL,asymp.UCL if no kenward-roger
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Noise Burst ITPC")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_NBitpcs.pdf")

## Anesthetized vs Awake Noise Burst
itpcNB <- bind_rows(AWT_itpcNB, AKO_itpcNB, MWT_itpcNB, MKO_itpcNB) 
itpcNB <- itpcNB %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean",
                                "Beta_mean", "GammaLow_mean", "GammaHigh_mean")))
itpcNB_lmer <-
  lmer(Power ~ Layer * Freq * Group + (1 | Subject),
       data=itpcNB,
       REML=TRUE)
write.csv(anova(itpcNB_lmer),"E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeVAnesFmr1_NBitpcs_ANOVA.csv")

itpcNB_emm <-
  emmeans(itpcNB_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
itpcNB_eff <-
  eff_size(itpcNB_emm, sigma=sigma(itpcNB_lmer),
           edf=df.residual(itpcNB_lmer))
write_csv(left_join(as_tibble(itpcNB_emm$contrasts),
                    mutate(as_tibble(itpcNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeVAnesFmr1_NBitpcs_emmeans.csv")

# bar plots
itpcNB_emm_4fig <-
  emmeans(itpcNB_lmer, specs=c("Layer", "Freq", "Group"))

itpcNB_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "MWT", "AKO", "MKO")) %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL), # use asymp.LCL,asymp.UCL if no kenward-roger
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Noise burst ITPC")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeVAnesFmr1_NBitpcs.pdf")

## CLICKS 40 Hz ASSR

AWT_itpcCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AWT_ClickTrain_ITPCmean.csv")
AKO_itpcCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AKO_ClickTrain_ITPCmean.csv")
CKH_itpcCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/CKH_ClickTrain_ITPCmean.csv")
MWT_itpcCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/MWT_ClickTrain_ITPCmean.csv")
MKO_itpcCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/MKO_ClickTrain_ITPCmean.csv")

# bind groups into one dataset
itpcCT <- bind_rows(AWT_itpcCT, AKO_itpcCT, CKH_itpcCT)%>%
  mutate(Click = ordered(Stimulus))

itpcCT <- itpcCT %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean",
                                "Beta_mean", "GammaLow_mean", "GammaHigh_mean")))

# Multilevel Anova
itpcCT_lmer <-
  lmer(Power ~ Layer * Freq * Group + (1 | Subject),
       data=itpcCT,
       subset = (Click %in% c(40)),
       REML=TRUE)
write.csv(anova(itpcCT_lmer),"E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_CT40itpcs_ANOVA.csv")


# posthoc contrasts
itpcCT_emm <-
  emmeans(itpcCT_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
itpcNB_eff <-
  eff_size(itpcCT_emm, sigma=sigma(itpcCT_lmer),
           edf=df.residual(itpcCT_lmer))
write_csv(left_join(as_tibble(itpcCT_emm$contrasts),
                    mutate(as_tibble(itpcNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_CT40itpcs_emmeans.csv")

# bar plots
itpcCT_emm_4fig <-
  emmeans(itpcCT_lmer, specs=c("Layer", "Freq", "Group"))

itpcCT_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Click Train ITPC")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_CT40itpcs.pdf")

## GAP ASSR 40 Hz

AWT_itpcGA <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AWT_gapASSR_ITPCmean.csv")
AKO_itpcGA <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AKO_gapASSR_ITPCmean.csv")
CKH_itpcGA <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/CKH_gapASSR_ITPCmean.csv")

# bind groups into one dataset
itpcGA <- bind_rows(AWT_itpcGA, AKO_itpcGA, CKH_itpcGA)%>%
  mutate(Click = ordered(Stimulus))

itpcGA <- itpcGA %>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("GammaLow_mean", "GammaHigh_mean")))

# Multilevel Anova
itpcGA_lmer <-
  lmer(Power ~ Layer * Freq * Group + (1 | Subject),
       data=itpcGA,
       subset = (Click %in% c(9)),
       REML=TRUE)
write.csv(anova(itpcGA_lmer),"E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_GA9itpcs_ANOVA.csv")


# posthoc contrasts
itpcGA_emm <-
  emmeans(itpcGA_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
itpcNB_eff <-
  eff_size(itpcGA_emm, sigma=sigma(itpcGA_lmer),
           edf=df.residual(itpcGA_lmer))
write_csv(left_join(as_tibble(itpcGA_emm$contrasts),
                    mutate(as_tibble(itpcNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_GA9itpcs_emmeans.csv")

# bar plots
itpcGA_emm_4fig <-
  emmeans(itpcGA_lmer, specs=c("Layer", "Freq", "Group"))

itpcGA_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("gap ASSR ITPC")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/ITPCmean/AwakeFmr1_GA9itpcs.pdf")













