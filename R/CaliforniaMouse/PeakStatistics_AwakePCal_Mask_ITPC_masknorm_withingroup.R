## MASKED CALL ITPC 4 levels - within group
library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

ITPC_MC <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/VMAvPMA_MaskCallNormalization_ITPC.csv")%>%
  pivot_longer(Theta_mean:GammaHigh_mean, names_to="Freq", values_to="ITPC_mean") %>%
  mutate(Freq = factor(Freq,
                       levels=c("Theta_mean", "Alpha_mean", "Beta_mean",
                                "GammaLow_mean", "GammaHigh_mean")))%>%
  mutate(Mask = ordered(Stimulus))


## first call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 1 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_II_masknormITPC_within.png")


ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 1 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 1 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_VI_masknormITPC_within.png")

## second call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2)),
       REML=TRUE)


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 2 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 2 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 2 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_VI_masknormITPC_within.png")

## third call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 3 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 3 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 3 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_VI_masknormITPC_within.png")

## fourth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 4 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 4 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 4 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_VI_masknormITPC_within.png")

## fifth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 5 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 5 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 5 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_VI_masknormITPC_within.png")

## sixth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 6 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 6 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 6 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_VI_masknormITPC_within.png")

## seventh call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 7 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 7 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 7 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_VI_masknormITPC_within.png")

## eigth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 8 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 8 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 8 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_VI_masknormITPC_within.png")

## ninth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 9 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 9 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 9 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_VI_masknormITPC_within.png")

## tenth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10)),
       REML=TRUE)

# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Mask | Freq:Layer:Group, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer,Group),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_masknormITPC_emmeans_within.csv")

# bar plots
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("II")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 10 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_II_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_IV_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 10 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_Va_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 10 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_Vb_masknormITPC_within.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Mask, color=Mask, fill=Mask)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Group") +
  ggtitle("ITPC normed for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_VI_masknormITPC_within.png")
