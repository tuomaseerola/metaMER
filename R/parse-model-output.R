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
  #print(names(model_attributes))
  # split across '_' to 
  model_measures <- data.frame(do.call('rbind', stringr::str_split(colnames(x), '_')))
  names(model_measures) <- c('dimension', 'measure')
  model_measures_split <- stringr::str_split(model_measures[,'measure'], '\\.')
  model_measures[,'measure'] <- unlist(lapply(model_measures_split, 
                                              function(x) x[1]))
  invisible(data.frame(
    model_attributes, 
    model_measures, 
    statistic = model_statistic,
    values = model_values))
}



summarize_matrix = function(matrix) {
  # convert named array to table
  class_table <- as.table(matrix)
  # make row and column names consistent
  rownames(class_table) <- colnames(class_table)
  # get confusion matrix output from caret
  confusion_results <- caret::confusionMatrix(class_table)
  # calculate mcc
  confusion_mcc <- yardstick::mcc(confusion_results$table)$.estimate
  names(confusion_mcc) <- 'mcc'
  # combine data summaries
  confusion_summary <- append(confusion_results$overall,
                              confusion_mcc)
  # make nomenclature consistent with regression studies
  names(confusion_summary) <- paste0('classification_', 
                                     names(confusion_summary))
  # for two consecutive capitalized words, delimit with '.' and lowercase
  # e.g. Classification_AccuracyPvalue becomes classification_accuracy.pvalue
  names(confusion_summary) <- tolower(
    gsub("([a-z])([A-Z])", "\\1.\\2", 
         names(confusion_summary)
    )
  )
  
  return(confusion_summary)
}


get_study_results <- function(study) {
  citekey <- unique(as.character(study[,'citekey']))
  journal <- unique(as.character(study[,'journal']))
  stimulus_n <- unique(as.character(study[,'stimulus_n']))
  feature_n <- unique(as.character(study[,'feature_n']))
  participant_n <- unique(as.character(study[,'participant_n']))
  model_category <- unique(as.character(study[,'model_category']))
  feature_source <- unique(as.character(study[,'feature_source']))
  feature_reduction_method <- unique(as.character(study[,'feature_reduction_method']))
  stimulus_genre <- unique(as.character(study[,'stimulus_genre']))

  #print(citekey)
  #print(as.character(study[,'model_rate_emotion_values']))
  results <- parse_model_output(as.character(
    study[,'model_rate_emotion_values'])
    )
  
  
    clean_df <- dplyr::tibble(
      citekey,
      journal,
      stimulus_genre,
      model_category = trimws(model_category, which = 'both'), 
      stimulus_n,
      feature_n,
      participant_n,
      feature_source,
      feature_reduction_method,
      results) 
    
    
    return(clean_df)
}




