library(ggplot2)
library(dplyr)

# Read in best models ---------------------------------------------

R_heatmap <- read.csv("analysis/R_summary.csv")
C_heatmap <- read.csv("analysis/C_summary.csv")

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
    label = paste0("n=",study_n,"\n(", stim_mid, ")")
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
  scale_fill_distiller(name = "Accuracy", palette = "Spectral")+
#  scale_fill_gradient2(name = "Accuracy")+
  scale_x_discrete(labels = c("LM", "NN", "Other"))+
  scale_y_discrete(labels = c("<30", "30-300", ">300"))+
  geom_text(aes(label = label))+
  labs(x = "Model class type", y = "Feature N category")+
  theme_classic(base_size = 14,base_family = "Helvetica")


# Model Types -----------------------------------------------------

# read model summary

best_mods <- read.csv("etc/pretty-model-ids.csv")

# select relevant columns

best_mods <- best_mods |> select(
  citekey, 
  paradigm, 
  model_class_id,
  model_id
)

# count the number of models, making sure they aren't doubly
# represented for VA studies

model_id_summary <- best_mods |>
  group_by(
    paradigm,
    citekey
  ) |>
  reframe(
    model_id = unique(
      model_id
    ),
    model_class_id = unique(
      model_class_id
    )
  ) 

model_id_summary <- model_id_summary |>
  ungroup() |>
  group_by(paradigm) |>
  add_count(model_id)

# change factor order for regression and classification

model_id_summary$paradigm <- factor(
  model_id_summary$paradigm,
  levels = c("regression", "classification"),
  labels = c("Regression", "Classification")
)

# re-order models so they follow model classes

model_id_summary <- model_id_summary[
  order(model_id_summary$model_class_id),]

model_id_summary$model_id <- factor(
  model_id_summary$model_id,
  levels = unique(model_id_summary$model_id
  )
)

# now generate a heatmap counting model frequency across categories

figure_models <- model_id_summary |> 
  ggplot(aes(y = model_id, 
             x = model_class_id,
             fill = n
  )) +
  geom_rect(xmin=0,xmax=5,ymin=0,ymax=7.5, 
            fill = "#ffffff")+
  geom_rect(xmin=0,xmax=5,ymin=7.5,ymax=11.5, 
            fill = "#dddddd")+
  geom_rect(xmin=0,xmax=5,ymin=11.5,ymax=17.7, 
            fill = "#bebebe")+
  #  geom_rect(xmin=0, xmax =5, ymin=13.5, ymax=17.7,
  #            fill = "#a2a2a2")+
  geom_tile(colour="black")+
  scale_fill_distiller(name = "Count", 
                       direction = -1,
                       palette = "Spectral",
                       type = "seq")+
  scale_x_discrete(labels = c("LM", "NN", "SVM", "TM"))+
  labs(x = "Model class type", y = "Algorithm")+
  theme_bw()+
  facet_wrap(vars(paradigm))


model_summary_fig <- gridExtra::grid.arrange(
  heatmap_facets+theme(legend.position = "top")+labs(title = "(a)"), 
  figure_models+theme(legend.position = "top")+labs(title = "(b)"), 
  ncol = 2,
  widths= c(4,3)
)

# ggsave("etc/model-summary-fig.png", 
#        plot = model_summary_fig,
#        width = 12, height = 7.5, units = "in")

