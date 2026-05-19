# adapted from Michael A Erickson

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)




# Load Data
peakRatio <- read_csv("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AWTvAKOvCKH_ClickTrainAdaptation.csv")

peakRatio <- peakRatio %>%
  mutate(Rate = ordered(ClickFreq))

# Multilevel Anova
peakRatio_lmer <-
  lmer(RatioPeak ~ Layer * Group * Rate + (1 | Subject),
       data=peakRatio,
       REML=TRUE)
write.csv(anova(peakRatio_lmer),"E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_Adaptation_ANOVA.csv")

# posthoc contrasts
peakRatio_emm <-
  emmeans(peakRatio_lmer, pairwise ~ Group | Rate:Layer, p.adjust="hochberg")
peakRatio_eff <-
  eff_size(peakRatio_emm, sigma=sigma(peakRatio_lmer),
           edf=df.residual(peakRatio_lmer))
write_csv(left_join(as_tibble(peakRatio_emm$contrasts),
                    mutate(as_tibble(peakRatio_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Rate, Layer),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_Adaptation_emmeans.csv")

# bar plots
peakRatio_emm_4fig <-
  emmeans(peakRatio_lmer, specs=c("Layer", "Rate", "Group"))

peakRatio_emm_4fig %>%
  as_tibble() %>%
  mutate(Group = fct_relevel(Group, 
                             "AWT", "AKO", "CKH")) %>%
  ggplot(aes(x=Rate, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Ratio to onset at 1 s")

ggsave("E:/CSD_Riverside/output/Fmr1Awake/TracePeaks/AwakeFmr1_Adaptation.pdf")