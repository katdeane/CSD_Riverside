## MaskCall Habituation measure
# response to each call divided by peak onset response per subject within each layer

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMAvPMA_MaskCallAdaptation.csv")%>%
  mutate(Mask = ordered(SoundLevel))%>%
  filter(Layer != "All")

# first call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("1")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_1_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_1_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 1")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_1_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_1_habituation.pdf")

# second call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("2")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_2_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_2_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 2")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_2_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_2_habituation.pdf")

# third call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("3")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_3_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_3_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 3")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_3_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_3_habituation.pdf")

# fourth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("4")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_4_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_4_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 4")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_4_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_4_habituation.pdf")

# fifth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("5")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_5_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_5_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 5")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_5_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_5_habituation.pdf")
# sixth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("6")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_6_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_6_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 6")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_6_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_6_habituation.pdf")
# seventh call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("7")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_7_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_7_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 7")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_7_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_7_habituation.pdf")

# eighth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("8")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_8_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_8_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 8")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_8_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_8_habituation.pdf")

# ninth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("9")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_9_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_9_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 9")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_9_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_9_habituation.pdf")

# tenth call
# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Mask + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c("10")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_10_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_10_emmeans_habituation.csv")


# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Mask", "Group"))

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
  ggtitle("Ratio Peaks to Call 10")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_10_habituation.png")
ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCratio_10_habituation.pdf")

