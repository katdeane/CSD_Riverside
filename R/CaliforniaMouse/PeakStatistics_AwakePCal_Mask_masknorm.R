## MASKED CALL 4 levels - between group

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMAvPMA_MaskCallNormalization.csv")%>%
  mutate(Mask = ordered(SoundLevel))


## first call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 1 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 1 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 1 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_VI_masknorm.png")

## second call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 2 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 2 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 2 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_VI_masknorm.png")

## third call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 3 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 3 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 3 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_VI_masknorm.png")

## fourth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 4 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 4 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 4 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_VI_masknorm.png")

## fifth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 5 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 5 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 5 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_VI_masknorm.png")

## sixth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 6 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 6 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 6 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_VI_masknorm.png")

## seventh call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 7 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 7 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 7 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_VI_masknorm.png")

## eigth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 8 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 8 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 8 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_VI_masknorm.png")

## ninth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 9 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 9 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 9 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_VI_masknorm.png")

## tenth call
# Multilevel Anova
peakMC_lmer <-
  lmer(MaskNormPeak ~ Layer * Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10)),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_masknorm_ANOVA.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_masknorm_emmeans.csv")

# bar plots
peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10) & Layer %in% c("II")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 10 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_II_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_IV_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10) & Layer %in% c("Va")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 10 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_Va_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10) & Layer %in% c("Vb")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 10 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_Vb_masknorm.png")

peakMC_lmer <-
  lmer(MaskNormPeak ~ Mask * Group + (1 | Subject),
       data=peakMC,
       subset = (OrderofCall %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=1, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks normed for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_VI_masknorm.png")
