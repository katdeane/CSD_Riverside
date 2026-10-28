# adapted from Michael A Erickson

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


# Load Data
VMA_peakNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_NoiseBurst_AVRECPeak.csv")
PMA_peakNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_NoiseBurst_AVRECPeak.csv")

# bind groups into one dataset
peakNB <- bind_rows(VMA_peakNB, PMA_peakNB)

# Multilevel Anova
peakNB_lmer <-
  lmer(log(BasePeak) ~ Layer * Group + (1 | Animal),
       data=peakNB,
       REML=TRUE)
write.csv(anova(peakNB_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NBpeaks_ANOVA_basenorm.csv")


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
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NBpeaks_emmeans_basenorm.csv")

# bar plots
peakNB_emm_4fig <-
  emmeans(peakNB_lmer, specs=c("Layer", "Group"))

peakNB_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NBpeaks_basenorm.png")



## CLICKS 5 Hz ASSR

VMA_peakCT <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_ClickTrain_AVRECPeak.csv")
PMA_peakCT <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_ClickTrain_AVRECPeak.csv")

# bind groups into one dataset
peakCT <- bind_rows(VMA_peakCT, PMA_peakCT)%>%
  mutate(Click = ordered(OrderofClick))

# Multilevel Anova
peakCT_lmer <-
  lmer(BasePeak ~ Layer * Click * Group + (1 | Animal),
       data=peakCT,
       subset = (ClickFreq %in% c(5) & Click %in% c(1, 5, 10)),
       REML=TRUE)
write.csv(anova(peakCT_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_basenorm.csv")

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
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_basenorm.csv")

# bar plots
peakCT_emm_4fig <-
  emmeans(peakCT_lmer, specs=c("Layer", "Click", "Group"))

peakCT_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_basenorm.png")


## SHORT CALL

VMA_peakSC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_ShortCall_AVRECPeak.csv")
PMA_peakSC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_ShortCall_AVRECPeak.csv")

# bind groups into one dataset
peakSC <- bind_rows(VMA_peakSC, PMA_peakSC)%>%
  mutate(Click = ordered(OrderofClick))

# Multilevel Anova
peakSC_lmer <-
  lmer(log(BasePeak) ~ Layer * Click * Group + (1 | Animal),
       data=peakSC,
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_SCpeaks_ANOVA_basenorm.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Click:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_SCpeaks_emmeans_basenorm.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Click", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_SCpeaks_basenorm.png")

## Noiseburst 2.5 Hz

# Load Data
VMA_peakNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_NoiseBurst2pt5Hz_AVRECPeak.csv")
PMA_peakNB <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_NoiseBurst2pt5Hz_AVRECPeak.csv")

# bind groups into one dataset
peakNB <- bind_rows(VMA_peakNB, PMA_peakNB)%>%
  mutate(Click = ordered(OrderofClick))

# Multilevel Anova
peakNB_lmer <-
  lmer(log(BasePeak) ~ Layer * Click * Group + (1 | Animal),
       data=peakNB,
       subset = (ClickFreq %in% c("20")),
       REML=TRUE)
write.csv(anova(peakNB_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_ANOVA_basenorm_20.csv")


# posthoc contrasts
peakNB_emm <-
  emmeans(peakNB_lmer, pairwise ~ Group | Click:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakNB_emm, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer))
write_csv(left_join(as_tibble(peakNB_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Click, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_emmeans_basenorm_20.csv")

# bar plots
peakNB_emm_4fig <-
  emmeans(peakNB_lmer, specs=c("Click","Layer", "Group"))

peakNB_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer")+
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_basenorm_20.png")

# Multilevel Anova
peakNB_lmer <-
  lmer(log(BasePeak) ~ Layer * Click * Group + (1 | Animal),
       data=peakNB,
       subset = (ClickFreq %in% c("70")),
       REML=TRUE)
write.csv(anova(peakNB_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_ANOVA_basenorm_70.csv")


# posthoc contrasts
peakNB_emm <-
  emmeans(peakNB_lmer, pairwise ~ Group | Click:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakNB_emm, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer))
write_csv(left_join(as_tibble(peakNB_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Click, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_emmeans_basenorm_70.csv")

# bar plots
peakNB_emm_4fig <-
  emmeans(peakNB_lmer, specs=c("Click","Layer", "Group"))

peakNB_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer")+
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_NB2pt5Hzpeaks_basenorm_70.png")



