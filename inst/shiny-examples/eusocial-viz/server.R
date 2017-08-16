# eusocical-viz - shiny app server code.
# FIXME: This is only for demo purposes and by no means production-grade code.

# FIXME: Install package from GitHub.
library(eusocialr)
library(magrittr)

server = function(input, output) {
  output$coroplot = renderLeaflet({
    # FIXME: Not very efficient, should use reactive expressions.
    load_eurostat_data(time.format = "raw")
    map = plot_nuts2013_coropleth(
      age.a = input$radioage,
      sex.a = input$radiosex,
      time.s = input$year
    )
    map
  })

  output$tsplot = renderPlot({
    # FIXME: Not very efficient, should use reactive expressions.
    load_eurostat_data()
    selected.geos = input$countries.sel

    if(!is.null(selected.geos)) {
      compare.data = get_eurostat_data() %>%
        filter_eurostat_data(
          age.a = input$radioage,
          sex.a = input$radiosex,
          geo.s = selected.geos
        )
      plot_eu_ts(compare.data,
                 title.s = "Comparison based on selected groups")
    }
  })

  output$arimamodel = renderText({
    load_eurostat_data(code = "ei_lmhu_m")
    ts = get_eurostat_data(code = "ei_lmhu_m") %>%
      filter_ts_data(geo.s = "UK")
      res.arima = forecast_eu_unemp(ts$values)
      cat("\nTime series model:\n", res.arima$model, "\nOne-step ahead-forecast:\n", res.arima$forecast)
  })

  output$arfimamodel = renderText("ARFIMA")

}
