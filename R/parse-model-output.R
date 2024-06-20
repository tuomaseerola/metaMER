## TODO: document

# low-level function to extract relevant values from named array
parse_model_output <- function(x) {
  # evaluate the expression
  x <- rlang::eval_tidy(rlang::parse_expr(x))
  # get name of fitted models from column names
  model_names <- colnames(x)
  # print(model_names)
  # split across model name for summary statistic (e.g., mean, sd, etc.)
  model_statistic <- stringr::str_split(model_names, '\\.')
  model_statistic <- unlist(lapply(model_statistic, function(x) x[2]))
  # get values
  model_values <- as.numeric(t(x))
  # names(model_values) <- 'score'
  #print(model_values)
  # get additional attributes (feature.data.exp)
  model_attributes <- rep(rownames(x), each = ncol(x))
  # get additional model details
  model_attributes <- data.frame(do.call('rbind', stringr::str_split(model_attributes, '\\.')))
  names(model_attributes) <- c('library_id', 'model_id', 'feature_id', 'data_id', 'experiment_id')
  print(names(model_attributes))
  # split across '_' to 
  model_measures <- data.frame(do.call('rbind', stringr::str_split(colnames(x), '_')))
  names(model_measures) <- c('dimension', 'measure')
  model_measures_split <- stringr::str_split(model_measures[,'measure'], '\\.')
  model_measures[,'measure'] <- unlist(lapply(model_measures_split, 
                                              function(x) x[1]))
  return(data.frame(
    model_attributes, 
    model_measures, 
    statistic = model_statistic,
    values = model_values))
}


get_study_results <- function(study) {
  citekey <- unique(as.character(study[,'citekey']))
  #print(citekey)
  #print(as.character(study[,'model_rate_emotion_values']))
  results <- parse_model_output(as.character(study[,'model_rate_emotion_values']))
  return(
    dplyr::tibble(citekey,
            results)
    )
}


