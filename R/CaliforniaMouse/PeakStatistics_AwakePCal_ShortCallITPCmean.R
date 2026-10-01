## SHORT CALL ITPC mean for each call time window

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

VMA_peakSC <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/VMA_ShortCall_ITPCmean.csv")
PMA_peakSC <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/PMA_ShortCall_ITPCmean.csv")

# bind groups into one dataset
ITPC_SC <- bind_rows(VMA_peakSC, PMA_peakSC)%>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="ITPC_mean") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean", "Beta_mean",
                                "GammaLow_mean", "GammaHigh_mean")))

## first call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(1)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_1_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_1_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 1")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_1_ITPC.png")

## second call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(2)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_2_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_2_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 2")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_2_ITPC.png")

## third call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(3)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_3_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_3_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 3")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_3_ITPC.png")

## fourth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(4)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_4_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_4_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 4")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_4_ITPC.png")

## fifth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(5)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_5_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_5_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 5")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_5_ITPC.png")

## sixth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(6)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_6_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_6_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 6")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_6_ITPC.png")

## seventh call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(7)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_7_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_7_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 7")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_7_ITPC.png")

## eighth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(8)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_8_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_8_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 8")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_8_ITPC.png")

## ninth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(9)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_9_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_9_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 9")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_9_ITPC.png")

## tenth call
# Multilevel Anova
peakSC_lmer <-
  lmer(log(ITPC_mean) ~ Layer * Freq * Group + (1 | Subject),
       data=ITPC_SC,
       subset = (Order_Presentation %in% c(10)),
       REML=TRUE)
write.csv(anova(peakSC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_10_ITPC_ANOVA.csv")


# posthoc contrasts
peakSC_emm <-
  emmeans(peakSC_lmer, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakSC_emm, sigma=sigma(peakSC_lmer),
           edf=df.residual(peakSC_lmer))
write_csv(left_join(as_tibble(peakSC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_10_ITPC_emmeans.csv")

# bar plots
peakSC_emm_4fig <-
  emmeans(peakSC_lmer, specs=c("Layer", "Freq", "Group"))

peakSC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=exp(upper.CL)),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("ITPC means for Call 10")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_SC_10_ITPC.png")