# adapted from Michael A Erickson

library(tidyverse)
library(lme4)
library(Matrix)
library(lmerTest)
library(emmeans)

# Load Data

spont_fft <- read_csv("E:/CSD_Riverside/output/DataforStatsAwakeFmr1/AWTvAKOvCKH_Spontaneous_RE_FFTData.csv")

# assign frequency columns an umbrella tag

spont_fft_l <- spont_fft %>%
  pivot_longer(delta:highgam, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("delta", "theta", "alpha",
                                "beta", "lowgam", "highgam")))

# compute means for each mouse
spont_fft_mouse_l <- spont_fft_l %>%
  group_by(Group, Subject, Condition, Layer, Freq) %>%
  summarize(Power=mean(Power),
            log_Power=mean(log(Power)),
            .groups="drop_last") %>%
  ungroup()
spont_fft_l %>%
  group_by(Group, Subject, Condition) %>%
  filter(Condition=="Spontaneous") %>%
  summarize(Power=mean(Power),
            .groups="drop_last") %>%
  ungroup() %>%
  ggplot(aes(x=Group, y=Power)) +
  geom_boxplot(outlier.shape=NA) +
  geom_jitter(width=.1, alpha=.5, size=2)

## Multi-level ANOVA with raw power values (normalized by WT)
# all layers 
l_all_spont <-
  lmer(Power ~ Layer * Freq * Group + (1 | Subject), spont_fft_l,
       subset=(Condition == "Spontaneous"),
       REML=TRUE)
write.csv(anova(l_all_spont),"AwakeFmr1_SpontFFT_ANOVA.csv")

# post hoc contrasts 
l_spont_emm <- emmeans(l_all_spont, pairwise ~ Group | Freq:Layer, p.adjust="hochberg")
# effect size
l_spont_ef <-
  eff_size(l_spont_emm, sigma=sigma(l_all_spont),
           edf=df.residual(l_all_spont))
write_csv(left_join(as_tibble(l_spont_emm$contrasts),
                    mutate(as_tibble(l_spont_ef),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast, Freq, Layer),
                    suffix=c(".contr", ".eff_size")),
          "AwakeFmr1_SpontFFT_emmeans.csv")
