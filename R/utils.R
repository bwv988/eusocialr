#' Get dataframe contents from loaded Eurostat data
#'
#' This is simply a helper function.
#'
#' @param code The name of an Eurostat table which was previously loaded with \code{load_eurostat_data()}.
#'
#' @return Eurostat data
#' @export
#'
#' @seealso \link{\code{load_eurostat_data()}}
#' @examples
#' load_eurostat_data()
#' df = get_data()
get_data = function(code = "lfst_r_lfu3rt") {
  # Construct a variale name for the relevant data.
  var.name = paste0("uedata.", code)

  # Return the selected data.
  get(var.name, envir = .GlobalEnv)
}

merge_geo_description = function(data.raw, mapping) {
  # Create common set of factors.
  combined = sort(union(levels(data.raw$geo), levels(mapping$geo)))

  # Left-join and re-level.
  t = left_join(mutate(data.raw,
                       geo = factor(geo,
                                    levels = combined)),
                mutate(nuts.mapping,
                       geo = factor(geo,
                                    levels = combined)))

  # Make sure "desc" is a factor variable.
  t$desc = as.factor(t$desc)
  t
}

#' Clear loaded Eurostat dataframes
#'
#' This function removes data frames loaded by the package from the Eurostat database.
#' @export
#' @seealso \link{\code{load_eurostat_data()}}
#' @examples
#' clear_data()
clear_data = function() {
  # List all variables in environment.
  vars = ls(pos = .GlobalEnv)

  # Select the ones that start with our prefix.
  rm.vars = vars[grepl("uedata.", vars)]

  # Remove.
  rm(list = rm.vars, envir = .GlobalEnv)
}
