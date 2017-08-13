library(eusocialr)

context("Tests loading, getting, and filtering of Eurostat data")

test_that("Loading default table", {
  load_eurostat_data()
  expect_false(is.null(get_eurostat_data()))
})

test_that("Loading a different table", {
  code = "ei_lmhu_m"
  load_eurostat_data(code)
  expect_false(is.null(get_eurostat_data(code)))
})

test_that("Loading and filtering NUTS2013", {
  load_eurostat_data()
  ea18.unemployment = get_eurostat_data() %>% filter_eurostat_data(geo.s = "EA18")
  expect_false(is.null(ea18.unemployment))
})
