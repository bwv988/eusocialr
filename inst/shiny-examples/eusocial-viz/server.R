# eusocical-viz - shiny app server code.
# FIXME: This is only for demo purposes and by no means production-grade code.

# FIXME: Install package from GitHub.
library(eusocialr)
library(magrittr)

# FIXME: Very ugly utility function.
modelres_render = function(caption, obj) {
  l = capture.output(print(obj))
  str = caption
  for (i in 1:length(l)) {
    str = paste(str, l[i], sep = "<br/>")
  }

  str
}


server = function(input, output) {
  output$coroplot = renderLeaflet({
    # FIXME: Not very efficient, should use reactive expressions.
    load_eurostat_data(time.format = "raw")
    map = plot_nuts2013_coropleth(
      age.a = input$radioage1,
      sex.a = input$radiosex1,
      time.s = input$year1
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
          age.a = input$radioage2,
          sex.a = input$radiosex2,
          geo.s = selected.geos
        )
      plot_eu_ts(compare.data,
                 title.s = "Comparison based on selected groups")
    }
  })

  output$arimamodel = renderUI({
    load_eurostat_data(code = "ei_lmhu_m")
    ts = get_eurostat_data(code = "ei_lmhu_m") %>%
      filter_ts_data(geo.s = "UK")
      res.arima = forecast_eu_unemp(ts$values)
      p1 = modelres_render("*** Model results ***", res.arima$model)
      p2 = modelres_render("*** One-step ahead prediction ***", res.arima$forecast)
      HTML(paste0("<p><pre>", p1, "<br/><br/>", p2, "</pre></p>"))
  })

  output$arfimamodel = renderUI({
    load_eurostat_data(code = "ei_lmhu_m")
    ts = get_eurostat_data(code = "ei_lmhu_m") %>%
      filter_ts_data(geo.s = "UK")
    res.arfima = forecast_eu_unemp(ts$values, model.type = "arfima")
    p1 = modelres_render("*** Model results ***", res.arfima$model)
    p2 = modelres_render("*** One-step ahead prediction ***", res.arfima$forecast)
    HTML(paste0("<p><pre>", p1, "<br/><br/>", p2, "</pre></p>"))
  })

}
