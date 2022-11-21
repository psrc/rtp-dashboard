# Process PUMS 5-Year Data for RTP Data Monitoring
#
# This function processes 5-year Public Use Microdata Sample (PUMS) estimates from the U.S. Census Bureau.
# Data is pulled using PSRC's psrccensus package.
# 
# return tibble in long form of mean and share of travel mode and time to work by race/ethnicity, county, and region

process_pums_data <- function() {
  
  pums_years <- c(2015, 2020)   # latest year in 5-year span
  
  pums_metrics15 <- c("JWTR",   # travel mode to work (2011-2015)
                      "JWRIP",  # vehicle occupancy
                      "JWMNP",  # travel time to work
                      "PRACE"   # person race/ethnicity (in psrccensus)
  )
  
  pums_metrics20 <- c("JWTRNS", # travel mode to work (2016-2020)
                      "JWRIP",  # vehicle occupancy
                      "JWMNP",  # travel time to work
                      "PRACE"   # person race/ethnicity (in psrccensus)
  )
  
  # Process metrics from PUMS data for 2011-2015, 2016-2020
  processed <- NULL
  for (i in pums_years) {
    
    # Pull PUMS data
    pums <- psrccensus::get_psrc_pums(span = 5,
                                      dyear = i,
                                      level = "p",
                                      vars = ifelse(i == pums_years[1], pums_metrics15, pums_metrics20)) %>% 
      dplyr::rename(travel_mode = tidyselect::starts_with("JWTR"),
                    vehicle_occ = .data$JWRIP,
                    travel_time = .data$JWMNP,
                    race = .data$PRACE) %>% 
      dplyr::mutate(vehicle_occ = factor(dplyr::case_when(is.na(.data$vehicle_occ) ~ NA_character_,
                                                          .data$vehicle_occ == 1 ~ "Drove alone",
                                                          TRUE ~ "Carpool"))) %>% 
      dplyr::mutate(travel_mode = factor(case_when(is.na(.data$travel_mode) ~ NA_character_,
                                                   .data$travel_mode == "Car, truck, or van" & .data$vehicle_occ == "Drove alone" ~ "SOV",
                                                   .data$travel_mode == "Car, truck, or van" & .data$vehicle_occ == "Carpool" ~ "HOV",
                                                   TRUE ~ as.character(.data$travel_mode))),
                    travel_time = ifelse(is.na(.data$travel_time), NA_integer_, as.integer(.data$travel_time)),
                    commute_class = factor(case_when(is.na(.data$travel_time) ~ NA_character_,
                                                     as.integer(.data$travel_time) < 15 ~ "15 mintues or less",
                                                     as.integer(.data$travel_time) < 30 ~ "30 mintues or less",
                                                     as.integer(.data$travel_time) < 60 ~ "60 mintues or less",
                                                     as.integer(.data$travel_time) < 90 ~ "90 mintues or less",
                                                     as.integer(.data$travel_time) >= 90 ~ "Supercommuter")))
    
    # Summarize travel time means by county (incl. region) and race
    mean_time_county <- psrccensus::psrc_pums_mean(pums, stat_var = "travel_time", group_vars = "COUNTY") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       metric = "mean_commute_time",
                       data_year = .data$DATA_YEAR,
                       estimate = dplyr::ends_with("mean"),
                       moe = dplyr::ends_with("moe"))
    
    mean_time_race <- psrccensus::psrc_pums_mean(pums, stat_var = "travel_time", group_vars = "race") %>% 
      dplyr::filter(.data$race != "Total") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$race,
                       metric = "mean_commute_time",
                       data_year = .data$DATA_YEAR,
                       estimate = dplyr::ends_with("mean"),
                       moe = dplyr::ends_with("moe"))
    
    means <- dplyr::bind_rows(mean_time_county, mean_time_race) %>% 
      dplyr::mutate(data_year = as.character(.data$data_year))
    
    # Summarize counts/shares of travel time and mode by county (incl. region) and race
    class_county <- psrccensus::psrc_pums_count(pums,
                                                group_vars = c("COUNTY", "commute_class"),
                                                incl_na = FALSE) %>% 
      dplyr::filter(.data$COUNTY != "Region")
    
    count_class_county <- class_county %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "count_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_class_county <- class_county %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "share_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    class_region <- psrccensus::psrc_pums_count(pums,
                                                group_vars = "commute_class",
                                                incl_na = FALSE)
    
    count_class_region <- class_region %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "count_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_class_region <- class_region %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "share_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    class_race <- psrccensus::psrc_pums_count(pums,
                                              group_vars = c("race", "commute_class"),
                                              incl_na = FALSE) %>% 
      dplyr::filter(.data$race != "Total")
    
    count_class_race <- class_race %>% 
      dplyr::transmute(geography = .data$race,
                       variable = .data$commute_class,
                       metric = "count_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_class_race <- class_race %>% 
      dplyr::transmute(geography = .data$race,
                       variable = .data$commute_class,
                       metric = "share_commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    mode_county <- psrccensus::psrc_pums_count(pums,
                                               group_vars = c("COUNTY", "travel_mode"),
                                               incl_na = FALSE) %>% 
      dplyr::filter(.data$COUNTY != "Region")
    
    count_mode_county <- mode_county %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "count_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_mode_county <- mode_county %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "share_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    mode_region <- psrccensus::psrc_pums_count(pums,
                                               group_vars = "travel_mode",
                                               incl_na = FALSE)
    
    count_mode_region <- mode_region %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "count_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_mode_region <- mode_region %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "share_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    mode_race <- psrccensus::psrc_pums_count(pums,
                                             group_vars = c("race", "travel_mode"),
                                             incl_na = FALSE) %>% 
      dplyr::filter(.data$race != "Total")
    
    count_mode_race <- mode_race %>% 
      dplyr::transmute(geography = .data$race,
                       variable = .data$travel_mode,
                       metric = "count_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       moe = .data$count_moe)
    
    share_mode_race <- mode_race %>% 
      dplyr::transmute(geography = .data$race,
                       variable = .data$travel_mode,
                       metric = "share_travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$share,
                       moe = .data$share_moe)
    
    counts <- dplyr::bind_rows(count_class_county, share_class_county,
                               count_class_region, share_class_region,
                               count_class_race, share_class_race,
                               count_mode_county, share_mode_county,
                               count_mode_region, share_mode_region,
                               count_mode_race, share_mode_race) %>% 
      dplyr::mutate(data_year = as.character(.data$data_year))
    
    # Combine summarized tables
    ifelse(is.null(processed),
           processed <- dplyr::bind_rows(means, counts),
           processed <- dplyr::bind_rows(processed, means, counts))
    
  }
  
  return(processed)
  
}
