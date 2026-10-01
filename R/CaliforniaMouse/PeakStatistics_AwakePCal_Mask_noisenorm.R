## MASKED CALL 4 levels

VMA_peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMA_MaskCall_AVRECPeak.csv")
PMA_peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/PMA_MaskCall_AVRECPeak.csv")

# bind groups into one dataset
peakMC <- bind_rows(VMA_peakMC, PMA_peakMC)%>%
  mutate(Click = ordered(OrderofClick))%>%
  mutate(Mask = ordered(ClickFreq))

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("All")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_ALL.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_ALL.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
facet_wrap("Mask") +
ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_ALL.pdf")


## LAYER II
## MASKED CALL 4 levels

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("II")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_II.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_II.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_II.pdf")


## LAYER IV
## MASKED CALL 4 levels

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("IV")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_IV.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_IV.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_IV.pdf")



## LAYER Va
## MASKED CALL 4 levels

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("Va")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_Va.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_Va.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_Va.pdf")



## LAYER Vb
## MASKED CALL 4 levels

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("Vb")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_Vb.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_Vb.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_Vb.pdf")


## LAYER VI
## MASKED CALL 4 levels

# Multilevel Anova
peakMC_lmer <-
  lmer(log(NormPeak) ~ Click * Group * Mask + (1 | Animal),
       data=peakMC,
       subset = (Layer %in% c("VI")),
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_ANOVA_noisenorm_VI.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Click:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Click, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_emmeans_noisenorm_VI.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Mask", "Click", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Click, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("Peaks")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_MCpeaks_noisenorm_VI.pdf")