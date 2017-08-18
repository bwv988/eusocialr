# Run the shiny app.

#' Run the \code{eusocialr} Shiny demo app
#'
#' This function runs the built-in Shiny application to demo some of the packages functions.
#'
#' @return Shiny application
#'
#' @export
#'
#' @examples
#'
#' # Example commented out, because it will make devtools::check() hang.
#' # eusocialr_shiny()
eusocialr_shiny = function() {
  appDir = system.file("shiny-examples",
                       "eusocial-viz",
                       package = "eusocialr")

  if (appDir == "") {
    stop("Could not find shiny directory in package. Try re-installing `eusocialr`.",
         call. = FALSE)
  }

  shiny = NULL
  shiny::runApp(appDir, display.mode = "normal")
}
