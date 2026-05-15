# adapted from Michael A Erickson

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


# Load Data
AWT_peakNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AWT_NoiseBurst_AVRECPeak.csv")
AKO_peakNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AKO_NoiseBurst_AVRECPeak.csv")
CKH_peakNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/CKH_NoiseBurst_AVRECPeak.csv")
MWT_peakNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/MWT_NoiseBurst_AVRECPeak.csv")
MKO_peakNB <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/MKO_NoiseBurst_AVRECPeak.csv")

# bind groups into one dataset
peakNB <- bind_rows(AWT_peakNB, AKO_peakNB, CKH_peakNB)

# Multilevel Anova
peakNB_lmer <-
  lmer(PeakAmp ~ Layer * Group + (1 | Animal),
       data=peakNB,
       REML=TRUE)
write.csv(anova(peakNB_lmer),"E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_NBpeaks_ANOVA.csv")


# posthoc contrasts
peakNB_emm <-
  emmeans(peakNB_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakNB_emm, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer))
write_csv(left_join(as_tibble(peakNB_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_NBpeaks_emmeans.csv")

# bar plots
peakNB_emm_4fig <-
  emmeans(peakNB_lmer, specs=c("Layer", "Group"))

peakNB_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_NBpeaks.pdf")

## Anesthetized vs Awake Noise Burst
peakNB <- bind_rows(AWT_peakNB, AKO_peakNB, MWT_peakNB, MKO_peakNB) 

peakNB_lmer <-
  lmer(PeakAmp ~ Layer * Group + (1 | Animal),
       data=peakNB,
       subset=(ClickFreq %in% c(70)),
       REML=TRUE)
write.csv(anova(peakNB_lmer),"E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeVAnesFmr1_NBpeaks_ANOVA.csv")

peakNB_emm <-
  emmeans(peakNB_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakNB_emm, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer))
write_csv(left_join(as_tibble(peakNB_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeVAnesFmr1_NBpeaks_emmeans.csv")

# bar plots
peakNB_emm_4fig <-
  emmeans(peakNB_lmer, specs=c("Layer", "Group"))

peakNB_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "MWT", "AKO", "MKO")) %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")


ggsave("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeVAnesFmr1_NBpeaks.pdf")

## CLICKS 40 Hz ASSR

AWT_peakCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AWT_ClickTrain_AVRECPeak.csv")
AKO_peakCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AKO_ClickTrain_AVRECPeak.csv")
CKH_peakCT <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/CKH_ClickTrain_AVRECPeak.csv")

# bind groups into one dataset
peakCT <- bind_rows(AWT_peakCT, AKO_peakCT, CKH_peakCT)%>%
  mutate(Click = ordered(OrderofClick))

# Multilevel Anova
peakCT_lmer <-
  lmer(PeakAmp ~ Layer * Click * Group + (1 | Animal),
       data=peakCT,
       subset = (ClickFreq %in% c(40) & Click %in% c(3, 10, 20, 40, 80)),
       REML=TRUE)
write.csv(anova(peakCT_lmer),"E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_CTpeaks_ANOVA.csv")


# posthoc contrasts
peakCT_emm <-
  emmeans(peakCT_lmer, pairwise ~ Group | Click:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakCT_emm, sigma=sigma(peakCT_lmer),
           edf=df.residual(peakCT_lmer))
write_csv(left_join(as_tibble(peakCT_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_CTpeaks_emmeans.csv")

# bar plots
peakCT_emm_4fig <-
  emmeans(peakCT_lmer, specs=c("Layer", "Click", "Group"))

peakCT_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=Click, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_CTpeaks.pdf")

