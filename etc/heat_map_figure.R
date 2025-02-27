
# Load libraries --------------------------------------------------

library(ggplot2)


# Read in best models ---------------------------------------------



R_summary <- read.csv("analysis/R_summary.csv")
C_summary <- read.csv("analysis/C_summary.csv")


# Select relevant columns for plotting ----------------------------

Rtmp <- R_summary |> dplyr::select(
  model_class_id,
  feature_n_complexity,
  valuesMax,
  dimension,
  stimulus_n,
  citekey
)

Ctmp <- C_summary |> dplyr::select(
  model_class_id,
  feature_n_complexity,
  valuesMax,
  dimension,
  stimulus_n,
  citekey
)


tmp <- rbind(Rtmp, Ctmp)

tmp <- tmp |> dplyr::group_by(
  dimension,
  model_class_id,
  feature_n_complexity
)|>
  dplyr::mutate(
    study_n = length(citekey),
    stim_mid = median(stimulus_n),
    label = paste0("n=",study_n,"\n(", stim_mid, ")")
  )

# Combine C and R studies, then facet based on type.
# Simplify labels for x and y axes
# Median number of stimulus n
tmp$dimension <- factor(tmp$dimension,
                        levels = c("valence", 
                                   "arousal", 
                                   "classification"))

tmp |>
  ggplot(aes(x = model_class_id, 
             y = feature_n_complexity,
             fill = valuesMax
         )) +
  geom_raster()+
  facet_wrap(facets = vars(dimension))+
  scale_fill_distiller(name = "Accuracy", palette = "Spectral")+
#  scale_fill_gradient2(name = "Accuracy")+
  scale_x_discrete(labels = c("LM", "NN", "SVM", "TM"))+
  scale_y_discrete(labels = c("<30", "30-300", ">300"))+
  geom_text(aes(label = label))+
  labs(x = "Model Class Type", y = "Feature N Category")+
  theme_classic()


ggsave("heat_map_figure.png", width = 14, height = 4, units = "in")
