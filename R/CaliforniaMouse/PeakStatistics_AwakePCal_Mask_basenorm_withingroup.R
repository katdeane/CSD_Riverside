## MASKED CALL 4 levels
library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

VMA_peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_MaskCall_AVRECPeak.csv")
PMA_peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_MaskCall_AVRECPeak.csv")

# bind groups into one dataset
peakMC <- bind_rows(VMA_peakMC, PMA_peakMC)%>%
  mutate(Mask = ordered(ClickFreq))

# first call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("1")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_1_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 1")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_1_within.png")


# second call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("2")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_2_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 2")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_2_within.png")

# third call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("3")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_3_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 3")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_3_within.png")

# fourth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("4")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_4_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 4")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_4_within.png")

# fifth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("5")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_5_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 5")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_5_within.png")

# sixth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("6")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_6_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 6")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_6_within.png")

# seventh call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("7")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_7_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 7")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_7_within.png")

# eighth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("8")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_8_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 8")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_8_within.png")

# ninth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("9")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_9_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 9")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_9_within.png")

# tenth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("10")),
       REML=TRUE)

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Mask| Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_basenorm_10_within.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Group, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 10")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_basenorm_10_within.png")