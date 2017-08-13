#' Filter Eurostat data by age group, sex, and location
#'
#' This function is intended to be used with a certain set of Eurostat tables which record age, sex and location.
#'
#' For NUTS 2013 region tables, see: \code{\link{filter_nuts2013_data}}.
#'
#' @param data.raw The input data table from the Eurostat data base.
#' @param age.s Age group
#' @param sex.s Gender
#' @param geo.s A single location, or list of multiple locations.
#'
#' @return Filtered Eurostat data.
#'
#' @export
#'
#' @seealso \code{\link{filter_nuts2013_data}}
#'
#' @examples
#'
#' library(magrittr)
#' load_eurostat_data()
#' # Get subset of data for ages 15-24.
#' get_eurostat_data() %>% filter_eurostat_data(age.s = "Y15-24")

filter_eurostat_data = function(data.raw,
                       age.s = "Y_GE25",
                       sex.s = "T",
                       geo.s = NULL) {
  # FIXME: Parameter check.
  # FIXME: Have parameter list with allowed params.

  # In order to get rid of "NOTE"
  age = sex = geo = NULL

  r = NULL
  if (is.null(geo.s)) {
    r = data.raw %>% filter(age == age.s &
                              sex == sex.s)
  } else if (length(geo.s) == 1) {
    r = data.raw %>% filter(age == age.s &
                              sex == sex.s &
                              geo == geo.s)
  } else {
    r = data.raw %>% filter(age == age.s &
                              sex == sex.s &
                              geo %in% geo.s)
  }

  r
}


#' Filter yearly NUTS2013 data
#'
#' Utility function for filtering yearly NUTS 2013 data from the Eurostat data base.
#'
#' \strong{Note}: This function internally converts the time data into years. Thereofre, the data must be loaded
#' from the Eurostat database using the \code{time.format = "raw"} in \code{load_eurostat_data()}.
#'
#' @param data.raw The input data table from the Eurostat data base.
#' @param time.s The year for which the data shall be filtered.
#'
#' @return Filtered Eurostat data.
#' @export
#' @import dplyr
#' @examples
#'
#' library(magrittr)
#' load_eurostat_data(time.format = "raw")
#' df = get_eurostat_data() %>% filter_nuts2013_data()
filter_nuts2013_data = function(data.raw,
                                time.s = "2010") {
  time = geo = NULL
  data.raw %>%
    mutate(time = eurotime2num(time)) %>%
    filter(time == time.s & nchar(as.character(geo)) == 4)
}
