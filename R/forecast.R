#' Forecast EU unemployment using time series
#'
#' This function attempts to fit ARIMA, or ARFIMA models to the unemeployment data
#' from Eurostat in order to produce a h-step-ahead forecast of unemployment.
#'
#' @param ts The time series data from the Eurostat database.
#' @param h Number of periods forecasting. Default: 1.
#' @param model.type What kind of model should be fitted. Possible values: \code{arima, arfima}.
#'
#' @return A list containing the fitted model and forecasts.
#' @import forecast fracdiff
#' @export
#'
#' @examples
#'
#' # Apply time series models to Irish unemployment data.
#' load_eurostat_data(code = "ei_lmhu_m")
#' ireland.unemp.timeseries = get_eurostat_data(code = "ei_lmhu_m") %>%
#'     filter_ts_data(geo.s = "IE")
#'
#' # Get results.
#' res.arima = forecast_eu_unemp(ireland.unemp.timeseries$values)
#' res.arfima = forecast_eu_unemp(ireland.unemp.timeseries$values, model.type = "arfima")
#'
#' # Plot residuals.
#' par(mfrow = c(2, 1))
#'
#' plot(res.arima$model$residuals,
#'     main = "ARIMA Residuals",
#'     ylab = "Residuals",
#'     col = "blue")
#'
#' plot(res.arfima$model$residuals,
#'     main = "ARFIMA Residuals",
#'     ylab = "Residuals",
#'     col = "red")
#'
forecast_eu_unemp = function(ts, h = 1, model.type = c("arima", "arfima")) {

  # Determine type of model to use.
  mtype = match.arg(model.type)

  fc = NULL
  fit = NULL
  if (mtype == "arima") {
    # Build ARIMA model and predict.
    fit = auto.arima(ts)
    fc = forecast(fit, h)
  } else {
    # Build ARFIMA model and predict.
    fit = arfima(ts)
    fc = forecast(fit, h)
  }

  # Return model and forecast.
  list(model = fit, forecast = fc)
}
