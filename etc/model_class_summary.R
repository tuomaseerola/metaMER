library(dplyr)

best_mods <- read.csv("etc/pretty-model-ids.csv")

best_mods <- best_mods |> select(
  citekey, 
  paradigm, 
  model_class_id,
  model_id
)


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

model_id_summary$paradigm <- factor(
  model_id_summary$paradigm,
  levels = c("regression", "classification"),
  labels = c("Regression", "Classification")
)



model_id_summary <- model_id_summary[order(model_id_summary$model_class_id),]

model_id_summary$model_id <- factor(
  model_id_summary$model_id,
 levels = unique(model_id_summary$model_id
                 )
 )

heatmap_fig <- function(df, dim) {
  df |> 
    ggplot(aes(y = model_id, 
               x = model_class_id,
               fill = n
    )) +
    geom_tile(colour="black")+
    scale_fill_distiller(name = "Count", palette = "Spectral")+
    scale_x_discrete(labels = c("LM", "NN", "SVM", "TM"))+
    #scale_y_discrete(labels = c("<30", "30-300", ">300"))+
    #geom_text(aes(label = model_id), position = position_jitter())+
    labs(x = "Model class type", y = "Algorithm")+
    theme_bw()+
    facet_wrap(vars(paradigm))
   # scale_y_discrete(values)
  
}
heatmap_fig(model_id_summary)
