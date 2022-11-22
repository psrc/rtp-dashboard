# Process NTD Monthly Transit Data for RTP Data Monitoring
#
# This function processes Transit Agency monthly data from the Nation Transit Database.
# Data is pulled monthly from "https://www.transit.dot.gov/sites/fta.dot.gov/files/".
# 
# return tibble in long form of yearly Boardings, Revenue-Miles, Revenue-Hours, and boardings per hour by Agency and Region
#
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export

process_ntd_data <- function() {
  
  ntd_tabs <- c("UPT", "VRM", "VRH")
  
  bus_modes <- c("CB", "MB", "TB")
  ferry_modes <- c("FB")
  light_rail_modes <- c("LR", "SR", "MG", "MO")
  commuter_rail_modes <- c("CR")
  vanpool_modes <- c("VP")
  
  today <- Sys.Date()
  c_yr <- lubridate::year(today)
  c_dy <- lubridate::day(today)
  
  if(c_dy <= 7) {
    c_mo <- formatC(as.integer(lubridate::month(today))-1, width=2, flag="0")
    d_mo <- month.name[[as.integer(lubridate::month(today)) - 3]]
    
  } else {
    
    c_mo <- formatC(as.integer(lubridate::month(today)), width=2, flag="0")
    d_mo <- month.name[[as.integer(lubridate::month(today)) - 2]]
    
  }
  
  data_url <- paste0("https://www.transit.dot.gov/sites/fta.dot.gov/files/",c_yr,"-",c_mo,"/",d_mo,"%20",c_yr,"%20Raw%20Database.xlsx")
  
  utils::download.file(data_url, "working.xlsx", quiet = TRUE, mode = "wb")
  data_file <- paste0(getwd(),"/working.xlsx")
  
  # Initial processing of NTD data
  processed <- NULL
  for (areas in ntd_tabs) {
    
    t <- dplyr::as_tibble(openxlsx::read.xlsx(data_file, sheet = areas, skipEmptyRows = TRUE, startRow = 1, colNames = TRUE)) %>%
      dplyr::filter(.data$UZA %in% c(14, 180)  # Seattle MSA, Bremerton MSA
                    & .data$Modes != "DR") %>% 
      dplyr::select(-.data$`4.digit.NTD.ID`, -.data$`5.digit.NTD.ID`, -.data$Active, -.data$Reporter.Type, -.data$UZA, -.data$UZA.Name, -.data$TOS) %>% 
      dplyr::mutate(Agency = dplyr::case_when(.data$Agency == "Snohomish County Public Transportation Benefit Area Corporation" ~ "Community Transit",
                                              .data$Agency == "Central Puget Sound Regional Transit Authority" ~ "Sound Transit",
                                              .data$Agency == "King County Department of Metro Transit"~ "King County Metro",
                                              .data$Agency == "Pierce County Transportation Benefit Area Authority" ~ "Pierce Transit",
                                              .data$Agency == "City of Everett" ~ "Everett Transit",
                                              .data$Agency == "King County Ferry District" ~ "King County Metro",
                                              TRUE ~ .data$Agency)) %>% 
      dplyr::rename(variable = .data$Modes) %>% 
      tidyr::pivot_longer(cols = 3:length(.),
                          names_to = "data_date",
                          values_to = "estimate",
                          values_drop_na = TRUE) %>% 
      dplyr::mutate(metric = areas,
                    data_year = as.numeric(paste0("20", stringr::str_sub(.data$data_date, -2, -1))),
                    variable = dplyr::case_when(.data$variable %in% commuter_rail_modes ~ "Commuter Rail",
                                                .data$variable %in% light_rail_modes ~ "Light Rail, Streetcar, & Monorail",
                                                .data$variable %in% bus_modes ~ "Bus",
                                                .data$variable %in% ferry_modes ~ "Ferry",
                                                .data$variable %in% vanpool_modes ~ "Vanpool")) %>% 
      dplyr::mutate(metric = dplyr::case_when(.data$metric == "UPT" ~ "Transit Boardings",
                                              .data$metric == "VRM" ~ "Transit Revenue-Miles",
                                              .data$metric == "VRH" ~ "Transit Revenue-Hours")) %>% 
      dplyr::group_by(.data$Agency, .data$variable, .data$metric, .data$data_year) %>% 
      dplyr::summarize(estimate = sum(.data$estimate)) %>% 
      dplyr::as_tibble()
    
    ifelse(is.null(processed), processed <- t, processed <- dplyr::bind_rows(processed, t))
  }
  
  # Pivot NTD data wide and create new metric: boardings per revenue-hour
  processed_wide <- processed %>% 
    tidyr::pivot_wider(names_from = .data$metric,
                       values_from = .data$estimate) %>% 
    dplyr::mutate(boardings_per_hour = ifelse(.data$`Transit Revenue-Hours` > 0,
                                              round(.data$`Transit Boardings` / .data$`Transit Revenue-Hours`, 2), NA))
  
  # Pivot NTD data back to long and create region-wide estimates per metric
  processed <- processed_wide %>% 
    tidyr::pivot_longer(cols = c(.data$`Transit Boardings`,
                                 .data$`Transit Revenue-Miles`,
                                 .data$`Transit Revenue-Hours`,
                                 .data$boardings_per_hour),
                        names_to = "metric",
                        values_to = "estimate")
  
  region <- processed %>%
    dplyr::group_by(.data$variable, .data$metric, .data$data_year) %>%
    dplyr::summarize(estimate = sum(.data$estimate)) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(Agency = "Region")
  
  processed <- dplyr::bind_rows(list(processed, region)) %>% 
    dplyr::rename(geography = .data$Agency)
  
  file.remove(data_file)
  
  processed <- processed[, c("geography", "variable", "metric", "data_year", "estimate")]
  
  return(processed)
  
}
