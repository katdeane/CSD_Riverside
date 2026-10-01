# adapted from Michael A Erickson
# to account for heteroscadasicity, log(power) in lmer and then plot exp(emmeans)

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)

# Load Data

spont_fft <- read_csv("E:/CSD_Riverside/output/CaliAwake/FFT/VMAvPMA_AB_MaskCall_FFTData.csv")

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

## Multi-level ANOVA with log power values on SPONTANEOUS data
# all layers 
l_all_spont <-
  lmer(log(Power) ~ Layer * Freq * Group + (1 | Subject), spont_fft_l,
       subset=(Condition == "Spontaneous"),
       REML=TRUE)
write.csv(anova(l_all_spont),"E:/CSD_Riverside/output/CaliAwake/FFT/pCal_SpontFFT_ANOVA.csv")

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
          "E:/CSD_Riverside/output/CaliAwake/FFT/pCal_SpontFFT_emmeans.csv")

# bar plots 
emm_4plot <- emmeans(l_all_spont, specs=c("Layer", "Freq", "Group"))
emm_4plot %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)), width=0.9, position="dodge") +
  facet_wrap("Layer")

ggsave("E:/CSD_Riverside/output/CaliAwake/FFT/pCal_SpontFFT.pdf")




## Multi-level ANOVA with log power values on MASKCALL data normalized by spontaneous
# all layers 
l_all_spont <-
  lmer(log(Power) ~ Layer * Freq * Group + (1 | Subject), spont_fft_l,
       subset=(Condition == "MaskCall"),
       REML=TRUE)
write.csv(anova(l_all_spont),"E:/CSD_Riverside/output/CaliAwake/FFT/pCal_MaskFFT_ANOVA.csv")

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
          "E:/CSD_Riverside/output/CaliAwake/FFT/pCal_MaskFFT_emmeans.csv")

# bar plots 
emm_4plot <- emmeans(l_all_spont, specs=c("Layer", "Freq", "Group"))
emm_4plot %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)), width=0.9, position="dodge") +
  facet_wrap("Layer")

ggsave("E:/CSD_Riverside/output/CaliAwake/FFT/pCal_MaskFFT.pdf")





spont_fft <- read_csv("E:/CSD_Riverside/output/CaliAwake/FFT/VMAvPMA_AB_ClickTrain_FFTData.csv")
spont_fft_l <- spont_fft %>%
  pivot_longer(delta:highgam, names_to="Freq", values_to="Power") %>%
  mutate(Freq = factor(Freq,
                       levels=c("delta", "theta", "alpha",
                                "beta", "lowgam", "highgam")))

## Multi-level ANOVA with log power values on CLICKTRAIN data normalized by spontaneous
# all layers 
l_all_spont <-
  lmer(log(Power) ~ Layer * Freq * Group + (1 | Subject), spont_fft_l,
       subset=(Condition == "ClickTrain"),
       REML=TRUE)
write.csv(anova(l_all_spont),"E:/CSD_Riverside/output/CaliAwake/FFT/pCal_ClickFFT_ANOVA.csv")

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
          "E:/CSD_Riverside/output/CaliAwake/FFT/pCal_ClickFFT_emmeans.csv")

# bar plots 
emm_4plot <- emmeans(l_all_spont, specs=c("Layer", "Freq", "Group"))
emm_4plot %>%
  as_tibble() %>%
  ggplot(aes(x=Freq, y=exp(emmean), group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=exp(asymp.UCL)), width=0.9, position="dodge") +
  facet_wrap("Layer")

ggsave("E:/CSD_Riverside/output/CaliAwake/FFT/pCal_ClickFFT.pdf")

