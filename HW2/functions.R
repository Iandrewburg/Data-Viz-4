load_data <- function() {
  read.csv("DailyDelhiClimateTest.csv", stringsAsFactors = FALSE)
}


preprocess_data <- function(data) {
  data$date <- as.Date(data$date, format = "%Y-%m-%d")
  return(data)
}

create_ggplot <- function(data, x_var, y_var) {
  ggplot(data, aes_string(x = x_var, y = y_var)) +
    geom_line() +
    labs(title = paste("Time Series of", y_var), x = x_var, y = y_var)
}

