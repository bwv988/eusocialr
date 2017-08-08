#' Renders a \emph{Coropleth} map of the NUTS2013 regions for the selected data subset
#'
#' @param age.s Selected age group.
#' @param sex.s Selected gender.
#' @param time.s Selected time.
#'
#' @return
#' @import leaflet
#' @export
#'
#' @examples
#' load_eurostat_data()
#'
#' plot_nuts2013_coropleth()
#'
#' plot_nuts2013_coropleth(time.s = 2016, sex.s = "T", age.s = "Y15-24")
plot_nuts2013_coropleth = function(age.s = "Y_GE25",
                          sex.s = "T",
                          time.s = "2010") {

  # FIXME: Error-handling is zilch.

  # Merge data with geo data.
  # Also, merge real area name.
  plot.data.geo = get_data() %>% filter_data(age.s = age.s,
                                             sex.s = sex.s) %>%
    filter_nuts2013_data(time.s = time.s) %>%
    merge_eurostat_geodata(
      data = .,
      geocolumn = "geo",
      resolution = "60",
      output_class = "spdf",
      all_regions = TRUE
    ) %>%
    geo_join(.,
             nuts.mapping,
             by_sp = "NUTS_ID",
             by_df = "geo",
             how = "inner")


  # Generate labels for the popups.
  labels = sprintf(
    "<strong>%s</strong><br/>%g %% unemployed",
    plot.data.geo$desc,
    plot.data.geo$values
  ) %>% lapply(HTML)

  # Legend title.
  legend.title = "Percent unemployed<br/>by NUTS2013 region"

  # Eurostat copyright notice.
  copyright.info = "&copy; EuroGeographics for the administrative boundaries"

  info.box = generate_infobox(age.s, sex.s, time.s)

  # Plot cloropleth map with Leaflet.
  plot.pal = colorBin(palette = "YlOrRd",
                      domain = plot.data.geo$values)

  # Perform the plot.
  plot.data.geo %>%
    leaflet() %>%
    addTiles() %>%
    setView(lng = 9.6, lat = 53.6, zoom = 3.2) %>%
    addPolygons(
      color = "#444444",
      weight = 1,
      smoothFactor = 0.5,
      opacity = 1.0,
      fillOpacity = 0.5,
      fillColor = ~ plot.pal(values),
      highlightOptions = highlightOptions(
        weight = 4,
        color = "#666",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE
      ),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto"
      )
    ) %>%
    addControl(html = info.box,
               position = "topright") %>%
    addControl(html = copyright.info,
               position = "bottomleft") %>%
    addLegend(
      "bottomright",
      pal = plot.pal,
      values = ~ values,
      title = legend.title,
      labFormat = labelFormat(suffix = "%"),
      opacity = 0.3
    )
}

#' Generate an info box for the Leaflet plot
#'
#' @param age.s Selected age group.
#' @param sex.s Selected gender.
#' @param time.s Selected time.
#'
#' @return String with HTML code for info box.
#'
generate_infobox = function(age.s = "Y_GE25",
                            sex.s = "T",
                            time.s = "2010") {

  # FIXME: Add parameter check.
  # FIXME: Use swtich statement?

  if (age.s == "Y15-24") {
    age.text = "15-24 years"
  } else if (age.s == "Y15-74") {
    age.text = "15-74 years"
  } else if (age.s == "Y20-64") {
    age.text = "20-64 years"
  } else if (age.s == "Y_GE15") {
    age.text = ">= 15 years"
  } else if (age.s == "Y_GE25") {
    age.text = ">= 25 years"
  } else {
    age.text = "Unknown"
  }

  if (sex.s == "F") {
    sex.text = "Females"
  } else if (sex.s == "M") {
    sex.text = "Males"
  } else if (sex.s == "T") {
    sex.text = "Both"
  } else {
    sex.text = "Unknown"
  }

  # Create the HTML content for the info box.
  sprintf("<strong>Year:</strong> %s<br/><strong>Age group</strong>: %s<br/><strong>Gender</strong> %s",
          time.s,
          age.text,
          sex.text
  )
}

#' Title
#'
#' @param obj
#' @param title.s
#'
#' @return
#' @export
#'
#' @examples
plot_eu_ts = function(obj, title.s) {
  p = ggplot(obj, aes(x = time, y = values, colour = desc))
  p = p + geom_line()
  p = p + theme_bw()
  p = p + labs(color = "Country")
  p = p + xlab("Year")
  p = p + ylab("Percent unemployed")
  p = p + ggtitle(title.s)
  p
}