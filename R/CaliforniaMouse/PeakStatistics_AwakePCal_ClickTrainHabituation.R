## Click Train Habituation measure
# response to click at 1 s divided by peak onset response per subject within each layer

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMAvPMA_ClickTrainAdaptation.csv")%>%
  mutate(ClickFreq = ordered(ClickFreq))

## ClickFreq 120
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer + (1 | Subject),
       data=peakMC,
       subset = (ClickFreq %in% c("120")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_habituation_120.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_habituation_120.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Layer, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  ggtitle("120 Hz Habituated Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_habituation_120.png")


## ClickFreq 80
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer + (1 | Subject),
       data=peakMC,
       subset = (ClickFreq %in% c("80")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_habituation_80.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_habituation_80.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Layer, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  ggtitle("80 Hz Habituated Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_habituation_80.png")

## ClickFreq 40
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer + (1 | Subject),
       data=peakMC,
       subset = (ClickFreq %in% c("40")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_habituation_40.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_habituation_40.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Layer, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  ggtitle("40 Hz Habituated Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_habituation_40.png")


## ClickFreq 10
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer + (1 | Subject),
       data=peakMC,
       subset = (ClickFreq %in% c("10")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_habituation_10.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_habituation_10.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Layer, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  ggtitle("10 Hz Habituated Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_habituation_10.png")


## ClickFreq 5
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer + (1 | Subject),
       data=peakMC,
       subset = (ClickFreq %in% c("5")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_ANOVA_habituation_5.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_emmeans_habituation_5.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Layer, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  ggtitle("5 Hz Habituated Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_CTpeaks_habituation_5.png")


