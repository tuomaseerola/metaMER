# ============================================================================ #
#' Match names and lengths of one-dimensional data, padding with NAs.
#' 
#' @usage match_named_values(c('a' = 1, 'b' = 2, 'c' = 3), c('a' = 2, 'c' = 4))
#' @param ... Inputs of named arrays, data frames, or lists of named arrays. All classes must be the same.
#' 
#' @return Matrix array of input with matched names
#' 
#' @examples
#' 
#' a = c(
#'  name1 = 0.48, name2 = 0.32, name3 = 0.22)
#' b = 1:3
#' c = 5:7
#' x <- c('a' = 1, 'b' = 2, 'c' = 2)
#' y <- c('a' = 5, 'c' = 4)
#' z <- c('b' = 1)
#' list_arrays(list(x),list(y),list(z))
#' list_arrays(a,z) 
#'
#'
# input same for each
#' match_input_dims(x,y,z)
#' match_input_dims(data.frame(x),data.frame(y),data.frame(z))
#' match_input_dims(list(x), list(y), list(z))
#' match_input_dims(list(x,y,z))
#' match_input_dims(list(x,y), list(z))
#' match_input_dims(list(x), list(y,z))
#' # sensitive to input order (row-wise but not col-wise):
#' match_input_dims(list(z,y,x))
#'
#'
#'
#' match_named_values(c,a)
#' match_named_values(a,c)
#' match_named_values(a,z)
#' match_named_values(x,y,z)
#'                   
#'     
#' 
list_arrays <- function(...) {
  input <- list(...)
  if(length(unique(sapply(input, mode))) > 1) {
    stop('All inputs must be of same data type.')
  } else if(all(sapply(input, is.data.frame))) { # check if all inputs are dfs
    # check if combining dataframes with more than one dimension
    if(any(sapply(input, function(x) dim(x)[2]) > 1)) { 
      stop('All input dataframes must be one dimensional.')
    }
    # convert dataframes to named arrays
    input <- lapply(input, function(x) {
      x_names <- rownames(x)
      x <- unlist(x)
      names(x) <- x_names
      return(x)
    }
    )
  }
  # check if inputs are all lists
  else if(all(sapply(input, is.list))) {
    # if so, unlist each list separately (convert to arrays)
    input <- unlist(input, recursive = F)
  }
  return(input)
}


fill_missing_names <- function(...) {
    
    input <- list_arrays(...)
    #input <- list(...)
    
    # for inputs where only the first entry has names, and those names are recycled
    # for equally-lengthed and equally-ordered subsequent arrays.
    # check how many list entries have 0 names
    greater_than_0_names <- sapply(input, function (y) length(names(y)) > 0) 
    # check if there's only one entry:
    if(length(greater_than_0_names[greater_than_0_names == TRUE]) == 1) {
      # print('Found one entry with more than 0 names')
      # stop if length of arrays differ:
      if(length(unique(sapply(input, length))) != 1) { 
        stop('Cannot recycle names for arrays of different lengths')
        }
      # if so, use its names
      names_to_assign <- unlist(sapply(input[greater_than_0_names], names))
      input[!greater_than_0_names] <- lapply(input[!greater_than_0_names],
                                            function(z) {
                                           names(z) = names_to_assign
                                           return(z)
                                          } 
      ) 
      return(do.call(rbind, input))
    } else {
    message('Mismatch in input lengths.')
    invisible(0)
  }
}

match_input_dims <- function(...) {
  # combine inputs in list
  input <- list_arrays(...)
  if(TRUE %in% sapply(input, function(y) is.null(names(y)))) {
    stop('At least one input has 0 names.')
  }
  # collect all unique names. CHANGED TO LAPPLY
  unique_names <- unique(unlist(lapply(input, names)))
  unique_names <- na.omit(unique_names)
  # make all arrays have the same number of values (fill out with NAs)
  make_comparable_dims <- function(this_array, all_names) {
    # get names from list
    new_names <- all_names[!all_names %in% names(this_array)]
    # append NA until all arrays have same length
    new_values <- rep(NA, times = sum(!all_names %in% names(this_array), 
                                      na.rm = T))
    # match names so all arrays have same names
    names(new_values) <- new_names
    new_array <- append(this_array, new_values)
    # make sure array names are ordered the same
    new_array <- new_array[sort(unique(all_names))]
    return(new_array)
  }
  # now apply function, binding all arrays together
  do.call(rbind, 
          lapply(input, function(x) make_comparable_dims(x, unique_names)))
}

bind_field <- function(...) {
  if(is.null(
    unlist(lapply(list(...), names)))
    ) stop('No names found in inputs')
  # now perform check to see if names need be recycled from first list entry
  # if not, the function returns '0'
  recycled_names <- fill_missing_names(...)
  # check if function returned '0'. 
  # if so, apply match_input_dims function to ensure names match
  # and empty entries filled with NAs
  if(all(as.numeric(recycled_names) == 0)) {
    return(match_input_dims(...))
  } 
  else return(recycled_names)
}


## function to make n x n matrix from partially named array
# d: optional argument specifying n x n dimensionality
unflatten <- function(..., d) {
  # put inputs into array
  x <- c(...)
  # check if blanks within names
  if('' %in% names(x)) {
    # if so, find them, and repeat existing non-blank names (assumed recycling)
    x_names <- names(x)[!names(x) %in% '']
    names(x) <- rep(x_names, length.out = length(x))
  }
  # if user doesn't specify dimensionality, infer it from n unique names
  if(missing(d)) {
    d <- length(unique(names(x)))
  }
  # convert to n x n matrix
  mat <- matrix(x, nrow = d, ncol = d)
  # make sure names of rows and columns identical
  rownames(mat) <- colnames(mat) <- unique(names(x))
  return(mat)
}



# confusion_matrix <- function(..., class_names) {
#   confusion_matrix <- bind_field(...) 
#   class_names <- colnames(confusion_matrix)
#   attributes(confusion_matrix)$meta_details <- rownames(confusion_matrix)
#   rownames(confusion_matrix) <- class_names
#   return(confusion_matrix)
# }

