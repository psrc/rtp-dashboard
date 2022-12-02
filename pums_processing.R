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
                                      vars = if(i == pums_years[1]) pums_metrics15 else pums_metrics20) %>% 
      dplyr::rename(travel_mode = tidyselect::starts_with("JWTR"),
                    vehicle_occ = .data$JWRIP,
                    travel_time = .data$JWMNP,
                    race = .data$PRACE) %>% 
      dplyr::mutate(vehicle_occ = factor(dplyr::case_when(is.na(.data$vehicle_occ) ~ NA_character_,
                                                          .data$vehicle_occ == 1 ~ "Drove alone",
                                                          TRUE ~ "Carpool"))) %>% 
      dplyr::mutate(travel_mode = factor(dplyr::case_when(is.na(.data$travel_mode) ~ NA_character_,
                                                          .data$travel_mode == "Car, truck, or van" & .data$vehicle_occ == "Drove alone" ~ "SOV",
                                                          .data$travel_mode == "Car, truck, or van" & .data$vehicle_occ == "Carpool" ~ "HOV",
                                                          TRUE ~ as.character(.data$travel_mode))),
                    travel_time = ifelse(is.na(.data$travel_time), NA_integer_, as.integer(.data$travel_time)),
                    commute_class = factor(dplyr::case_when(is.na(.data$travel_time) ~ NA_character_,
                                                            as.integer(.data$travel_time) < 15 ~ "15 mintues or less",
                                                            as.integer(.data$travel_time) < 30 ~ "30 mintues or less",
                                                            as.integer(.data$travel_time) < 60 ~ "60 mintues or less",
                                                            as.integer(.data$travel_time) < 90 ~ "90 mintues or less",
                                                            as.integer(.data$travel_time) >= 90 ~ "Supercommuter")),
                    race_condensed = factor(dplyr::case_when(.data$race %in% c("American Indian or Alaskan Native Alone",
                                                                               "Asian alone",
                                                                               "Black or African American alone",
                                                                               "Hispanic or Latino",
                                                                               "Native Hawaiian and Other Pacific Islander alone",
                                                                               "Some Other Race alone",
                                                                               "Two or More Races")
                                                               ~ "POC",
                                                             .data$race == "White alone" ~ "White")))
    
    # Summarize travel time means by county (incl. region) and race
    mean_time_county <- psrccensus::psrc_pums_mean(pums,
                                                   stat_var = "travel_time",
                                                   group_vars = "COUNTY") %>% 
      dplyr::select(geography = .data$COUNTY,
                    data_year = .data$DATA_YEAR,
                    estimate = dplyr::ends_with("mean"),
                    moe = dplyr::ends_with("moe")) %>% 
      dplyr::mutate(metric = "mean_commute_time", .before = .data$data_year)
    
    mean_time_race <- psrccensus::psrc_pums_mean(pums,
                                                 stat_var = "travel_time",
                                                 group_vars = "race_condensed") %>% 
      dplyr::filter(.data$race_condensed != "Total") %>% 
      dplyr::select(geography = .data$COUNTY,
                    grouping = .data$race_condensed,
                    data_year = .data$DATA_YEAR,
                    estimate = dplyr::ends_with("mean"),
                    moe = dplyr::ends_with("moe")) %>% 
      dplyr::mutate(metric = "mean_commute_time", .before = .data$data_year)
    
    means <- dplyr::bind_rows(mean_time_county, mean_time_race) %>% 
      dplyr::mutate(data_year = as.character(.data$data_year))
    
    # Summarize counts/shares of travel time and mode by county (incl. region) and race
    class_county <- psrccensus::psrc_pums_count(pums,
                                                group_vars = c("COUNTY", "commute_class"),
                                                incl_na = FALSE) %>% 
      dplyr::filter(.data$COUNTY != "Region") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)

    class_region <- psrccensus::psrc_pums_count(pums,
                                                group_vars = "commute_class",
                                                incl_na = FALSE) %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$commute_class,
                       metric = "commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)
    
    class_race <- psrccensus::psrc_pums_count(pums,
                                              group_vars = c("race_condensed", "commute_class"),
                                              incl_na = FALSE) %>% 
      dplyr::filter(.data$race_condensed != "Total") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       grouping = .data$race_condensed,
                       variable = .data$commute_class,
                       metric = "commute_class",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)
    
    mode_county <- psrccensus::psrc_pums_count(pums,
                                               group_vars = c("COUNTY", "travel_mode"),
                                               incl_na = FALSE) %>% 
      dplyr::filter(.data$COUNTY != "Region") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)
    
    mode_region <- psrccensus::psrc_pums_count(pums,
                                               group_vars = "travel_mode",
                                               incl_na = FALSE) %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       variable = .data$travel_mode,
                       metric = "travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)
    
    mode_race <- psrccensus::psrc_pums_count(pums,
                                             group_vars = c("race_condensed", "travel_mode"),
                                             incl_na = FALSE) %>% 
      dplyr::filter(.data$race_condensed != "Total") %>% 
      dplyr::transmute(geography = .data$COUNTY,
                       grouping = .data$race_condensed,
                       variable = .data$travel_mode,
                       metric = "travel_mode",
                       data_year = .data$DATA_YEAR,
                       estimate = .data$count,
                       estimate_moe = .data$count_moe,
                       share = .data$share,
                       share_moe = .data$share_moe)
    
    counts <- dplyr::bind_rows(class_county, class_region, class_race,
                               mode_county, mode_region, mode_race) %>% 
      dplyr::mutate(data_year = as.character(.data$data_year))
    
    # Combine summarized tables
    ifelse(is.null(processed),
           processed <- dplyr::bind_rows(means, counts),
           processed <- dplyr::bind_rows(processed, means, counts))
    
  }
  
  processed <- processed[, c("geography", "grouping", "variable", "metric", "data_year", "estimate", "estimate_moe", "share", "share_moe")]
  
  return(processed)
  
}
