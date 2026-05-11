# adapted from Michael A Erickson

library(tidyverse)
library(lme4)
library(Matrix)
library(lmerTest)
library(emmeans)


# Load Data
AWT_peakNB <- read_csv("E:/CSD_Riverside/output/DataforStatsAwakeFmr1/AWT_NoiseBurst_SingleTrialPeaks.csv")
AKO_peakNB <- read_csv("E:/CSD_Riverside/output/DataforStatsAwakeFmr1/AKO_NoiseBurst_SingleTrialPeaks.csv")
CKH_peakNB <- read_csv("E:/CSD_Riverside/output/DataforStatsAwakeFmr1/CKH_NoiseBurst_SingleTrialPeaks.csv")

# bind groups into one dataset
peakNB <- bind_rows(AWT_peakNB, AKO_peakNB, CKH_peakNB)

# Multilevel Anova
peakNB_lmer <-
  lmer(PeakAmp ~ Layer * Group + (1 | Animal),
       data=peakNB,
       REML=TRUE)
write.csv(anova(peakNB_lmer),"AwakeFmr1_NBpeaks_ANOVA.csv")

peakNB_lmer_log <-
  lmer(log(PeakAmp) ~ Layer * Group + (1 | Animal),
       data=peakNB,
       REML=TRUE)
write.csv(anova(peakNB_lmer_log),"AwakeFmr1_NBpeaks_ANOVAlog.csv")

# posthoc contrasts
peakNB_emm <-
  emmeans(peakNB_lmer, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakNB_emm, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer))
write_csv(left_join(as_tibble(peakNB_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer),
                    suffix=c(".contr", ".eff_size")),
          "AwakeFmr1_NBpeaks_emmeans.csv")

# bar plots
peakNB_emm_forfig <-
  emmeans(peakNB_lmer, specs=c("Layer", "Group"))
peakNB_margemm_forfig <-
  emmeans(peakNB_lmer, specs=c("Group"))
peakNB_fig <-
  bind_rows(as_tibble(peakNB_emm_forfig),
            as_tibble(peakNB_margemm_forfig))

#peakNB_fig %>%
#  as_tibble() %>%
#  ## filter(Freq != "delta") %>%
#  ggplot(aes(x=??, y=emmean, group=Group, color=Group, fill=Group)) +
#  geom_bar(stat="identity", position="dodge") +
#  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
#                width=0.5, position="dodge") +
#  ## scale_color_viridis_d(option="G") +
#  ## scale_fill_viridis_d(option="G") +
#  facet_wrap("Layer") +
#  ggtitle("Peaks")


# log transformed contrasts
peakNB_emm_log <-
  emmeans(peakNB_lmer_log, pairwise ~ Group | Layer, p.adjust="hochberg")
peakNB_eff_log <-
  eff_size(peakNB_emm_log, sigma=sigma(peakNB_lmer),
           edf=df.residual(peakNB_lmer_log))
write_csv(left_join(as_tibble(peakNB_emm_log$contrasts),
                    mutate(as_tibble(peakNB_eff_log),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Layer),
                    suffix=c(".contr", ".eff_size")),
          "AwakeFmr1_NBpeaks_emmeanslog.csv")


## CLICKS 40 Hz ASSR
