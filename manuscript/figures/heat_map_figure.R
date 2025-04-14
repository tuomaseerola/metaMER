library(ggplot2)
library(dplyr)
library(ggpubr)

# Read in best models ---------------------------------------------

R_heatmap <- read.csv("../analysis/R_summary.csv")
C_heatmap <- read.csv("../analysis/C_summary.csv")

# Success Heatmap -------------------------------------------------


Rtmp <- R_heatmap |> select(
  model_class_id,
  feature_n_complexity,
  valuesMax,
  dimension,
  stimulus_n,
  citekey
)

Ctmp <- C_heatmap |> select(
  model_class_id,
  feature_n_complexity,
  valuesMax,
  dimension,
  stimulus_n,
  citekey
)


tmp <- rbind(Rtmp, Ctmp)

tmp$model_class_id

tmp[tmp$model_class_id %in% 
      c("Support Vector Machines",
        "Tree-based Methods" ),]$model_class_id <-"SVM,TM"

tmp <- tmp |> group_by(
  dimension,
  model_class_id,
  feature_n_complexity
)|>
  mutate(
    study_n = length(citekey),
    stim_mid = median(stimulus_n),
    label = paste0("n = ",study_n,"\n(", round(stim_mid), ")")
  )

# Combine C and R studies, then facet based on type.
# Simplify labels for x and y axes
# Median number of stimulus n
tmp$dimension <- factor(tmp$dimension,
                        levels = c("valence", 
                                   "arousal", 
                                   "classification"),
                        labels = c("Valence", 
                                   "Arousal", 
                                   "Classification"))

heatmap_facets <- tmp |>
  ggplot(aes(x = model_class_id, 
             y = feature_n_complexity,
             fill = valuesMax
         )) +
  geom_raster()+
  facet_wrap(facets = vars(dimension))+
  scale_fill_distiller(name = "Accuracy", palette = "Spectral",breaks=seq(0,1,by=.20),limits=c(0,1))+
#  scale_fill_gradient2(name = "Accuracy")+
  scale_x_discrete(labels = c("LM", "NN", "Other"))+
  scale_y_discrete(labels = c("<30", "30-300", "300+"))+
  geom_text(aes(label = label),family='Linux Biolinum O')+
  labs(x = "Model class type", y = "Feature N category")+
  theme_classic(base_size = 14, base_family = "Linux Biolinum O")+
  theme(legend.key.width= unit(2, 'cm'))


# Model Types -----------------------------------------------------

# read model summary

best_mods <- read.csv("../etc/pretty-model-ids.csv")

best_mods$model_class_id <- factor(
  best_mods$model_class_id,
  labels = c("LM", "NN", "SVM", "TM")
)

best_mods$model_id[best_mods$model_id=="Backpropagation Neural Network"]<-"Backprop Neural Network"

best_mods <- best_mods[
  order(
    best_mods$model_class_id, 
    best_mods$model_id),
] 

best_mods$tally <- 1
best_mods$ind <- 1:nrow(best_mods)
best_mods$model_id <- forcats::fct_reorder(
  best_mods$model_id,
  best_mods$ind
)
best_mods$dimension <- factor(
  best_mods$dimension,
  levels = c("valence", "arousal", "classification"),
  labels = c("Valence", "Arousal", "Classification")
)

best_mods <- best_mods |> 
  group_by(
    dimension, 
    model_class_id,
    model_id
    ) |> 
  reframe(
    tally = sum(tally),
    label = paste("n =", max(tally)),
    best_model = mean(best_model)
  )

model_summary <- ggplot(best_mods, 
       aes(x=dimension, 
           y=model_id, 
           fill=best_model,
       )) + 
  geom_tile(color = "black")+
  geom_text(aes(label = label,family='Linux Biolinum O'))+
  facet_grid(cols = vars(dimension), 
             rows = vars(model_class_id),
             scales="free",
             space = "free"
  )+
  scale_fill_distiller(palette = "Spectral",breaks=seq(0,1,by=.20),limits=c(0,1))+
  labs(y = "Algorithm", fill = "Accuracy")+
  theme_classic(base_size = 14, base_family = "Linux Biolinum O")+
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank(),
    legend.key.width = unit(2, 'cm')
  )

fig5 <- ggarrange(
  heatmap_facets,
  model_summary,
  widths = c(1, 1.08),
  common.legend = TRUE,
  font.label = list(size = 14, color = "black", face = "bold", family = 'Linux Biolinum O'),
  labels = c("(a)", "(b)")
)

fig5
ggsave("../manuscript/model-summary-fig.png",
       plot = fig5,
       width = 12, height = 7.5, units = "in",dpi=300)

