

dimension_score_CV_testSet

rbind(internal_validation_model = c('valence' = 0.34, 'arousal' = 0.79) ,
      external_validation_model = c('valence' = 0.61, 'arousal' = 0.69)) -> temp


# 1. rownames -> column [models tested]

# parser: get (for example) arousal values for all studies, subpopulate models & n, etc.

# from bibtex: create function that lets you retrieve target properties
## return: study|model|outcomeMeasure|stimulusNumber... (compact version)

temp[,stringr::str_detect(colnames(temp), 'valence|valence_R2')]
temp[,stringr::str_detect(colnames(temp), 'arousal|arousal_R2')]

temp[,'valence']
