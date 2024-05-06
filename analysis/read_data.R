# read_data.R

#### Compile annotated studies ----------
L <- list.files(path='../data/',pattern = ".R")

df <- data.frame(nro=1:length(L))
for (k in 1:length(L)) {
  source(file.path('data/',L[k]))
  df$study_id[k] <- study_id
  df$emotion_type[k] <- emotion_type
  df$emotion_list[k] <- list(emotion_list)
  df$emotion_locus[k] <- emotion_locus
  df$stimulus_type[k] <- stimulus_type
  df$stimulus_duration[k] <- stimulus_duration
  df$stimulus_N[k] <- stimulus_N
  df$participant_N[k] <- participant_N
  df$participant_expertise[k] <- participant_expertise
  df$participant_origin[k] <- participant_origin
  df$participant_sampling[k] <- participant_sampling
  df$feature_list[k] <- list(feature_list)
  df$feature_validation[k] <- feature_validation
  df$feature_source[k] <- feature_source
  df$model_type[k] <- list(model_type)
  df$model_measure[k] <- model_measure
  df$model_complexity_parameters[k] <- list(model_complexity_parameters)
  df$model_rate_emotion_list[k] <- list(model_rate_emotion_list)
  df$model_validation <- model_validation
  df$meta_comments[k] <- meta_comments
  df$meta_encoder[k] <- meta_encoder
  df$meta_date[k] <- meta_date
}

# check validity of the data

# numeric variables
stopifnot(is.numeric(df$stimulus_duration))
stopifnot(is.numeric(df$stimulus_N))
stopifnot(is.numeric(df$participant_N))

# specific variables
stopifnot(df$emotion_type %in% c('dimensional','discrete','music-specific','other'))

