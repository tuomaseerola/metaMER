
# Build database ----------------------------------------------------------

## TODO: figure out why 4 studies don't read, document

get_metaMER_df <- function(path_2_studies = here::here('studies')) {

bib_file <- read.delim(paste0(path_2_studies, '/bib/extractions.bib'),
                       sep = '@', header = F)
journal <- bib_file[str_detect(tolower(bib_file$V1), 'journal = '),]$V1
journal <- journal[1:length(journal)-1]
journal <- stringr::str_remove(journal, "JOURNAL ")
# get citekeys from bibtex file:
citekeys <- unique(bib_file$V2)
# improve formatting
citekeys <- stringr::str_remove(citekeys, '\\{')
citekeys <- stringr::str_remove(citekeys, ',')
citekeys <- stringr::str_remove(citekeys, '%%.*$')
citekeys <- stringr::str_remove(citekeys, 'Article')
citekeys[citekeys ==''] <- NA
citekeys <- na.omit(citekeys)

# find where new entries begin:
new_entries = which(bib_file$V2 != '')

# loop across unique indices for each entry
meta_list = list()
# loop across unique indices for each entry
meta_list = list()
for(this_entry in 1:(length(new_entries)-1))
{
  # get unique citekey
  this_cite_key <- citekeys[this_entry]
  # capture lines following citekey
  corresponding_lines <- bib_file[new_entries[this_entry]:new_entries[this_entry+1]-1,]$V1
  # store matching lines as data frame
  corresponding_lines <- data.frame(corresponding_lines)
  # assign lines distinct name
  names(corresponding_lines) <- this_cite_key
  # add to a list for further processing
  meta_list <- append(meta_list, corresponding_lines)
}

# read in target bibtex fields
search_fields <- field_names <- readLines(paste0(path_2_studies, '/bibtex_fields.txt'))

# match casing in bibtex file
field_names <- toupper(field_names)
# add a pattern allowing us to find text between two adjacent bibtex fields
rep_pattern <- paste0(field_names[1:length(field_names)-1], '\\s*(.*?)\\s')
# apply this same pattern to all but the last of the field names                  
field_names[1:length(field_names)-1] <- rep_pattern
# collapse all the new field names into a single string for string manipulation with stringr
field_names[length(field_names)] <- paste0(field_names[length(field_names)], '.*')
field_names <- paste0(field_names, collapse = '')

Sys.sleep(0.25)
# create new column containing information between two adjacent target fields for all entries in list
meta_df <- lapply(meta_list, function(x) stringr::str_match(
  paste0(x, collapse = ' '), field_names))
meta_df <- lapply(meta_list, function(x) stringr::str_match(
  paste0(x, collapse = ' '), field_names))

# collapse list entries into rows
meta_df <- do.call('rbind', meta_df)
# format as a data.frame
meta_df <- data.frame(meta_df)
# match text after final column name
meta_df[,ncol(meta_df)+1] <- sapply(meta_df[,1], function(x) stringr::str_match(
  paste0(x, collapse = ' '), '(?<=FINAL_NOTES).*'))
# replace first column with citationkeys
meta_df[,1] <- names(meta_list)
names(meta_df) <- c('citekey', search_fields)
meta_df$journal <- journal
names(meta_df) <- trimws(names(meta_df))

Sys.sleep(0.25)
## remove bibtext field formatting
# remove curly braces
meta_df <- apply(meta_df, 2, function(x) stringr::str_remove_all(x, '\\{')) 
meta_df <- apply(meta_df, 2, function(x) stringr::str_remove_all(x, '\\},'))
# remove first '=' (from bibtex field )
meta_df <- apply(meta_df, 2, function(x) stringr::str_remove(x, '='))
# remove double-commas
#meta_df <- apply(meta_df, 2, function(x) str_remove_all(x, ',,'))
# remove comments
meta_df <- apply(meta_df, 2, function(x) stringr::str_remove_all(x, '%%.*'))
#meta_df <- apply(meta_df, 2, function(x) str_remove_all(x, ' , '))
# remove extra characters in final column
meta_df[, ncol(meta_df)] = stringr::str_remove_all(meta_df[, ncol(meta_df)], '\\}')
meta_df <- as.data.frame(meta_df)


return(meta_df)

}


