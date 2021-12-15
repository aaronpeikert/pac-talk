library(tidyverse)
get_preregistrations_raw <- function(date, max_pages = 10){
  api <- "https://api.osf.io/v2/registrations/?filter[date_created]="
  api <- paste0(api, date)
  out <- list()
  pages <- 1
  while (!is.null(api) && pages <= max_pages) {
    raw <- jsonlite::fromJSON(api)
    api <- raw$links$`next`
    out <- c(out, list(raw$data$attributes))
    pages <- pages + 1
  }
  return(out)
}
#test <- get_preregistrations_raw("2018-01")
#test2 <- jsonlite::read_json("data/2018-01.json", simplifyVector = TRUE)

dates <- seq(lubridate::as_date("2018-01-01"), Sys.Date(), 1)
data_path <- fs::dir_create("data")
paths <- fs::path_ext_set(fs::path(data_path, dates), ".json")
needed_dates <- !fs::file_exists(paths)
paths <- paths[needed_dates]
dates <- dates[needed_dates]
progress <- progress::progress_bar$new(total = length(dates),
                                       format = "[:bar] :percent eta: :eta in :elapsedfull")
walk2(dates,
      paths,
      ~{progress$tick();
        jsonlite::write_json(get_preregistrations_raw(.x, Inf), .y)})
