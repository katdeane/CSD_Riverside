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
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_1_ANOVA_basenorm.csv")

# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_1_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 1")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_1_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_1_basenorm.pdf")

# second call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("2")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_2_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_2_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 2")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_2_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_2_basenorm.pdf")

# third call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("3")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_3_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_3_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 3")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_3_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_3_basenorm.pdf")

# fourth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("4")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_4_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_4_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 4")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_4_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_4_basenorm.pdf")

# fifth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("5")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_5_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_5_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 5")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_5_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_5_basenorm.pdf")

# sixth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("6")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_6_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_6_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 6")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_6_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_6_basenorm.pdf")

# seventh call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("7")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_7_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_7_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 7")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_7_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_7_basenorm.pdf")

# eighth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("8")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_8_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_8_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 8")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_8_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_8_basenorm.pdf")

# ninth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("9")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_9_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_9_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 9")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_9_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_9_basenorm.pdf")

# tenth call
# Multilevel Anova
peakMC_lmer <-
  lmer(BasePeak ~ Layer * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (OrderofClick %in% c("10")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_10_ANOVA_basenorm.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_10_emmeans_basenorm.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Layer", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  scale_fill_manual(values = c("darkorange2", "grey"))+
  scale_color_manual(values = c("darkorange2", "grey"))+geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks for Call 10")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_10_basenorm.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_10_basenorm.pdf")