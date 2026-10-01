## MASKED CALL 4 levels - between group

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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 1")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_1_masknorm.png")

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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 2")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_2_masknorm.png")

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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 3")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_3_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 4")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_4_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 5")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_5_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 6")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_6_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 7")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_7_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 8")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_8_masknorm.png")


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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 9")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_9_masknorm.png")

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
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer","Group","Mask"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Mask, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Peaks normed for Call 10")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MCpeaks_10_masknorm.png")
