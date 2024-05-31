stripLFFromList <- function(fn = NULL){
  # T.E. 30/5/2024 for metaMER
  fn_out <- stringr::str_replace(fn,'.bib','_strip.bib')
  x <- readr::read_lines(fn)

  # get the part we wish to modify, this will need to address multiple cases in the next version!
  section_start <- which(stringr::str_detect(x,"list"))-1
  section_end <- which(stringr::str_detect(x,"\\},"))  
  section_end_index <- section_end > section_start
  section_end<-section_end[section_end_index]
  
  # write back the file but with this section without separator
  x2<-x[section_start:section_end]
  readr::write_lines(x[1:(section_start-1)],file = fn_out)
  readr::write_lines(x2,file = fn_out,sep = "",append = TRUE)
  readr::write_lines("\n",file = fn_out,append = TRUE)
  readr::write_lines(x[(section_end+1):length(x)],file = fn_out,append = TRUE)
 
}