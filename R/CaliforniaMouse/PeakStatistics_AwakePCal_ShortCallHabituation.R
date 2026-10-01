## ShortCall Habituation measure
# response to each call divided by peak onset response per subject within each layer

library(tidyverse)
library(Matrix)
library(lme4)
library(lmerTest)
library(emmeans)


peakMC <- read_csv("E:/CSD_Riverside/output/CaliAwake/TracePeaks/VMAvPMA_ShortCallAdaptation.csv")%>%
  mutate(Call = ordered(OrderofCall))

# Multilevel Anova
peakMC_lmer <-
  lmer(RatioPeak ~ Group * Layer * Call + (1 | Subject),
       data=peakMC,
       REML=TRUE)
write.csv(anova(peakMC_lmer),"E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_ShortCall_ANOVA_habituation.csv")


# posthoc contrasts
peakMC_emm <-
  emmeans(peakMC_lmer, pairwise ~ Group | Layer:Call, p.adjust="hochberg")
peakNB_eff <-
  eff_size(peakMC_emm, sigma=sigma(peakMC_lmer),
           edf=df.residual(peakMC_lmer))
write_csv(left_join(as_tibble(peakMC_emm$contrasts),
                    mutate(as_tibble(peakNB_eff),
                           contrast = str_remove_all(contrast, '[()]')),
                    by = join_by(contrast,Layer,Call),
                    suffix=c(".contr", ".eff_size")),
          "E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_ShortCall_emmeans_habituation.csv")

# bar plots
peakMC_emm_4fig <-
  emmeans(peakMC_lmer, specs=c("Layer", "Call", "Group"))

peakMC_emm_4fig %>%
  as_tibble() %>%
  ggplot(aes(x=Call, y=emmean, group=Group, color=Group, fill=Group)) +
  geom_bar(stat="identity", position="dodge") +
  ylim(0, NA) +
  geom_errorbar(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                width=0.9, position="dodge") +
  facet_wrap("Layer") +
  ggtitle("Ratio Peaks to First Call Response")

ggsave("E:/CSD_Riverside/output/CaliAwake/TracePeaks/CaliAwake_ShortCall_habituation.png")

