# Shiny app server code.

library(eusocialr)
library(magrittr)

server = function(input, output) {
  output$coroplot = renderLeaflet({
    # FIXME: Not very efficient, should use reactive expressions.
    load_eurostat_data(time.format = "raw")
    map = plot_nuts2013_coropleth(age.a = input$radioage,
                                  sex.a = input$radiosex,
                                  time.s = input$year)
    map
  })

  output$tsplot = renderPlot({
    # FIXME: Not very efficient, should use reactive expressions.
    load_eurostat_data()
    selected.geos = c("ES", "DE", "IE")
    compare.data = get_eurostat_data() %>%
      filter_eurostat_data(geo.s = selected.geos)
      plot_eu_ts(compare.data,
      title.s = "Comparison of unemployment in Europe\nfor people aged 25 and above")
  })
}

