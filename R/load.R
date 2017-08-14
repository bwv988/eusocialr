#' Loads data tables from the Eurostat database
#'
#' This is a generic wrapper function which loads specified tables from the Eurostat database,
#' By default, the \code{lfst_r_lfu3rt} table is loaded which contains data on
#' European unemployment rates in the NUTS 2013 regions.
#'
#' @param code The name of the relevant Eurostat table to load.
#' @param time.format Which time format to load. Can be either \code{date}, or \code{raw}.
#' @param cache.dir The directory in which to cache downloaded data. This is useful when working offline.
#'
#' @return Data will be loaded into the global R environment (\code{.GlobalEnv}). Each loaded table is prefixed with: "\code{uedata.}".
#'
#' @export
#'
#' @import magrittr dplyr eurostat
#'
#' @seealso \code{\link{get_eurostat_data}}, \code{\link{clear_eurostat_data}}, \code{\link{get_eurostat}}
#'
#' @examples
#'
#' load_eurostat_data()
#' load_eurostat_data(cache.dir = "/tmp")
#' load_eurostat_data(code = "ei_lmhu_m")
#'
load_eurostat_data = function(code = "lfst_r_lfu3rt",
                                  time.format = c("date", "raw"),
                                  cache.dir = NULL) {
  # Match arguments.
  tf = match.arg(time.format)

  # Construct a variale name for the relevant data.
  var.name = paste0("uedata.", code)

  # For simplicity, we will store this variable globally.
  # FIXME: This is against best-practices for R packages.
  assign(
    var.name,
    get_eurostat(
      id = code,
      time_format = tf,
      cache_dir = cache.dir
    ),
    envir = .GlobalEnv
  )
}


#' Quick helper function to load a mapping of NUTS 2013 codes to a human readable description
#'
#' The original data was downloaded from: \href{http://ec.europa.eu/eurostat/ramon/nomenclatures/index.cfm?TargetUrl=LST_CLS_DLD&StrNom=NUTS_2013L&StrLanguageCode=EN&StrLayoutCode=HIERARCHIC}{Eurostat}
#'
#' @return A mapping data frame.
#' @export
#' @import readr magrittr dplyr
#'
#' @examples
#'
#' mapping = load_nuts_mapping()
#'
load_nuts_mapping = function() {
  # FIXME: Error handling.
  data.file = system.file("ext-data", "NUTS_2013_raw.csv", package = "eusocialr")
  read_csv(data.file) %>%
    select("NUTS-Code", "Description") %>%
    rename("geo" = "NUTS-Code", "desc" = "Description")
}
