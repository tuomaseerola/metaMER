## This script works after running preprocessing.qmd


# some models have multiple summary measures. This script makes identifying them easier ----------------------

# Find studies where models are summarized by multiple measures
R_studies |> group_by(unique_id, dimension) |> dplyr::summarize(
  measure_n = length(unique(measure)),
  summary_stat_n = length(unique(statistic))
  ) -> r_summary_measures

C_studies |> group_by(unique_id, dimension) |> dplyr::summarize(
  measure_n = length(unique(measure)),
  summary_stat_n = length(unique(statistic))
) -> c_summary_measures

nrow(r_summary_measures[r_summary_measures$summary_stat_n == 1,])
nrow(c_summary_measures[c_summary_measures$summary_stat_n == 1,])

r_summary_measures[r_summary_measures$measure_n > 1,]
r_summary_measures[r_summary_measures$summary_stat_n > 1,]


R_studies[stringr::str_detect(R_studies$unique_id, 
                     c('gingras2014be|wang2022co|coutinho2017')),] |> 
  dplyr::select(unique_id, dimension, measure, statistic, values) -> R_multiple







c_summary_measures[c_summary_measures$measure_n > 1,]
c_summary_measures[c_summary_measures$summary_stat_n > 1,]


C_studies[stringr::str_detect(C_studies$unique_id, c('zhang2016br|zhang2017fe')),] |> 
  dplyr::select(unique_id, dimension, measure, statistic, values) -> C_multiple
print(C_multiple, n = nrow(C_multiple))

print(C_multiple)
print(R_multiple)


# After omitting NAs ------------------------------------------------------


na.omit(C_multiple)
na.omit(R_multiple)


