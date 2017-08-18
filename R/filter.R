#' Filter Eurostat data by age group, sex, and location
#'
#' This function is intended to be used with a certain set of Eurostat tables which record
#' age, sex and location.
#'
#' For NUTS 2013 region tables, see: \code{\link{filter_nuts2013_data}}.
#'
#' @param data.raw The input data table from the Eurostat database.
#' @param age.a Age group
#' @param sex.a Gender
#' @param geo.s A single location, or list of multiple locations.
#'
#' @return A tibble of filtered Eurostat data.
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
#' get_eurostat_data() %>% filter_eurostat_data(age.a = "Y15-24")

filter_eurostat_data = function(data.raw,
                       age.a = c("Y_GE25", "Y15-24", "Y15-74", "Y20-64", "Y_GE15"),
                       sex.a = c("T", "M", "F"),
                       geo.s = NULL) {
  # Match parameters.
  age.s = match.arg(age.a)
  sex.s = match.arg(sex.a)

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
#' Utility function for filtering yearly NUTS 2013 data from the Eurostat database.
#'
#' \strong{Note}: This function internally converts the time data into years. Thereofre, the data must be loaded
#' from the Eurostat database using the \code{time.format = "raw"} in \code{load_eurostat_data()}.
#'
#' @param data.raw The input data table from the Eurostat database.
#' @param time.s The year for which the data shall be filtered.
#'
#' @return A tibble of filtered Eurostat data.
#'
#' @export
#'
#' @import dplyr
#'
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


#' Filter time series of harmonized unemployment rates from the Eurostat database
#'
#' Utility function for filtering time series values of harmonized unemployment data
#' from the Eurostat database by age, sex, seasonal adjustment, and location.
#'
#' @param data.raw The input data table from the Eurostat database.
#' @param age.a Age group
#' @param sex.a Gender
#' @param a.adj Select seasonally adjusted, or non-adjusted data.
#' @param geo.s A single geographical location.
#'
#' @return A tibble of filtered Eurostat time series data.
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#'
#' library(magrittr)
#' load_eurostat_data(code = "ei_lmhu_m")
#' get_eurostat_data(code = "ei_lmhu_m") %>% filter_ts_data()
filter_ts_data = function(data.raw,
                          age.a = c("TOT", "LE25", "GT25"),
                          sex.a = c("T", "M", "F"),
                          a.adj = c("NSA", "SA"),
                          geo.s = NULL) {
  # Match arguments.
  age.s = match.arg(age.a)
  sex.s = match.arg(sex.a)
  s.adj = match.arg(a.adj)

  # Build key.
  indic.s = paste0("LM-UN-", sex.s, "-", age.s)

  # Hack to prevent warning...
  indic = s_adj = geo = values = time = NULL

  # Perform filtering.
  if(is.null(geo.s)) {
    r = data.raw %>% filter(indic == indic.s & s_adj == s.adj)
  } else {
    r = data.raw %>% filter(indic == indic.s & s_adj == s.adj & geo == geo.s)
  }

  r %>% select(values, time)
}
