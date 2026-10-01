## MaskCall ITPC mean for each call time window

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

VMA_ITPC_MC <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/VMA_MaskCall_ITPCmean.csv")
PMA_ITPC_MC <- read_csv("E:/CSD_Riverside/output/CaliAwake/ITPCmean/PMA_MaskCall_ITPCmean.csv")

# bind groups into one dataset
ITPC_MC <- bind_rows(VMA_ITPC_MC, PMA_ITPC_MC)%>%
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
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 1 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 1 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 1 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(1) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 1 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_1_VI_ITPC.png")

## second call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 2 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 2 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 2 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(2) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 2 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_2_VI_ITPC.png")

## third call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 3 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 3 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 3 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(3) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 3 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_3_VI_ITPC.png")

## fourth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 4 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 4 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 4 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(4) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 4 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_4_VI_ITPC.png")

## fifth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 5 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 5 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 5 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(5) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 5 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_5_VI_ITPC.png")

## sixth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 6 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 6 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 6 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(6) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 6 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_6_VI_ITPC.png")

## seventh call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 7 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 7 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 7 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(7) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 7 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_7_VI_ITPC.png")

## eigth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 8 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 8 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 8 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(8) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 8 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_8_VI_ITPC.png")

## ninth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 9 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 9 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 9 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(9) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 9 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_9_VI_ITPC.png")

## tenth call
# Multilevel Anova
ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Layer * Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10)),
       REML=TRUE)
write.csv(anova(ITPC_MC_lmer),"E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_ITPC_ANOVA.csv")


# posthoc contrasts
ITPC_MC_emm <-
  emmeans(ITPC_MC_lmer, pairwise ~ Group | Freq:Layer:Mask, p.adjust="hochberg")
peakNB_eff <-
  eff_size(ITPC_MC_emm, sigma=sigma(ITPC_MC_lmer),
           edf=df.residual(ITPC_MC_lmer))
write_csv(left_join(as_tibble(ITPC_MC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Freq, Layer, Mask),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_ITPC_emmeans.csv")

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
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 10 LI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_II_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_IV_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("Va")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 10 LVa")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_Va_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("Vb")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 10 LVb")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_Vb_ITPC.png")

ITPC_MC_lmer <-
  lmer(ITPC_mean ~ Freq * Mask * Group + (1 | Subject),
       data=ITPC_MC,
       subset = (Order_Presentation %in% c(10) & Layer %in% c("VI")),
       REML=TRUE)

ITPC_MC_emm_4fig <-
  emmeans(ITPC_MC_lmer, specs=c("Freq", "Group","Mask"))

ITPC_MC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=0, ymax=upper.CL),
                width=0.9, position="dodge") +
  facet_wrap("Mask") +
  ggtitle("ITPC means for Call 10 LVI")

ggsave("E:/CSD_Riverside/output/CaliAwake/ITPCmean/CaliAwake_MC_10_VI_ITPC.png")



