#' Get dataframe contents from loaded Eurostat data
#'
#' This is simply a helper function.
#'
#' @param code The name of an Eurostat table which was previously loaded with \code{load_eurostat_data()}.
#' Default: \code{"lfst_r_lfu3rt"}
#'
#' @return Eurostat data
#' @export
#'
#' @seealso \code{\link{load_eurostat_data}}
#'
#' @examples
#'
#' load_eurostat_data()
#' df = get_eurostat_data()
get_eurostat_data = function(code = "lfst_r_lfu3rt") {
  # Construct a variale name for the relevant data.
  var.name = paste0("uedata.", code)

  # Return the selected data.
  get(var.name, envir = .GlobalEnv)
}


merge_geo_description = function(data.raw, mapping) {
  geo = NULL
  # Create common set of factors.
  combined = sort(union(levels(data.raw$geo), levels(mapping$geo)))

  # Left-join and re-level.
  t = left_join(mutate(data.raw,
                       geo = factor(geo,
                                    levels = combined)),
                mutate(mapping,
                       geo = factor(geo,
                                    levels = combined)))

  # Replace NA values (i.e. no mapping found).
  t$desc[is.na(t$desc)] = "EU region"

  # Make sure "desc" is a factor variable.
  t$desc = as.factor(t$desc)



  t
}

#' Clear loaded Eurostat dataframes
#'
#' This function removes previously created data frames stored the \code{.GlobalEnv}.
#'
#' @export
#'
#' @seealso \code{\link{load_eurostat_data}}
#'
#' @examples
#'
#' clear_eurostat_data()
clear_eurostat_data = function() {
  # List all variables in environment.
  vars = ls(pos = .GlobalEnv)

  # Select the ones that start with our prefix.
  rm.vars = vars[grepl("uedata.", vars)]

  # Remove.
  rm(list = rm.vars, envir = .GlobalEnv)
}
