library(tidyverse)
library(data.table)
library(psrccensus)
library(psrcrtp)
library(psrcelmer)
library(tidycensus)
library(sf)
library(here)

wgs84 <- 4326
current_year <- "2024"

pre_covid <- 2019
current_ntd_year <- "2025"

acs_data_yrs <- c(2014, 2019, 2024)
pums_data_yrs <- c(2014, 2019, 2024)

metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

rtp_network_url <- "X:/DSA/rtp-dashboard/"
rtp_local_url <- "C:/Users/chelmann/OneDrive - PSRC/coding"
rtp_dashboard_congestion_url <- "C:/Users/chelmann/OneDrive - PSRC/coding/rtp-dashboard/rtp-dashboard-process/outputs/congestion/"
rtp_dashboard_process_url <- "C:/Users/chelmann/OneDrive - PSRC/coding/rtp-dashboard/rtp-dashboard-process/data"

# Functions ---------------------------------------------------------------
acs_data <- function(years=c(2024), acs_tbl="B08301", acs_variables="commute-modes") {
  
  # Always use ACS 5yr data since we need it for places, tracts and MPO comparisons as well as 2020 data
  acs_type <- 'acs5'
  
  # Columns to keep from Tidy Census Pull
  cols_to_keep <- c("name", "variable", "estimate", "moe", "census_geography", "year")
  
  # Variables for dashboard
  variables <- read_csv(system.file('extdata', paste0(acs_variables,".csv"), package='psrcrtp'), show_col_types = FALSE)
  
  working_data <- NULL
  for (y in years) {
    print(str_glue("Working on {y}"))
    
    # County & Region data for PSRC region
    # Download the Data
    county_data <- get_acs_recs(geography = 'county', table.names = acs_tbl, years=y, acs.type = acs_type) 
    # Variables of interest
    county_data <- county_data |> filter(.data$variable %in% unique(variables$variable))
    # Clean up columns
    county_data <- county_data |> select(all_of(cols_to_keep))
    # Add labels
    county_data <- left_join(county_data, variables, by=c("variable"))
    # Consolidate rows based on simple labels
    county_data <- county_data |> 
      group_by(.data$name, .data$census_geography, .data$year, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label")
    # Get totals
    total <- county_data |>filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    county_data <- left_join(county_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    rm(total)
    
    # Cities in the PSRC region
    # Download the Data
    city_data <- get_acs(state = "53", geography = 'place', table = acs_tbl, year=y, survey = acs_type) 
    psrc_places <- get_psrc_places(y) |> st_drop_geometry()
    place_FIPS <- unique(psrc_places$GEOID)
    
    city_data <- city_data |> filter(GEOID %in% place_FIPS) |>
      filter(!(str_detect(NAME, "CDP"))) |>
      mutate(NAME = str_remove_all(NAME, " city, Washington")) |>
      mutate(NAME = str_remove_all(NAME, " town, Washington")) |>
      rename(name = "NAME") |>
      mutate(year = y, census_geography = "City")
    
    # Variables of interest
    city_data <- city_data |> filter(.data$variable %in% unique(variables$variable))
    # Clean up columns
    city_data <- city_data |> select(all_of(cols_to_keep))
    # Add labels
    city_data <- left_join(city_data, variables, by=c("variable"))
    # Consolidate rows based on simple labels
    city_data <- city_data |> 
      group_by(.data$name, .data$census_geography, .data$year, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label")
    # Get totals
    total <- city_data |> filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    city_data <- left_join(city_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    rm(total)
    
    # Metro Areas
    mpo <- read_csv(system.file('extdata', 'regional-councils-counties.csv', package='psrcrtp'), show_col_types = FALSE) |> 
      mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY_FIPS, width=3, side=c("left"), pad="0")) |>
      mutate(STATE_FIPS=stringr::str_pad(.data$STATE_FIPS, width=2, side=c("left"), pad="0")) |>
      mutate(GEOID = paste0(.data$STATE_FIPS,.data$COUNTY_FIPS))
    
    states <- mpo |> select("STATE_FIPS") |> distinct() |> pull()
    counties <- mpo |> select("GEOID") |> distinct() |>pull()
    
    mpo_data <- NULL
    for (st in states) {
      c <- mpo |> filter(.data$STATE_FIPS %in% st) |> select("COUNTY_FIPS") |> pull()
      d <- get_acs(geography = "county", state=st, county=c, table = acs_tbl, year = y, survey = acs_type)
      ifelse(is.null(mpo_data), mpo_data <- d, mpo_data <- bind_rows(mpo_data,d))
      rm(c, d)
    }
    
    # Variables of interest
    mpo_data <- mpo_data |> filter(.data$variable %in% unique(variables$variable))
    # Add labels
    mpo_data <- left_join(mpo_data, variables, by=c("variable"))
    # Add in MPO Information
    mpo_county_data <- left_join(mpo, mpo_data, by="GEOID", multiple = "all")
    # Consolidate rows based on simple labels
    mpo_county_data <- mpo_county_data |> 
      group_by(.data$MPO_AREA, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label", name = "MPO_AREA") |>
      mutate(year=y, census_geography="Metro Areas")
    # Get totals
    total <- mpo_county_data |> filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    mpo_county_data <- left_join(mpo_county_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    mpo_data <- mpo_county_data
    rm(total, mpo_county_data)
    
    d <- bind_rows(county_data, city_data, mpo_data)
    
    if(is.null(working_data)) {working_data <- d} else {working_data <- bind_rows(working_data, d)}
    
  }
  
  # Match column names to rtp-dashboard inputs
  working_data <- working_data |> 
    mutate(date=mdy(paste0("12-01-",.data$year)), grouping="All", metric=acs_variables) |>
    mutate(year = as.character(year(.data$date))) |>
    select("year", "date", geography="name", geography_type="census_geography", variable="label", "grouping", "metric", "estimate", "share", "moe")
  
  return(working_data)
}

process_acs_data <- function(data_years = c(2021)) {
  
  print("Working on Mode to Work")
  mw <- acs_data(years=data_years, acs_tbl="B08301", acs_variables="commute-modes")
  print("Working on Travel time to Work")
  tw <- acs_data(years=data_years, acs_tbl="B08303", acs_variables="commute-times")
  print("Working on Departure time to work")
  dw <- acs_data(years=data_years, acs_tbl="B08011", acs_variables="departure-time")

  processed <- bind_rows(mw, tw, dw)
  
  return(processed)
  
}

pums_data <- function(pums_yr) {
  
  pums_span <- 5
  
  # Silence the dplyr summarize message
  options(dplyr.summarise.inform = FALSE)
  
  pums_vars_old <- c("JWTR",   # travel mode to work (prior to 2019)
                     "JWRIP",  # vehicle occupancy
                     "JWMNP",  # travel time to work
                     "JWDP", # departure time to work
                     "PRACE"   # person race/ethnicity (in psrccensus)
  )
  
  pums_vars_new <- c("JWTRNS", # travel mode to work (2019 and later)
                     "JWRIP",  # vehicle occupancy
                     "JWMNP",  # travel time to work
                     "JWDP", # departure time to work
                     "PRACE"   # person race/ethnicity (in psrccensus)
  )
  
  # Process metrics from PUMS data
  processed <- NULL
  for (i in pums_yr) {
    
    print(str_glue("Downloading PUMS {pums_span}-year data for {i}. This can take a few minutes."))
    pums <- get_psrc_pums(dir = "J:/projects/Census/AmericanCommunitySurvey/Data/PUMS/pums_rds",
                          span = pums_span,
                          dyear = i,
                          level = "p",
                          vars = if(i < 2019) pums_vars_old else pums_vars_new) 
    
    print(str_glue("Cleaning up attribute names for {i} PUMS data"))
    p <- pums |> 
      rename(mode = starts_with("JWTR"), occupancy = "JWRIP", departure = "JWDP", times = "JWMNP", race = "PRACE") |> 
      # Clean up Occupancy for use in determining Drove Alone or Carpool
      mutate(occupancy = factor(case_when(is.na(occupancy) ~ NA_character_,
                                          occupancy == 1 ~ "Drove alone",
                                          TRUE ~ "Carpool"))) |> 
      # Clean up Mode Names
      mutate(mode = factor(case_when(is.na(mode) ~ NA_character_,
                                     mode == "Car, truck, or van" & occupancy == "Drove alone" ~ "Drove alone",
                                     mode == "Car, truck, or van" & occupancy == "Carpool" ~ "Carpool",
                                     mode == "Bus" ~ "Transit",
                                     mode == "Bus or trolley bus" ~ "Transit",
                                     mode == "Ferryboat" ~ "Transit",
                                     mode == "Streetcar or trolley car (carro publico in Puerto Rico)" ~ "Transit",
                                     mode == "Light rail, streetcar, or trolley" ~ "Transit",
                                     mode == "Railroad" ~ "Transit",
                                     mode == "Long-distance train or commuter rail" ~ "Transit",
                                     mode == "Other method" ~ "Other",
                                     mode == "Taxicab" ~ "Other",
                                     mode == "Motorcycle" ~ "Other",
                                     mode == "Taxi or ride-hailing services" ~ "Other",
                                     mode == "Subway or elevated" ~ "Transit",
                                     mode == "Subway or elevated rail" ~ "Transit",
                                     mode == "Worked at home" ~ "Worked from home",
                                     TRUE ~ as.character(mode)))) |>
      # Clean up Travel Times
      mutate(times = ifelse(is.na(times), NA_integer_, as.integer(times))) |>
      # Travel Time Bins
      mutate(travel_time_bins = factor(case_when(is.na(times) ~ NA_character_,
                                                 as.integer(times) < 15 ~ "Less than 15 minutes",
                                                 as.integer(times) < 30 ~ "15 to 30 minutes",
                                                 as.integer(times) < 45 ~ "30 to 45 minutes",
                                                 as.integer(times) < 60 ~ "45 to 60 minutes",
                                                 as.integer(times) >= 60 ~ "more than 60 minutes"))) |>
      # Departure Time Bins
      mutate(departure_time_bins = factor(case_when(is.na(departure) ~ NA_character_,
                                                    # Overnight
                                                    departure == "12:00 a.m. to 12:29 a.m." ~ "Overnight",
                                                    departure == "12:30 a.m. to 12:59 a.m." ~ "Overnight",
                                                    departure == "1:00 a.m. to 1:29 a.m." ~ "Overnight",
                                                    departure == "1:30 a.m. to 1:59 a.m." ~ "Overnight",
                                                    departure == "2:00 a.m. to 2:29 a.m." ~ "Overnight",
                                                    departure == "2:30 a.m. to 2:59 a.m." ~ "Overnight",
                                                    departure == "3:00 a.m. to 3:09 a.m." ~ "Overnight",
                                                    departure == "3:10 a.m. to 3:19 a.m." ~ "Overnight",
                                                    departure == "3:20 a.m. to 3:29 a.m." ~ "Overnight",
                                                    departure == "3:30 a.m. to 3:39 a.m." ~ "Overnight",
                                                    departure == "3:40 a.m. to 3:49 a.m." ~ "Overnight",
                                                    departure == "3:50 a.m. to 3:59 a.m." ~ "Overnight",
                                                    departure == "4:00 a.m. to 4:09 a.m." ~ "Overnight",
                                                    departure == "4:10 a.m. to 4:19 a.m." ~ "Overnight",
                                                    departure == "4:20 a.m. to 4:29 a.m." ~ "Overnight",
                                                    departure == "4:30 a.m. to 4:39 a.m." ~ "Overnight",
                                                    departure == "4:40 a.m. to 4:49 a.m." ~ "Overnight",
                                                    departure == "4:50 a.m. to 4:59 a.m." ~ "Overnight",
                                                    # Early Morning
                                                    departure == "5:00 a.m. to 5:04 a.m." ~ "Early Morning",
                                                    departure == "5:05 a.m. to 5:09 a.m." ~ "Early Morning",
                                                    departure == "5:10 a.m. to 5:14 a.m." ~ "Early Morning",
                                                    departure == "5:15 a.m. to 5:19 a.m." ~ "Early Morning",
                                                    departure == "5:20 a.m. to 5:24 a.m." ~ "Early Morning",
                                                    departure == "5:25 a.m. to 5:29 a.m." ~ "Early Morning",
                                                    departure == "5:30 a.m. to 5:34 a.m." ~ "Early Morning",
                                                    departure == "5:35 a.m. to 5:39 a.m." ~ "Early Morning",
                                                    departure == "5:40 a.m. to 5:44 a.m." ~ "Early Morning",
                                                    departure == "5:45 a.m. to 5:49 a.m." ~ "Early Morning",
                                                    departure == "5:50 a.m. to 5:54 a.m." ~ "Early Morning",
                                                    departure == "5:55 a.m. to 5:59 a.m." ~ "Early Morning",
                                                    departure == "6:00 a.m. to 6:04 a.m." ~ "Early Morning",
                                                    departure == "6:05 a.m. to 6:09 a.m." ~ "Early Morning",
                                                    departure == "6:10 a.m. to 6:14 a.m." ~ "Early Morning",
                                                    departure == "6:15 a.m. to 6:19 a.m." ~ "Early Morning",
                                                    departure == "6:20 a.m. to 6:24 a.m." ~ "Early Morning",
                                                    departure == "6:25 a.m. to 6:29 a.m." ~ "Early Morning",
                                                    departure == "6:30 a.m. to 6:34 a.m." ~ "Early Morning",
                                                    departure == "6:35 a.m. to 6:39 a.m." ~ "Early Morning",
                                                    departure == "6:40 a.m. to 6:44 a.m." ~ "Early Morning",
                                                    departure == "6:45 a.m. to 6:49 a.m." ~ "Early Morning",
                                                    departure == "6:50 a.m. to 6:54 a.m." ~ "Early Morning",
                                                    departure == "6:55 a.m. to 6:59 a.m." ~ "Early Morning",
                                                    # AM Peak
                                                    departure == "7:00 a.m. to 7:04 a.m." ~ "AM Peak",
                                                    departure == "7:05 a.m. to 7:09 a.m." ~ "AM Peak",
                                                    departure == "7:10 a.m. to 7:14 a.m." ~ "AM Peak",
                                                    departure == "7:15 a.m. to 7:19 a.m." ~ "AM Peak",
                                                    departure == "7:20 a.m. to 7:24 a.m." ~ "AM Peak",
                                                    departure == "7:25 a.m. to 7:29 a.m." ~ "AM Peak",
                                                    departure == "7:30 a.m. to 7:34 a.m." ~ "AM Peak",
                                                    departure == "7:35 a.m. to 7:39 a.m." ~ "AM Peak",
                                                    departure == "7:40 a.m. to 7:44 a.m." ~ "AM Peak",
                                                    departure == "7:45 a.m. to 7:49 a.m." ~ "AM Peak",
                                                    departure == "7:50 a.m. to 7:54 a.m." ~ "AM Peak",
                                                    departure == "7:55 a.m. to 7:59 a.m." ~ "AM Peak",
                                                    departure == "8:00 a.m. to 8:04 a.m." ~ "AM Peak",
                                                    departure == "8:05 a.m. to 8:09 a.m." ~ "AM Peak",
                                                    departure == "8:10 a.m. to 8:14 a.m." ~ "AM Peak",
                                                    departure == "8:15 a.m. to 8:19 a.m." ~ "AM Peak",
                                                    departure == "8:20 a.m. to 8:24 a.m." ~ "AM Peak",
                                                    departure == "8:25 a.m. to 8:29 a.m." ~ "AM Peak",
                                                    departure == "8:30 a.m. to 8:34 a.m." ~ "AM Peak",
                                                    departure == "8:35 a.m. to 8:39 a.m." ~ "AM Peak",
                                                    departure == "8:40 a.m. to 8:44 a.m." ~ "AM Peak",
                                                    departure == "8:45 a.m. to 8:49 a.m." ~ "AM Peak",
                                                    departure == "8:50 a.m. to 8:54 a.m." ~ "AM Peak",
                                                    departure == "8:55 a.m. to 8:59 a.m." ~ "AM Peak",
                                                    # Late Morning
                                                    departure == "9:00 a.m. to 9:04 a.m." ~ "Late Morning",
                                                    departure == "9:05 a.m. to 9:09 a.m." ~ "Late Morning",
                                                    departure == "9:10 a.m. to 9:14 a.m." ~ "Late Morning",
                                                    departure == "9:15 a.m. to 9:19 a.m." ~ "Late Morning",
                                                    departure == "9:20 a.m. to 9:24 a.m." ~ "Late Morning",
                                                    departure == "9:25 a.m. to 9:29 a.m." ~ "Late Morning",
                                                    departure == "9:30 a.m. to 9:34 a.m." ~ "Late Morning",
                                                    departure == "9:35 a.m. to 9:39 a.m." ~ "Late Morning",
                                                    departure == "9:40 a.m. to 9:44 a.m." ~ "Late Morning",
                                                    departure == "9:45 a.m. to 9:49 a.m." ~ "Late Morning",
                                                    departure == "9:50 a.m. to 9:54 a.m." ~ "Late Morning",
                                                    departure == "9:55 a.m. to 9:59 a.m." ~ "Late Morning",
                                                    departure == "10:00 a.m. to 10:09 a.m." ~ "Late Morning",
                                                    departure == "10:10 a.m. to 10:19 a.m." ~ "Late Morning",
                                                    departure == "10:20 a.m. to 10:29 a.m." ~ "Late Morning",
                                                    departure == "10:30 a.m. to 10:39 a.m." ~ "Late Morning",
                                                    departure == "10:40 a.m. to 10:49 a.m." ~ "Late Morning",
                                                    departure == "10:50 a.m. to 10:59 a.m." ~ "Late Morning",
                                                    departure == "11:00 a.m. to 11:09 a.m." ~ "Late Morning",
                                                    departure == "11:10 a.m. to 11:19 a.m." ~ "Late Morning",
                                                    departure == "11:20 a.m. to 11:29 a.m." ~ "Late Morning",
                                                    departure == "11:30 a.m. to 11:39 a.m." ~ "Late Morning",
                                                    departure == "11:40 a.m. to 11:49 a.m." ~ "Late Morning",
                                                    departure == "11:50 a.m. to 11:59 a.m." ~ "Late Morning",
                                                    # Afternoon
                                                    departure == "12:00 p.m. to 12:09 p.m." ~ "Afternoon",
                                                    departure == "12:10 p.m. to 12:19 p.m." ~ "Afternoon",
                                                    departure == "12:20 p.m. to 12:29 p.m." ~ "Afternoon",
                                                    departure == "12:30 p.m. to 12:39 p.m." ~ "Afternoon",
                                                    departure == "12:40 p.m. to 12:49 p.m." ~ "Afternoon",
                                                    departure == "12:50 p.m. to 12:59 p.m." ~ "Afternoon",
                                                    departure == "1:00 p.m. to 1:09 p.m." ~ "Afternoon",
                                                    departure == "1:10 p.m. to 1:19 p.m." ~ "Afternoon",
                                                    departure == "1:20 p.m. to 1:29 p.m." ~ "Afternoon",
                                                    departure == "1:30 p.m. to 1:39 p.m." ~ "Afternoon",
                                                    departure == "1:40 p.m. to 1:49 p.m." ~ "Afternoon",
                                                    departure == "1:50 p.m. to 1:59 p.m." ~ "Afternoon",
                                                    departure == "2:00 p.m. to 2:09 p.m." ~ "Afternoon",
                                                    departure == "2:10 p.m. to 2:19 p.m." ~ "Afternoon",
                                                    departure == "2:20 p.m. to 2:29 p.m." ~ "Afternoon",
                                                    departure == "2:30 p.m. to 2:39 p.m." ~ "Afternoon",
                                                    departure == "2:40 p.m. to 2:49 p.m." ~ "Afternoon",
                                                    departure == "2:50 p.m. to 2:59 p.m." ~ "Afternoon",
                                                    departure == "3:00 p.m. to 3:09 p.m." ~ "Afternoon",
                                                    departure == "3:10 p.m. to 3:19 p.m." ~ "Afternoon",
                                                    departure == "3:20 p.m. to 3:29 p.m." ~ "Afternoon",
                                                    departure == "3:30 p.m. to 3:39 p.m." ~ "Afternoon",
                                                    departure == "3:40 p.m. to 3:49 p.m." ~ "Afternoon",
                                                    departure == "3:50 p.m. to 3:59 p.m." ~ "Afternoon",
                                                    # Evening
                                                    departure == "4:00 p.m. to 4:09 p.m." ~ "Evening",
                                                    departure == "4:10 p.m. to 4:19 p.m." ~ "Evening",
                                                    departure == "4:20 p.m. to 4:29 p.m." ~ "Evening",
                                                    departure == "4:30 p.m. to 4:39 p.m." ~ "Evening",
                                                    departure == "4:40 p.m. to 4:49 p.m." ~ "Evening",
                                                    departure == "4:50 p.m. to 4:59 p.m." ~ "Evening",
                                                    departure == "5:00 p.m. to 5:09 p.m." ~ "Evening",
                                                    departure == "5:10 p.m. to 5:19 p.m." ~ "Evening",
                                                    departure == "5:20 p.m. to 5:29 p.m." ~ "Evening",
                                                    departure == "5:30 p.m. to 5:39 p.m." ~ "Evening",
                                                    departure == "5:40 p.m. to 5:49 p.m." ~ "Evening",
                                                    departure == "5:50 p.m. to 5:59 p.m." ~ "Evening",
                                                    departure == "6:00 p.m. to 6:09 p.m." ~ "Evening",
                                                    departure == "6:10 p.m. to 6:19 p.m." ~ "Evening",
                                                    departure == "6:20 p.m. to 6:29 p.m." ~ "Evening",
                                                    departure == "6:30 p.m. to 6:39 p.m." ~ "Evening",
                                                    departure == "6:40 p.m. to 6:49 p.m." ~ "Evening",
                                                    departure == "6:50 p.m. to 6:59 p.m." ~ "Evening",
                                                    departure == "7:00 p.m. to 7:29 p.m." ~ "Evening",
                                                    departure == "7:30 p.m. to 7:59 p.m." ~ "Evening",
                                                    departure == "8:00 p.m. to 8:29 p.m." ~ "Evening",
                                                    departure == "8:30 p.m. to 8:59 p.m." ~ "Evening",
                                                    departure == "9:00 p.m. to 9:09 p.m." ~ "Evening",
                                                    departure == "9:10 p.m. to 9:19 p.m." ~ "Evening",
                                                    departure == "9:20 p.m. to 9:29 p.m." ~ "Evening",
                                                    departure == "9:30 p.m. to 9:39 p.m." ~ "Evening",
                                                    departure == "9:40 p.m. to 9:49 p.m." ~ "Evening",
                                                    departure == "9:50 p.m. to 9:59 p.m." ~ "Evening",
                                                    departure == "10:00 p.m. to 10:09 p.m." ~ "Evening",
                                                    departure == "10:10 p.m. to 10:19 p.m." ~ "Evening",
                                                    departure == "10:20 p.m. to 10:29 p.m." ~ "Evening",
                                                    departure == "10:30 p.m. to 10:39 p.m." ~ "Evening",
                                                    departure == "10:40 p.m. to 10:49 p.m." ~ "Evening",
                                                    departure == "10:50 p.m. to 10:59 p.m." ~ "Evening",
                                                    departure == "11:00 p.m. to 11:29 p.m." ~ "Evening",
                                                    departure == "11:30 p.m. to 11:59 p.m." ~ "Evening")))
    
    print(str_glue("Calculating mean travel time to work by county for PUMS {pums_span}-year data for {i}"))
    mean_time_county <- psrc_pums_mean(p, stat_var = "times", group_vars = "COUNTY") |>
      select(geography = "COUNTY", date = "DATA_YEAR", estimate = ends_with("mean"), moe = ends_with("moe")) |>
      mutate(metric = "Mean Commute Time",
             date = lubridate::ymd(paste0(date, "-12-01")),
             year = as.character(lubridate::year(date)),
             geography_type = ifelse(geography == "Region", "Region", "County"),
             grouping = "Workers over 16yrs of age",
             variable = "travel time to work") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "moe")
    
    print(str_glue("Calculating mean travel time to work by Race for PUMS {pums_span}-year data for {i}"))
    mean_time_race <- psrc_pums_mean(p, stat_var = "times", group_vars = "race") |> 
      filter(race != "Total") %>% 
      select(geography = "COUNTY", grouping = "race", date = "DATA_YEAR", estimate = ends_with("mean"), moe = ends_with("moe")) |>
      mutate(metric = "Mean Commute Time",
             date = lubridate::ymd(paste0(date, "-12-01")),
             year = as.character(lubridate::year(date)),
             geography_type = "Race",
             variable = "travel time to work") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "moe")
    
    print(str_glue("Calculating travel time buckets by county for PUMS {pums_span}-year data for {i}"))
    time_bins_county <- psrc_pums_count(p, group_vars = c("COUNTY", "travel_time_bins"), incl_na = FALSE) |>
      filter(COUNTY != "Region") |> 
      transmute(geography = COUNTY,
                geography_type = "County",
                variable = travel_time_bins,
                metric = "Travel Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating travel time buckets by Region for PUMS {pums_span}-year data for {i}"))
    time_bins_region <- psrc_pums_count(p, group_vars = c("travel_time_bins"), incl_na = FALSE) |>
      transmute(geography = COUNTY,
                geography_type = "Region",
                variable = travel_time_bins,
                metric = "Travel Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating travel time buckets by Race for PUMS {pums_span}-year data for {i}"))
    time_bins_race <- psrc_pums_count(p, group_vars = c("race", "travel_time_bins"), incl_na = FALSE) |>
      filter(race != "Total") |>
      transmute(geography = COUNTY,
                geography_type = "Race",
                variable = travel_time_bins,
                metric = "Travel Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = race,) |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating travel modes by county for PUMS {pums_span}-year data for {i}"))
    mode_county <- psrc_pums_count(p, group_vars = c("COUNTY", "mode"),incl_na = FALSE) |>
      filter(COUNTY != "Region") |> 
      transmute(geography = COUNTY,
                geography_type = "County",
                variable = mode,
                metric = "Commute Mode",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating travel modes by Region for PUMS {pums_span}-year data for {i}"))
    mode_region <- psrc_pums_count(p, group_vars = c("mode"),incl_na = FALSE) |>
      transmute(geography = COUNTY,
                geography_type = "Region",
                variable = mode,
                metric = "Commute Mode",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating travel modes by Race for PUMS {pums_span}-year data for {i}"))
    mode_race <- psrc_pums_count(p, group_vars = c("race", "mode"),incl_na = FALSE) |>
      filter(race != "Total") |>
      transmute(geography = COUNTY,
                geography_type = "Race",
                variable = mode,
                metric = "Commute Mode",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = race) |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating departure time buckets by county for PUMS {pums_span}-year data for {i}"))
    depart_time_bins_county <- psrc_pums_count(p, group_vars = c("COUNTY", "departure_time_bins"), incl_na = FALSE) |>
     filter(COUNTY != "Region") |> 
      transmute(geography = COUNTY,
                geography_type = "County",
                variable = departure_time_bins,
                metric = "Departure Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating departure time buckets by Region for PUMS {pums_span}-year data for {i}"))
    depart_time_bins_region <- psrc_pums_count(p, group_vars = c("departure_time_bins"), incl_na = FALSE) |>
      transmute(geography = COUNTY,
                geography_type = "Region",
                variable = departure_time_bins,
                metric = "Departure Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = "All") |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    print(str_glue("Calculating departure time buckets by Race for PUMS {pums_span}-year data for {i}"))
    depart_time_bins_race <- psrc_pums_count(p, group_vars = c("race", "departure_time_bins"), incl_na = FALSE) |>
      filter(race != "Total") |>
      transmute(geography = COUNTY,
                geography_type = "Race",
                variable = departure_time_bins,
                metric = "Departure Time Bins",
                date = lubridate::ymd(paste0(DATA_YEAR, "-12-01")),
                year = as.character(lubridate::year(date)),
                estimate = count,
                moe = count_moe,
                share = share,
                grouping = race,) |>
      filter(variable != "Total") |>
      select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share", "moe")
    
    # Combine summarized tables
    ifelse(is.null(processed),
           processed <- bind_rows(mean_time_county, mean_time_race,
                                  mode_county, mode_region, mode_race,
                                  time_bins_county, time_bins_region, time_bins_race,
                                  depart_time_bins_county, depart_time_bins_region, depart_time_bins_race),
           processed <- bind_rows(processed, 
                                  mean_time_county, mean_time_race,
                                  mode_county, mode_region, mode_race,
                                  time_bins_county, time_bins_region, time_bins_race,
                                  depart_time_bins_county, depart_time_bins_region, depart_time_bins_race))
  }
  
  print("All done.")
  return(processed)
}

process_wstc_fatal_collisions <- function(data_years=seq(2010, 2022, by = 1)) {
  
  wgs84 <- 4326
  spn <- 32148
  
  # Silence the dplyr summarize message
  options(dplyr.summarise.inform = FALSE)
  
  print("Getting City shapefile")
  city <- psrcelmer::st_read_elmergeo("cities") %>% dplyr::select(city="city_name") %>% sf::st_transform(spn)
  
  print("Getting 2010 shapefile loaded for spatial analysis of collisions prior to 2020")
  tract2010 <- psrcelmer::st_read_elmergeo("tract2010") %>% dplyr::select(tract10="geoid10") %>% sf::st_transform(spn)
  
  print("Getting 2020 shapefile loaded for spatial analysis of collisions from 2020 onward")
  tract2020 <- psrcelmer::st_read_elmergeo("tract2020") %>% dplyr::select(tract20="geoid20") %>% sf::st_transform(spn)
  
  print("Getting Regional Geography shapefile")
  regeo <- psrcelmer::st_read_elmergeo("regional_geographies") %>% dplyr::select(rgeo="class_desc") %>% sf::st_transform(spn)
  regeo <- regeo %>%
    dplyr::mutate(rgeo = stringr::str_replace_all(.data$rgeo, "CitiesTowns", "Cities & Towns")) %>%
    dplyr::mutate(rgeo = stringr::str_replace_all(.data$rgeo, "Core", "Core Cities")) %>%
    dplyr::mutate(rgeo = stringr::str_replace_all(.data$rgeo, "UU", "Urban Unincorporated")) %>%
    dplyr::mutate(rgeo = stringr::str_replace_all(.data$rgeo, "Metro", "Metropolitan Cities")) %>%
    dplyr::mutate(rgeo = stringr::str_replace_all(.data$rgeo, "HCT", "High Capacity Transit Communities"))
  
  print("Getting Regional Growth Centers shapefile")
  rgc <- psrcelmer::st_read_elmergeo("urban_centers") %>% dplyr::select(rgc="name") %>% sf::st_transform(spn)
  
  print("Getting Manufacturing and Industrial Centers shapefile")
  mic <- psrcelmer::st_read_elmergeo("micen") %>% dplyr::select(mic="mic") %>% sf::st_transform(spn)
  
  print("Getting Displacement Risk by Tract")
  displacement <- psrcelmer::st_read_elmergeo("displacement_risk") %>% dplyr::select(tract10="geoid10", "risk_score") %>% sf::st_drop_geometry()
  
  ptype_lookup <- data.frame(ptype = c(1, 2, 3,
                                       4, 5, 6, 7,
                                       8, 9, 10, 11,
                                       12, 13, 19, 88, 99),
                             person_mode = c("Motor Vehicle", "Motor Vehicle", "Motor Vehicle Not In-Transport",
                                             "Occupant of Non-Motor Vehicle", "Walking", "Biking", "Biking",
                                             "Other", "Unknown Occupant Type", "Person On/In Building", "Other",
                                             "Other", "Other", "Unknown Non-Motorist Type", "Not Reported", "Unknown"))
  
  funclass_lookup <- data.frame(funclass = c(1, 2, 3, 4,
                                             5, 6, 9, 11,
                                             12, 13, 14, 15,
                                             16, 19, 99),
                                road_class = c("Interstate", "Principal Arterial", "Minor Arterial", "Collector",
                                               "Collector", "Local Road", "Unknown", "Interstate",
                                               "Principal Arterial", "Principal Arterial", "Minor Arterial", "Collector",
                                               "Local Road", "Unknown", "Unknown"))
  
  funcsys_lookup <- data.frame(funcsystem = c(1, 2, 3, 4,
                                              5, 6, 7, 96,
                                              98, 99),
                               road_class = c("Interstate", "Principal Arterial", "Principal Arterial", "Minor Arterial",
                                              "Collector", "Collector", "Local Road", "Not in State Inventory",
                                              "Not Reported", "Unknown"))
  
  gender_lookup <- data.frame(sex = c(1, 2, 8, 9),
                              gender = c("Male", "Female", "Not Reported", "Unknown"))
  
  light_lookup <- data.frame(lightcond = c(1, 2, 3, 4,
                                           5, 6, 7, 8,
                                           9),
                             lighting = c("Daylight", "Dark - Not Lighted", "Dark - Lighted", "Dawn",
                                          "Dusk", "Dark - Lighting Unknown", "Other", "Not Reported",
                                          "Unknown"))
  
  distraction_lookup <- data.frame(distract1 = c(0,1,16,96,
                                                 3,4,5,6,
                                                 7,9,10,12,
                                                 13,14,15,17,
                                                 18,19,92,93,
                                                 97,98,99),
                                   distracted_details = c("Not Distracted", "Looked But Did Not See", "No Driver Present", "Not Reported",
                                                          "By Other Occupant", "By a Moving Object in Vehicle", "While Talking or Listening to Cellular Phone", "While Manipulating Cellular Phone",
                                                          "Adjusting Audio or Climate Controls", "While Using Other Component/Controls Integral to Vehicle", "While Using or Reaching For Device/Object Brought Into Vehicle", "Distracted by Outside Person, Object or Event",
                                                          "Eating or Drinking", "Smoking Related", "Other Cellular Phone Related", "Distraction/Inattention",
                                                          "Distraction/Careless", "Careless/Inattentive", "Distracted, Details Unknown", "Inattentive, Details Unknown",
                                                          "Lost in Thought / Day Dreaming", "Other Distraction", "Unknown if Distract"))
  
  
  # Initial processing of fatal crash data
  processed <- NULL
  for (year in data_years) {
    
    c_yr <- year - 2000
    
    suppressWarnings({
      data_file <- stringr::str_glue("X:/DSA/rtp-dashboard/WTSC/Data/person{c_yr}.xlsx")
      
      print(stringr::str_glue("Working on 20{c_yr} data processing and cleanup."))
      
      print("Downloading Fatality Data")
      
      t <- dplyr::as_tibble(readxl::read_xlsx(data_file)) %>%
        dplyr::filter(.data$county %in% c(33, 35, 53, 61) & .data$injury %in% c(4)) %>%
        dplyr::select(report_number="ptcr", date="crash_dt", time="crash_tm", 
                      "lightcond", "distract1", "year", urban_rural = "urbrur",
                      county = "co_char", injuries="numfatal", 
                      "race_me", "ptype", lon="x", lat="y", "age", "sex", tidyselect::starts_with("func")) %>%
        dplyr::mutate(race = dplyr::case_when(
          stringr::str_detect(.data$race_me,"White") ~ "white",
          stringr::str_detect(.data$race_me,"Black") ~ "Black or African American",
          stringr::str_detect(.data$race_me,"AIAN") ~ "American Indian and Alaska Native",
          stringr::str_detect(.data$race_me,"API") ~ "Asian and Pacific Islander",
          stringr::str_detect(.data$race_me,"Unknown") ~ "Some other race",
          stringr::str_detect(.data$race_me,"Other") ~ "Some other race",
          stringr::str_detect(.data$race_me,"Oth/Unk ") ~ "Some other race",
          stringr::str_detect(.data$race_me,"Multiracial") ~ "Two or more races",
          stringr::str_detect(.data$race_me,"Hispanic") ~ "Hispanic or Latinx")) %>%
        dplyr::select(-"race_me") %>%
        dplyr::mutate(poc = dplyr::case_when(
          .data$race == "white" ~ "white",
          .data$race != "white" ~ "People of Color")) %>%
        dplyr::mutate(year = lubridate::year(date)) %>%
        dplyr::mutate(day_of_week = lubridate::wday(.data$date, label = TRUE)) %>%
        dplyr::mutate(hour = lubridate::hour(.data$time)) %>%
        dplyr::mutate(time_of_day = dplyr::case_when(
          .data$hour %in% c(22,23,0,1,2,3,4,5) ~ "Overnight",
          .data$hour %in% c(6,7,8) ~ "AM Peak",
          .data$hour %in% c(9,10,11,12,13,14) ~ "Midday",
          .data$hour %in% c(15,16,17) ~ "PM Peak",
          .data$hour %in% c(18,19,20,21) ~ "Evening")) %>%
        dplyr::select(-"time", -"hour") %>%
        dplyr::mutate(age_group = dplyr::case_when(
          .data$age <18 ~ "0 to 18",
          .data$age <30 ~ "18 to 29",
          .data$age <40 ~ "30 to 39",
          .data$age <50 ~ "40 to 49",
          .data$age <65 ~ "50 to 64",
          .data$age <=120 ~ "65+",
          .data$age >120 ~ "Unknown")) %>%
        dplyr::select(-"age") %>%
        dplyr::mutate(distracted = dplyr::case_when(
          .data$distract1 ==0 ~ "No",
          .data$distract1 !=96 ~ "Yes",
          .data$distract1 ==96 ~ "Unknown")) %>%
        dplyr::mutate(urban_rural = dplyr::case_when(
          .data$urban_rural == "U" ~ "Urban",
          .data$urban_rural == "R" ~ "Rural")) |>
        tidyr::drop_na()
      
      print("Cleaning up Person Type")
      t <- dplyr::left_join(t, ptype_lookup, by = c("ptype" = "ptype")) %>% dplyr::select(-"ptype")
      
      print("Cleaning up Gender")
      t <- dplyr::left_join(t, gender_lookup, by = c("sex" = "sex")) %>% dplyr::select(-"sex")
      
      print("Cleaning up Light Level")
      t <- dplyr::left_join(t, light_lookup, by = c("lightcond" = "lightcond")) %>% dplyr::select(-"lightcond")
      
      print("Cleaning up Distraction")
      t <- dplyr::left_join(t, distraction_lookup, by = c("distract1" = "distract1"))%>% dplyr::select(-"distract1")
      
      print("Cleaning up Functional Classification")
      ifelse(t$year < 2015,
             t <- dplyr::left_join(t, funclass_lookup, by = c("funclass" = "funclass")) %>% dplyr::select(-"funclass"),
             t <- dplyr::left_join(t, funcsys_lookup, by = c("funcsystem" = "funcsystem")) %>% dplyr::select(-"funcsystem"))
      
      if(is.null(processed)) {processed<-t} else {processed<-dplyr::bind_rows(processed,t)}
      
    }) # end of warning suppression
    
  } # end of year loop
  
  processed <- processed %>% tibble::rowid_to_column("index")
  
  print("Creating a spatial layer for collisions to join with and buffering 100ft")
  collision_layer <- sf::st_as_sf(processed, coords = c("lon", "lat"), crs = wgs84) %>%
    sf::st_transform(spn) %>%
    dplyr::select("index") %>%
    sf::st_buffer(dist=100)
  
  print("Getting City name onto collisions")
  temp <- sf::st_intersection(collision_layer, city) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(city = tidyr::replace_na(.data$city, "Unincorporated"))
  
  print("Getting Regional Geographies onto collisions")
  temp <- sf::st_intersection(collision_layer, regeo) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(rgeo = tidyr::replace_na(.data$rgeo, "Rural"))
  
  print("Getting Regional Centers onto collisions")
  temp <- sf::st_intersection(collision_layer, rgc) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(rgc = tidyr::replace_na(.data$rgc, "Not in a RGC"))
  
  print("Getting Manufacturing and Industrial Centers onto collisions")
  temp <- sf::st_intersection(collision_layer, mic) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(mic = tidyr::replace_na(.data$mic, "Not in a MIC"))
  
  print("Getting 2010 Census Tracts onto collisions")
  temp <- sf::st_intersection(collision_layer, tract2010) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(tract10 = tidyr::replace_na(.data$tract10, "0"))
  
  print("Getting 2020 Census Tracts onto collisions")
  temp <- sf::st_intersection(collision_layer, tract2020) %>% sf::st_drop_geometry() %>% dplyr::distinct(.data$index, .keep_all = TRUE)
  processed <- dplyr::left_join(processed, temp, by="index") %>% dplyr::mutate(tract20 = tidyr::replace_na(.data$tract20, "0"))
  
  print("Getting Displacement Risk Score onto collisions")
  processed <- dplyr::left_join(processed, displacement, by="tract10") %>% dplyr::mutate(risk_score = tidyr::replace_na(.data$risk_score, 0))
  
  print("Getting HDC flag onto collisions")
  temp <- readr::read_csv("X:/DSA/shiny-uploads/data/RAISE_Persistent_Poverty.csv") %>%
    dplyr::filter(.data$State=="Washington" & .data$County %in% c("King","Kitsap", "Pierce", "Snohomish"))
  
  pop <- tidycensus::get_acs(geography = "tract", state="WA", county=c("King County","Kitsap County", "Pierce County", "Snohomish County"), variables = c("B01001_001"), year = 2019, survey = "acs5") %>%
    tidyr::separate(col=.data$NAME, sep=", ", into=c("Tract", "County", "State")) %>%
    dplyr::mutate(County = gsub(" County","",.data$County)) %>%
    dplyr::rename(population="estimate") %>%
    dplyr::select(-"variable", -"moe")
  
  temp <- dplyr::left_join(temp, pop, by=c("State","County","Tract")) %>%
    dplyr::select(tract10="GEOID", hdc="HDC_TRACT")
  
  processed <- dplyr::left_join(processed, temp, by="tract10") %>% dplyr::mutate(hdc = tidyr::replace_na(.data$hdc, "No"))
  
  print("Final Cleanup")
  processed <- processed %>%
    dplyr::mutate(injury_type="Traffic Related Deaths", injuries=1) %>%
    dplyr::rename(roadway="road_class") %>%
    dplyr::select(-"date", -"distracted_details")
  
  return(processed)
  
}

process_wsdot_serious_injury_collisions <- function(data_file=NULL) {
  
  # Coordinate Systems for Spatial Data Analysis
  wgs84 <- 4326
  spn <- 32148
  
  # Silence the dplyr summarize message
  options(dplyr.summarise.inform = FALSE)
  
  if (is.null(data_file)) {
    
    file_path <- paste0(rtp_dashboard_process_url, "/wsdot/raw/")
    
    print("Reading data files. This process can take up to 20 minutes depending on network speed so please be patient.")
    
    processed <- NULL
    for (file in list.files(path = file_path, pattern = ".*.csv")) {
      print((paste0(file_path, file)))
      t <- as_tibble(fread(paste0(file_path, file), skip = 1)) |>
        filter(`Total Serious Injuries` > 0 & str_detect(`Injury Type`,"Serious")) |>
        transmute(report_number = `Collision Report Number`,
                  lat = Latitude,
                  lon = Longitude,
                  county = `County Name`,
                  city = ifelse(`City Name` == "", "Unincorporated", `City Name`),
                  inc_date = mdy(gsub(" 0:00", "", Date)),
                  inc_time = `Full Time 24`,
                  injury_type = `Injury Type`,
                  fatalities = `Number of Fatalities`,
                  serious_injuries = `Total Serious Injuries`,
                  evident_injuries = `Total Evident Injuries`,
                  possible_injuries = `Total Possible Injuries`,
                  total_injuries = `Total Number of Injuries`,
                  num_bike = `Number of Pedal Cyclists Involved`,
                  num_ped = `Number of Pedestrians Involved`,
                  num_veh = `Number of Vehicles Involved`,
                  roadway = `Collision Report Type`,
                  junction = `Junction Relationship`,
                  weather = Weather,
                  surface = `Roadway Surface Condition`,
                  lighting = `Lighting Condition`,
                  unit_type = `Unit Type Description`,
                  person_type = `Involved Person Type`,
                  vehicle_type = `Vehicle Type`,
                  age = Age,
                  gender = Gender,
                  state_fc = `State Route Federal Functional Class Name`,
                  county_fc = `County_Federal Functional Class Name`,
                  distracted = `Distracted Involved Person Flag`) |>
        mutate(fc = case_when(
          state_fc != "" ~ state_fc,
          county_fc != "" ~ county_fc,
          state_fc == "" & county_fc =="" ~ roadway))
      
      # Combine summarized tables
      ifelse(is.null(processed),
             processed <- t,
             processed <- dplyr::bind_rows(processed, t))
    } # end of file loop
    
  } else {
    
    print("Loading the pre-processed Serious Injury Collision Data from disk")
    processed <- read_csv(data_file)
    
  }
  
  print("Cleaning up Collision data to match formate for Fatal Collisions")
  injuries <- processed |>
    mutate(inc_time = lubridate::hm(inc_time)) |>
    mutate(hour = lubridate::hour(inc_time)) |>
    mutate(time_of_day = case_when(
      hour %in% c(22,23,0,1,2,3,4,5) ~ "Overnight",
      hour %in% c(6,7,8) ~ "AM Peak",
      hour %in% c(9,10,11,12,13,14) ~ "Midday",
      hour %in% c(15,16,17) ~ "PM Peak",
      hour %in% c(18,19,20,21) ~ "Evening")) |>
    select(-"inc_time", -"hour") |>
    mutate(age_group = case_when(
      age <18 ~ "0 to 18",
      age <30 ~ "18 to 29",
      age <40 ~ "30 to 39",
      age <50 ~ "40 to 49",
      age <65 ~ "50 to 64",
      age <=120 ~ "65+",
      is.na(age) ~ "Unknown"))|>
    select(-"age") |>
    mutate(year = year(inc_date)) |>
    mutate(day_of_week = lubridate::wday(inc_date, label = TRUE)) |>
    mutate(person_mode = case_when(
      unit_type =="Motor Vehicle" ~ "Motor Vehicle",
      unit_type =="Pedestrian" ~ "Walking",
      unit_type == "Pedalcyclist" ~ "Biking")) |>
    select(-"unit_type", -"person_type", -"vehicle_type") |>
    mutate(injury_type="Serious Injury", injuries=1) |>
    select(-"city", -"inc_date", -"fatalities", -"serious_injuries", -"evident_injuries", -"possible_injuries", -"total_injuries",-"num_bike",-"num_ped", -"num_veh", -"junction", -"weather", -"surface", -"state_fc", -"county_fc") |>
    drop_na(lat) |>
    drop_na(lon) |>
    rowid_to_column("index")
  
  print("Getting City shapefile")
  city <- st_read_elmergeo("cities") |>
    select(city="city_name") |>
    st_transform(spn)
  
  print("Getting 2010 shapefile loaded for spatial analysis of collisions prior to 2020")
  tract2010 <- st_read_elmergeo("tract2010") |>
    select(tract10="geoid10") |>
    st_transform(spn)
  
  print("Getting 2020 shapefile loaded for spatial analysis of collisions from 2020 onward")
  tract2020 <- st_read_elmergeo("tract2020") |>
    select(tract20="geoid20") |>
    st_transform(spn)
  
  print("Getting Regional Geography shapefile")
  regeo <- st_read_elmergeo("regional_geographies") |>
    select(rgeo="class_desc") |>
    st_transform(spn)
  
  regeo <- regeo |>
    mutate(rgeo = str_replace_all(rgeo, "CitiesTowns", "Cities & Towns")) |>
    mutate(rgeo = str_replace_all(rgeo, "Core", "Core Cities")) |>
    mutate(rgeo = str_replace_all(rgeo, "UU", "Urban Unincorporated")) |>
    mutate(rgeo = str_replace_all(rgeo, "Metro", "Metropolitan Cities")) |>
    mutate(rgeo = str_replace_all(rgeo, "HCT", "High Capacity Transit Communities"))
  
  print("Getting Regional Growth Centers shapefile")
  rgc <- st_read_elmergeo("urban_centers")|>
    select(rgc="name") |>
    st_transform(spn)
  
  print("Getting Manufacturing and Industrial Centers shapefile")
  mic <- st_read_elmergeo("micen") |>
    select(mic="mic") |>
    st_transform(spn)
  
  print("Creating a spatial layer for collisions to join with and buffering 100ft")
  collision_layer <- st_as_sf(injuries, coords = c("lon", "lat"), crs = wgs84) |>
    st_transform(spn) |>
    select("index") |>
    st_buffer(dist=100)
  
  print("Getting City name onto collisions")
  temp <- st_intersection(collision_layer, city) |>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index")|>
    mutate(city = replace_na(city, "Unincorporated"))
  
  print("Getting Regional Geographies onto collisions")
  temp <- st_intersection(collision_layer, regeo) |>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index") |>
    mutate(rgeo = replace_na(rgeo, "Rural"))
  
  print("Getting Regional Centers onto collisions")
  temp <- st_intersection(collision_layer, rgc) |>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index")|>
    mutate(rgc = replace_na(rgc, "Not in a RGC"))
  
  print("Getting Manufacturing and Industrial Centers onto collisions")
  temp <- st_intersection(collision_layer, mic)|>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index") |>
    mutate(mic = replace_na(mic, "Not in a MIC"))
  
  print("Getting 2010 Census Tracts onto collisions")
  temp <- st_intersection(collision_layer, tract2010)|>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index") |>
    mutate(tract10 = replace_na(tract10, "0"))
  
  print("Getting 2020 Census Tracts onto collisions")
  temp <- st_intersection(collision_layer, tract2020) |>
    st_drop_geometry() |>
    distinct(index, .keep_all = TRUE)
  
  injuries <- left_join(injuries, temp, by="index") |>
    mutate(tract20 = replace_na(tract20, "0"))
  
  print("Getting Displacement Risk Score onto collisions")
  temp <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Displacement_Risk_Data/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") |>
    st_drop_geometry() |>
    select(tract10="geoid10", "risk_score")
  
  injuries <- left_join(injuries, temp, by="tract10") |>
    mutate(risk_score = replace_na(risk_score, 0))
  
  print("Getting HDC flag onto collisions")
  temp <- read_csv("X:/DSA/shiny-uploads/data/RAISE_Persistent_Poverty.csv") |>
    filter(State=="Washington" & County %in% c("King","Kitsap", "Pierce", "Snohomish"))
  
  pop <- get_acs(geography = "tract", state="WA", county=c("King County","Kitsap County", "Pierce County", "Snohomish County"), variables = c("B01001_001"), year = 2019, survey = "acs5") |>
    separate(col=NAME, sep=", ", into=c("Tract", "County", "State")) |>
    mutate(County = gsub(" County","", County)) |>
    rename(population="estimate") |>
    select(-"variable", -"moe")
  
  temp <- left_join(temp, pop, by=c("State","County","Tract")) |>
    select(tract10="GEOID", hdc="HDC_TRACT")
  
  injuries <- left_join(injuries, temp, by="tract10") |>
    mutate(hdc = replace_na(hdc, "No"))
  
  return(injuries)
  
}

process_fars_data<- function(safety_yrs=c(seq(2010,2023,by=1))) {
  
  # Figure of which counties are in each MPO
  mpo_file <- system.file('extdata', 'regional-councils-counties.csv', package='psrcrtp')
  
  mpo <- readr::read_csv(mpo_file, show_col_types = FALSE) |> 
    dplyr::mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY_FIPS, width=3, side=c("left"), pad="0")) |>
    dplyr::mutate(STATE_FIPS=stringr::str_pad(.data$STATE_FIPS, width=2, side=c("left"), pad="0")) |>
    dplyr::mutate(GEOID = paste0(.data$STATE_FIPS,.data$COUNTY_FIPS))
  
  states <- mpo |> dplyr::select("STATE_FIPS") |> dplyr::distinct() |> dplyr::pull()
  counties <- mpo |> dplyr::select("GEOID") |> dplyr::distinct() |> dplyr::pull()
  
  # Get Population Data from ACS using TidyCensus
  mpo_county_data <- NULL
  for(yr in safety_yrs) {
    print(paste0("Working of population data for ",yr))
    
    for (st in states) {
      
      c <- mpo |> dplyr::filter(.data$STATE_FIPS %in% st) |> dplyr::select("COUNTY_FIPS") |> dplyr::pull()
      
      pop <- tidycensus::get_acs(geography = "county", state=st, county=c, variables = c("B03002_001"), year = yr, survey = "acs5") |> 
        dplyr::select(-"moe") |> 
        dplyr::mutate(data_year=yr, variable="Population") |>
        dplyr::select(-"NAME")
      
      ifelse(is.null(mpo_county_data), mpo_county_data <- pop, mpo_county_data <- dplyr::bind_rows(mpo_county_data,pop))
      
      rm(c, pop)
    }
  }
  
  mpo_county_data <- dplyr::left_join(mpo, mpo_county_data, by="GEOID")
  
  pop_data <- mpo_county_data |>
    dplyr::select("MPO_AREA", "variable", "estimate", "data_year") |>
    dplyr::rename(geography="MPO_AREA") |>
    dplyr::group_by(.data$geography, .data$variable, .data$data_year) |>
    dplyr::summarise(estimate=sum(.data$estimate)) |>
    tidyr::as_tibble() |>
    dplyr::mutate(metric="Population", geography_type="Metro Regions", grouping="All", variable="Total")
  
  # Fatality Data
  collision_data <- NULL
  for (y in safety_yrs) {
    
    # Open Current Years FARS Accident Data
    
    all_files <- as.character(utils::unzip(paste0("X:/DSA/rtp-dashboard/FARS/FARS",y,"NationalCSV.zip"), list = TRUE)$Name)
    
    if(y < 2022) {
      
      print(paste0("Working of FARS Fatalities data for ",y))
      f <- readr::read_csv(unz(paste0("X:/DSA/rtp-dashboard/FARS/FARS",y,"NationalCSV.zip"), all_files[1]), show_col_types = FALSE) |>
        dplyr::mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY, width=3, side=c("left"), pad="0")) |>
        dplyr::mutate(STATE_FIPS=stringr::str_pad(.data$STATE, width=2, side=c("left"), pad="0")) |>
        dplyr::mutate(GEOID = paste0(.data$STATE_FIPS, .data$COUNTY_FIPS)) |>
        dplyr::filter(.data$GEOID %in% counties) |>
        dplyr::select("GEOID", "FATALS") |>
        dplyr::group_by(.data$GEOID) |>
        dplyr::summarise(estimate=sum(.data$FATALS)) |>
        tidyr::as_tibble() |>
        dplyr::mutate(data_year=y, variable="Total")
      
      ifelse(is.null(collision_data), collision_data <- f, collision_data <- dplyr::bind_rows(collision_data,f))
      
      rm(f) 
      
    } else {
      
      print(paste0("Working of FARS Fatalities data for ",y))
      f <- readr::read_csv(unz(paste0("X:/DSA/rtp-dashboard/FARS/FARS",y,"NationalCSV.zip"), all_files[2]), show_col_types = FALSE) |>
        dplyr::mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY, width=3, side=c("left"), pad="0")) |>
        dplyr::mutate(STATE_FIPS=stringr::str_pad(.data$STATE, width=2, side=c("left"), pad="0")) |>
        dplyr::mutate(GEOID = paste0(.data$STATE_FIPS, .data$COUNTY_FIPS)) |>
        dplyr::filter(.data$GEOID %in% counties) |>
        dplyr::select("GEOID", "FATALS") |>
        dplyr::group_by(.data$GEOID) |>
        dplyr::summarise(estimate=sum(.data$FATALS)) |>
        tidyr::as_tibble() |>
        dplyr::mutate(data_year=y, variable="Total")
      
      ifelse(is.null(collision_data), collision_data <- f, collision_data <- dplyr::bind_rows(collision_data,f))
      
      rm(f)  
      
    }
    
  }
  
  # Annual Fatality Data
  mpo_county_data <- dplyr::left_join(mpo, collision_data, by="GEOID")
  
  fatality_data <- mpo_county_data |>
    dplyr::select("MPO_AREA", "variable", "estimate", "data_year") |>
    dplyr::rename(geography="MPO_AREA") |>
    dplyr::group_by(.data$geography, .data$variable, .data$data_year) |>
    dplyr::summarise(estimate=sum(.data$estimate)) |>
    tidyr::as_tibble() |>
    dplyr::mutate(metric="Traffic Related Deaths", geography_type="Metro Regions", grouping="All") |>
    tidyr::drop_na()
  
  # Calculate Per Capita Rates
  p <- pop_data |>
    dplyr::select("geography", "data_year", "estimate") |> 
    dplyr::rename(population="estimate")
  
  rate_data <- dplyr::left_join(fatality_data, p, by=c("geography","data_year")) |>
    dplyr::mutate(estimate=(.data$estimate/.data$population)*100000, variable="Rate per 100k people") |>
    dplyr::select(-"population")
  
  fars_data <- dplyr::bind_rows(fatality_data, rate_data) |>
    dplyr::mutate(date=lubridate::ymd(paste0(.data$data_year,"-12-01"))) |>
    dplyr::select(-"data_year")
  
  return(fars_data)
}

summarise_collision_data_dashboard <- function(data_file) {
  
  collision_data <- data_file
  
  #########################################################################
  # Population Data by Year for Rate Calculations
  #########################################################################
  latest_census_year <- lubridate::year(Sys.Date())-2
  population_years <- seq(min(unique(collision_data$year)), latest_census_year, by=1)
  
  population <- NULL
  for (y in population_years) {
    
    # Age, Gender and Total Population is in Table B01001
    print(str_glue("Getting County & Region Population for {y}"))
    d <- get_acs_recs(geography = 'county', table.names = "B01001", years=y, acs.type = 'acs5')
    
    # County and Region
    c <-  d |>
      filter(variable ==  "B01001_001") |>
      mutate(date=lubridate::mdy(paste0("12-01-",year)))|>
      select("date", geography="name", population="estimate") |>
      mutate(geography = str_remove_all(geography, " County"), grouping = "All")
    
    # Gender
    print(str_glue("Getting Population by Gender for {y}"))
    g <- d |>
      filter(variable %in% c("B01001_002", "B01001_026") & name == "Region") |>
      mutate(grouping = case_when(
        variable ==  "B01001_002" ~ "Male",
        variable ==  "B01001_026" ~ "Female")) |> 
      mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
      select("date", geography="name", "grouping", population="estimate")
    
    # Age
    print(str_glue("Getting Population by Age for {y}"))
    a <- d |>
      filter(!(variable %in% c("B01001_001", "B01001_002", "B01001_026"))) |>
      filter(name == "Region") |>
      mutate(grouping = case_when(
        variable %in% c("B01001_003","B01001_004","B01001_005","B01001_006") ~ "0 to 18",
        variable %in% c("B01001_027","B01001_028","B01001_029","B01001_030") ~ "0 to 18",
        variable %in% c("B01001_007","B01001_008","B01001_009","B01001_010","B01001_011") ~ "18 to 29",
        variable %in% c("B01001_031","B01001_032","B01001_033","B01001_034","B01001_035") ~ "18 to 29",
        variable %in% c("B01001_012","B01001_013") ~ "30 to 39",
        variable %in% c("B01001_036","B01001_037") ~ "30 to 39",
        variable %in% c("B01001_014","B01001_015") ~ "40 to 49",
        variable %in% c("B01001_038","B01001_039") ~ "40 to 49",
        variable %in% c("B01001_016","B01001_017","B01001_018","B01001_019") ~ "50 to 64",
        variable %in% c("B01001_040","B01001_041","B01001_042","B01001_043") ~ "50 to 64",
        variable %in% c("B01001_020","B01001_021","B01001_022","B01001_023","B01001_024","B01001_025") ~ "65+",
        variable %in% c("B01001_044","B01001_045","B01001_046","B01001_047","B01001_048","B01001_049") ~ "65+")) |> 
      mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
      select("date", geography="name", "grouping", population="estimate") |>
      group_by(date, geography, grouping) |>
      summarise(population = sum(population)) |>
      as_tibble()
    
    # Race & Ethnicity
    print(str_glue("Getting Population by Race for {y}"))
    d <- get_acs_recs(geography = 'county', table.names = "B03002", years=y, acs.type = 'acs5')
    r <- d |>
      filter(variable %in% c("B03002_003", "B03002_004", "B03002_005", "B03002_006", "B03002_007", "B03002_008", "B03002_009", "B03002_012")) |>
      filter(name == "Region") |>
      mutate(grouping = case_when(
        variable %in% c("B03002_003") ~ "white",
        variable %in% c("B03002_004") ~ "Black or African American",
        variable %in% c("B03002_005") ~ "American Indian and Alaska Native",
        variable %in% c("B03002_006") ~ "Asian and Pacific Islander",
        variable %in% c("B03002_007") ~ "Asian and Pacific Islander",
        variable %in% c("B03002_008") ~ "Some other race",
        variable %in% c("B03002_009") ~ "Two or more races",
        variable %in% c("B03002_012") ~ "Hispanic or Latinx")) |>
      mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
      select("date", geography="name", "grouping", population="estimate") |>
      group_by(date, geography, grouping) |>
      summarise(population = sum(population)) |>
      as_tibble()
    
    # Urban & Rural
    print(str_glue("Getting Parcel Population for {y}"))
    if (y <2020) {ofm_vintage <- 2024} else {ofm_vintage <- 2024}
    parcel_yr <- 2018
    
    q <- paste0("SELECT parcel_dim_id, estimate_year, total_pop from ofm.parcelized_saep_facts WHERE ofm_vintage = ", ofm_vintage, " AND estimate_year = ", y, "")
    p <- get_query(sql = q) |> 
      rename(pop = "total_pop", year = "estimate_year")
    
    print(str_glue("Loading {y} OFM based parcel dimensions"))
    q <- paste0("SELECT parcel_dim_id, parcel_id, regional_geography_class_2022 from small_areas.parcel_dim WHERE base_year = ", parcel_yr, " ")
    d <- get_query(sql = q)
    
    print(str_glue("Joining parcel dimensions from Elmer with parcel data for {y}"))
    p <- left_join(p, d, by="parcel_dim_id")
    
    p <- p |>
      mutate(regional_geography_class_2022 = replace_na(regional_geography_class_2022, "Urban")) |>
      mutate(geography = case_when(
        regional_geography_class_2022 == "Rural" ~ "Rural",
        regional_geography_class_2022 != "Rural" ~ "Urban")) |>
      group_by(geography) |>
      summarise(population = sum(pop)) |>
      as_tibble() |>
      mutate(date=lubridate::mdy(paste0("12-01-",y)), grouping = "Urban or Rural") |>
      select("date", "geography", "grouping", "population")
    
    t <- bind_rows(c,g,a,r,p)
    if(is.null(population)) {population <- t} else {population <- bind_rows(population, t)}
    rm(c,g,a,r,t,d,p,q)
  }

  #########################################################################
  # Collision Data by Year
  #########################################################################
  
  # Create Regional Summary by Year
  region <- collision_data |>
    select("year", "injury_type", "injuries") |>
    group_by(year, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography="Region", geography_type="Region", grouping="All", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create County Summary by Year
  county <- collision_data |>
    select("year", "county", "injury_type", "injuries") |>
    group_by(year, county, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", geography = "county") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="County", grouping="All", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Urban/Rural Summary by Year
  urban_rural <- collision_data |>
    select("year", "rgeo", "injury_type", "injuries") |>
    mutate(urban_or_rural = case_when(
      rgeo == "Rural" ~ "Rural",
      rgeo != "Rural" ~ "Urban")) |>
    group_by(year, urban_or_rural, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", geography = "urban_or_rural") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Urban or Rural", grouping="Urban or Rural", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Race & Ethnicity Summary by Year
  race <- collision_data |>
    select("year", "race", "injury_type", "injuries") |>
    group_by(year, race, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "race") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Race", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate") |>
    filter(metric == "Traffic Related Deaths")
  
  # Create Age Group Summary by Year
  age <- collision_data |>
    select("year", "age_group", "injury_type", "injuries") |>
    group_by(year, age_group, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "age_group") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Age Group", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Gender Summary by Year
  gender <- collision_data |>
    select("year", "gender", "injury_type", "injuries") |>
    mutate(gender = replace_na(gender, "Not Reported")) |>
    group_by(year, gender, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "gender") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Gender", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Person Mode Summary by Year
  mode <- collision_data |>
    select("year", "person_mode", "injury_type", "injuries") |>
    mutate(person_mode = case_when(
      person_mode %in% c("Biking", "Motor Vehicle", "Walking") ~ person_mode,
      !(person_mode %in% c("Biking", "Motor Vehicle", "Walking")) ~ "Other")) |>
    group_by(year, person_mode, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "person_mode") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Mode", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Day of Week Summary by Year
  dow <- collision_data |>
    select("year", "day_of_week", "injury_type", "injuries") |>
    group_by(year, day_of_week, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "day_of_week") |>
    mutate(date=lubridate::mdy(paste0("12-01-", year))) |>
    mutate(geography_type="Day of Week", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Time of Day Summary by Year
  tod <- collision_data |>
    select("year", "time_of_day", "injury_type", "injuries") |>
    group_by(year, time_of_day, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "time_of_day") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Time of Day", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create Roadway Summary by Year
  roadway <- collision_data |>
    select("year", "roadway", "injury_type", "injuries") |>
    group_by(year, roadway, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "roadway") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Roadway Type", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  # Create HDC Summary by Year
  hdc <- collision_data |>
    select("year", "hdc", "injury_type", "injuries") |>
    group_by(year, hdc, injury_type) |>
    summarise(estimate = sum(injuries)) |>
    as_tibble() |>
    rename(metric = "injury_type", grouping = "hdc") |>
    mutate(date=lubridate::mdy(paste0("12-01-",year))) |>
    mutate(geography_type="Historically Disadvantaged Community", geography="Region", variable="Total") |>
    select("date", "geography", "variable", "geography_type", "grouping", "metric", "estimate")
  
  collisions <- bind_rows(region, county, urban_rural, race, age, gender, mode, dow, tod, roadway, hdc)
  rm(region, county, urban_rural, race, age, gender, mode, dow, tod, roadway, hdc)
  
  #########################################################################
  # Collision Rates by Year
  #########################################################################
  
  rates <- left_join(collisions, population, by=c("date", "geography", "grouping")) |>
    mutate(rate = estimate / (population/100000)) |>
    mutate(variable = "Rate per 100k people") |>
    select(-"population", -"estimate") |>
    rename(estimate = "rate")
  
  final <- bind_rows(collisions, rates)
  return(final)
}

summarize_npmrds_data <- function(file_path) {

  # Weekdays
  processed <- NULL
  for (file in list.files(path = file_path, pattern = ".*_weekdays.csv")) {
    d <- str_remove_all(file, paste0("_cars_tmc_95th_percentile_speed_weekdays.csv"))
    
    print(str_glue("Opening travel time data for weekdays in {d}"))
    
    t <- read_csv(paste0(file_path, file), show_col_types = FALSE) |> 
      mutate(date=d) |>
      mutate(lane_miles = miles * thrulanes_unidir) |>
      separate(col=date, into = c("date","year")) |>
      mutate(year = as.character(year)) |>
      mutate(date = lubridate::mdy(paste0(date,"-01-",year))) |>
      filter(!(is.na(f_system))) |>
      mutate(geography_type = "Weekday")
    
    ifelse(is.null(processed), processed <- t, processed <- bind_rows(processed, t))
    rm(t)
    
  }
  
  # Weekdend
  for (file in list.files(path = file_path, pattern = ".*_weekends.csv")) {
    d <- str_remove_all(file, paste0("_cars_tmc_95th_percentile_speed_weekends.csv"))
    
    print(str_glue("Opening travel time data for weekends in {d}"))
    
    t <- read_csv(paste0(file_path, file), show_col_types = FALSE) |> 
      mutate(date=d) |>
      mutate(lane_miles = miles * thrulanes_unidir) |>
      separate(col=date, into = c("date","year")) |>
      mutate(year = as.character(year)) |>
      mutate(date = lubridate::mdy(paste0(date,"-01-",year))) |>
      filter(!(is.na(f_system))) |>
      mutate(geography_type = "Weekend")
    
    ifelse(is.null(processed), processed <- t, processed <- bind_rows(processed, t))
    rm(t)
    
  }
  
  m <- "county" 
  
  print(str_glue("Summarizing Travel Time Data by {m}"))
  c <- processed |>
    select("Tmc", all_of(m), "lane_miles", contains("ratio"), "date", "year", "geography_type") |>
    pivot_longer(cols = contains("ratio")) |>
    mutate(name = str_remove_all(name, "_ratio")) |>
    mutate(geography = str_to_title(county), variable = name) |>
    mutate(grouping = case_when(
      value < 0.25 ~ "Severe",
      value < 0.50 ~ "Heavy",
      value < 0.75 ~ "Moderate",
      value >= 0.75 ~ "Minimal")) |>
    drop_na() |>
    group_by(geography, date, year, geography_type, variable, grouping) |>
    summarise(congested = sum(lane_miles)) |>
    as_tibble() |>
    filter(geography != "Chelan")
  
  t <- processed |>
    mutate(geography = str_to_title(county)) |>
    group_by(geography, date, year, geography_type) |>
    summarise(total = sum(lane_miles)) |>
    as_tibble() |>
    filter(geography != "Chelan")
  
  c <- left_join(c,t, by=c("geography", "date", "year", "geography_type")) |>
    group_by(geography, date, year, geography_type, variable, grouping) |>
    summarise(estimate = sum(congested), total = sum(total)) |>
    as_tibble() |>
    mutate(metric = "Congested Lane-Miles")
  
  r <- c |>
    group_by(date, year, geography_type, variable, grouping) |>
    summarise(estimate = sum(estimate), total  =sum(total)) |>
    as_tibble() |>
    mutate(metric = "Congested Lane-Miles", geography="Region")
  
  c <- bind_rows(c, r) |>
    mutate(share = estimate / total) |> 
    select(-"total") |>
    select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", "estimate", "share")
  
  return(c)
  
}

create_npmrds_map_data <- function(file_path, data_mo, data_yr) {
  
  wgs84 <- 4326
  shape_path = "C:/Users/chelmann/Puget Sound Regional Council/2026-2050 RTP Trends - General/Congestion/shapefiles/"
  wd <- paste0(data_mo, "_", data_yr, "_cars_tmc_95th_percentile_speed_weekdays.csv")
  we <- paste0(data_mo, "_", data_yr, "_cars_tmc_95th_percentile_speed_weekends.csv")
  
  # Shapefile for data_yr
  print(str_glue("Opening {data_yr} travel time shapefile"))
  tmc <- st_read(paste0(shape_path, data_yr, "/Washington.shp")) |>
    select("Tmc", roadway="RoadName", geography="County") |>
    filter(geography %in% c("KING", "KITSAP","PIERCE", "SNOHOMISH")) |>
    mutate(geography = str_to_title(geography)) |>
    st_transform(wgs84) |>
    drop_na()
  
  # Weekday Data
  print(str_glue("Opening travel time data for weekdays in {data_mo} of {data_yr}"))
  
  t <- read_csv(paste0(file_path, wd), show_col_types = FALSE) |> 
    mutate(date = lubridate::mdy(paste0(data_mo, "-01-", data_yr))) |>
    mutate(lane_miles = miles * thrulanes_unidir) |>
    mutate(year = data_yr) |>
    filter(!(is.na(f_system))) |>
    select("Tmc", "date", "year", am_peak="AM Peak_ratio", midday="Midday_ratio", pm_peak="PM Peak_ratio") |>
    mutate("geography_type" = "Weekday") |>
    drop_na()
    
  print(str_glue("Joining speed data to shapefile for weekdays in {data_mo} of {data_yr}"))
  p1 <- left_join(tmc, t, by="Tmc") |> 
    drop_na()
  
  # Weekend Data
  print(str_glue("Opening travel time data for weekends in {data_mo} of {data_yr}"))
  
  t <- read_csv(paste0(file_path, we), show_col_types = FALSE) |> 
    mutate(date = lubridate::mdy(paste0(data_mo, "-01-", data_yr))) |>
    mutate(lane_miles = miles * thrulanes_unidir) |>
    mutate(year = data_yr) |>
    filter(!(is.na(f_system))) |>
    select("Tmc", "date", "year", am_peak="AM Peak_ratio", midday="Midday_ratio", pm_peak="PM Peak_ratio") |>
    mutate("geography_type" = "Weekend") |>
    drop_na()
  
  print(str_glue("Joining speed data to shapefile for weekends in {data_mo} of {data_yr}"))
  p2 <- left_join(tmc, t, by="Tmc") |> 
    drop_na()
  
  processed <- bind_rows(p1, p2)

  return(processed)
  
}

# Vehicle Registrations ------------------------------------------------------------
vehicle_data <- process_vehicle_registration_data(dol_registration_file=here(rtp_local_url, "Vehicle_Title_Transactions.csv"))

vehicle_data <- vehicle_data |> 
  filter(variable != "Non-Powered") |> 
  filter(variable != "FCEV (Fuel Cell Electric Vehicle)") |> 
  filter(variable != "Not Applicable") |> 
  drop_na() 

region_type <- vehicle_data |>
  filter(geography_type == "Region" & metric == "vehicle-registrations") |>
  group_by(year, variable) |>
  summarise(estimate = sum(estimate)) |>
  as_tibble()

region_total <- vehicle_data |>
  filter(geography_type == "Region" & metric == "vehicle-registrations") |>
  group_by(year) |>
  summarise(total = sum(estimate)) |>
  as_tibble()

region_registrations <- left_join(region_type, region_total, by = c("year")) |>
  mutate(share = estimate / total) |>
  select(-"total") |>
  mutate(date = mdy(paste0("12-01-",year)), geography = "Region", geography_type = "Region", grouping = "New & Used", metric = "title-transactions") 

vehicle_data <- bind_rows(vehicle_data, region_registrations)
saveRDS(vehicle_data, here("data", "vehicle_data.rds"))
rm(region_type, region_total, region_registrations)

# Vehicle Registrations on Census Tracts for Mapping ----------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Census_Tracts_2020/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |> select(geography="geoid20")
registrations <- vehicle_data |> filter(geography_type == "Tract" & year == "2025" & variable == "Battery Electric Vehicle" & grouping == "New") 
tract_registrations <- left_join(tracts, registrations, by=c("geography"))
saveRDS("data", here(rtp_dashboard_url, "ev_registration_by_tract.rds"))
rm(tracts, registrations)

# VMT Data ----------------------------------------------------------------
vmt <- read_csv(here(rtp_network_url, "PSRC/vmt-data.csv"), show_col_types = FALSE) |>
  mutate(date = lubridate::mdy(date)) |>
  mutate(year = lubridate::year(date))

saveRDS(vmt, here("data", "vmt.rds"))

vkt_data <- read_csv(here(rtp_network_url, "PSRC/vkt-data.csv"), show_col_types = FALSE) |> 
  mutate(plot_id=as.character(plot_id), metric="Annual Kilometers per Capita", geography=str_wrap(geography, 15)) |> 
  rename(estimate = "vkt") |>
  arrange(estimate)

vkt_order <- vkt_data |> select("geography") |> distinct() |> pull()
vkt_data <- vkt_data |> mutate(geography = factor(x=geography, levels=vkt_order))

saveRDS(vkt_data, here("data", "vkt.rds"))

# Census Commute Data -----------------------------------------------------
acs_commute_data <- process_acs_data(data_years = acs_data_yrs)
pums_commute_data <- pums_data(pums_yr = pums_data_yrs)
commute_data <- bind_rows(acs_commute_data, pums_commute_data)

jurisdictions <- get_table(schema='Political', tbl_name='jurisdiction_dims')

jurisdictions <- jurisdictions |>
  mutate(juris_name = str_replace_all(juris_name, "Seatac", "SeaTac")) |>
  mutate(juris_name = str_replace_all(juris_name, "Beau Arts Village","Beaux Arts Village")) |>
  select("juris_name", "regional_geography") |>
  distinct() |>
  mutate(regional_geography=str_replace_all(regional_geography, "HCT", "High Capacity Transit Community")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "Metro", "Metropolitan Cities")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "Core", "Core Cities")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "CitiesTowns", "Cities & Towns")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. King", "King County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Kitsap", "Kitsap County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Pierce", "Pierce County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Snohomish", "Snohomish County")) |>
  rename(Municipality = "juris_name", `Regional Geography` = "regional_geography")

metro <- jurisdictions |> filter(`Regional Geography` == "Metropolitan Cities") |> select("Municipality") |>pull() |> unique()
core <- jurisdictions |> filter(`Regional Geography` == "Core Cities") |> select("Municipality") |>pull() |> unique()
hct <- jurisdictions |> filter(`Regional Geography` == "High Capacity Transit Community") |> select("Municipality") |>pull() |> unique()
cities <- jurisdictions |> filter(`Regional Geography` == "Cities & Towns") |> select("Municipality") |>pull() |> unique()

commute_data <- commute_data |>
  mutate(plot_id = case_when(
    geography_type %in% c("County", "Region") ~ "PSRC Region",
    geography_type == "City" & geography %in% metro ~ "Metro City",
    geography_type == "City" & geography %in% core ~ "Core City",
    geography_type == "City" & geography %in% hct ~ "HCT City",
    geography_type == "City" & geography %in% cities ~ "Cities & Towns",
    geography_type == "Metro Areas" & geography == "Seattle" ~ "PSRC",
    geography_type == "Metro Areas" & geography != "Seattle" ~ "Other MPO",
    geography_type == "Race" ~ grouping)) |>
  filter(!(is.na(geography)))

saveRDS(commute_data, here(rtp_dashboard_process_url, "commute_data.rds"))
rm(acs_commute_data, pums_commute_data, jurisdictions)

# NTD Transit Data --------------------------------------------------------
transit_data <- process_ntd_data()

forecast_data <- read_csv(here(rtp_network_url, "PSRC/rtp-transit-metrics.csv"), show_col_types = FALSE) |> mutate(date = lubridate::mdy(date)) |> mutate(year = as.character(year))

mpo_transit_pre_covid <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==pre_covid & grouping=="YTD") |> 
  rename(previous=estimate) |>
  select("geography", "metric", "previous")

mpo_transit_current <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==current_ntd_year & grouping=="YTD") |> 
  rename(current=estimate) 

mpo_transit <- left_join(mpo_transit_current, mpo_transit_pre_covid, by=c("geography", "metric")) |>
  mutate(estimate = current/previous) |>
  select(-"previous", -"current") |>
  filter(metric != "Revenue-Miles") |>
  mutate(grouping = "COVID Recovery") |>
  arrange(metric, estimate)

transit_data <- bind_rows(transit_data, forecast_data, mpo_transit) |> 
  mutate(year = as.numeric(year)) |>
  mutate(plot_id = case_when(
    geography_type == "Metro Areas" & geography == "Seattle" ~ "PSRC",
    geography_type == "Metro Areas" & geography != "Seattle" ~ "Other MPO",
    TRUE ~ "PSRC Region"))

saveRDS(transit_data, here("data", "transit_data.rds"))
rm(forecast_data, mpo_transit_pre_covid, mpo_transit_current, mpo_transit)
  
# People, Housing and Jobs ------------------------------------------------
pop <- regional_population_data() |> filter(!(variable == "Forecast" & year <2018) & grouping == "Total") |> mutate(year = as.numeric(year))
hsg <- regional_housing_data() |> filter(!(variable == "Forecast" & year <2018) & grouping == "Total") |> mutate(year = as.numeric(year))
jobs <- jobs_data() |> filter(grouping == "Total" & !(variable == "Forecast" & year <2018)) |> mutate(year = as.numeric(year))
jobs_hct <- jobs_near_hct() |> filter(grouping == "Change" & variable == "in station area") |> mutate(year = as.numeric(year))

hct_title <- "hct_station_area_vision_2050"
analysis_yrs <- seq(2010,2024, by=1)
parcel_yrs <- c(2014, 2018)
intercensal_ofm_vintage <- 2024
latest_postcensal_ofm_vintage <- 2024
parcel_base_yr <- 2018

housing_data <- NULL
for(y in analysis_yrs) {
  
  if (y <2020) {ofm_vintage <- intercensal_ofm_vintage} else {ofm_vintage <- latest_postcensal_ofm_vintage}
  parcel_yr <- parcel_base_yr
  
  # Build query for psrcelmer and get parcel data from Elmer
  print(str_glue("Loading {y} OFM based parcelized estimates of population and housing"))
  q <- paste0("SELECT parcel_dim_id, estimate_year, total_pop, housing_units from ofm.parcelized_saep_facts WHERE ofm_vintage = ", ofm_vintage, " AND estimate_year = ", y, "")
  p <- get_query(sql = q) |> 
    rename(pop = "total_pop", hu = "housing_units", year = "estimate_year")
  
  # Build query for psrcelmer and get parcel dimensions data from Elmer
  print(str_glue("Loading {y} OFM based parcel dimensions"))
  q <- paste0("SELECT parcel_dim_id, parcel_id, ", hct_title, " from small_areas.parcel_dim WHERE base_year = ", parcel_yr, " ")
  d <- get_query(sql = q) |> 
    rename(hct = all_of(hct_title)) |>
    mutate(hct = replace_na(hct, "not in station area"))
  
  # Add Dimensions to Parcels
  print(str_glue("Joining parcel dimensions from Elmer with parcel data for {y}"))
  p <- left_join(p, d, by="parcel_dim_id") |> 
    mutate(ofm_release = ofm_vintage) |>
    mutate(hct_buffer_type = hct_title)
  
  p <- p |> select("parcel_id", "hct", "pop", "hu", "year", "ofm_release", "hct_buffer_type")
  
  if(is.null(housing_data)) {housing_data <- p} else {housing_data <- bind_rows(housing_data, p)}
  rm(q, p, d)
  
}

print(str_glue("Summarize population for HCT areas by region"))
pop_hct <- housing_data |>
  group_by(year, hct) |>
  summarise(estimate = round(sum(pop), 0)) |>
  as_tibble() |>
  select("year", "hct", "estimate") |>
  pivot_wider(names_from = hct, values_from = estimate) |>
  mutate(total = `in station area` + `not in station area`) |>
  select("year", estimate = "in station area", "total") |>
  mutate(station_change = estimate - lag(estimate)) |>
  mutate(total_change = total - lag(total)) |>
  drop_na() |>
  mutate(date = mdy(paste0("04-01-",year)), 
         geography = "Region", 
         geography_type = "Region", 
         variable = "in station area",
         grouping = "Change",
         metric = "Population near HCT",
         share = station_change / total_change) |>
  select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", estimate = "station_change", "share")

print(str_glue("Summarize housing units for HCT areas by region"))
hu_hct <- housing_data |>
  group_by(year, hct) |>
  summarise(estimate = round(sum(hu), 0)) |>
  as_tibble() |>
  select("year", "hct", "estimate") |>
  pivot_wider(names_from = hct, values_from = estimate) |>
  mutate(total = `in station area` + `not in station area`) |>
  select("year", estimate = "in station area", "total") |>
  mutate(station_change = estimate - lag(estimate)) |>
  mutate(total_change = total - lag(total)) |>
  drop_na() |>
  mutate(date = mdy(paste0("04-01-",year)), 
         geography = "Region", 
         geography_type = "Region", 
         variable = "in station area",
         grouping = "Change",
         metric = "Housing Units near HCT",
         share = station_change / total_change) |>
  select("year", "date", "geography", "geography_type", "variable", "grouping", "metric", estimate = "station_change", "share")

pop_hsg_jobs <- bind_rows(pop_hct, hu_hct, jobs_hct, pop, hsg, jobs) |> 
  mutate(metric = factor(x=metric, levels = c("Population", "Housing Units",  "Jobs", "Population near HCT", "Housing Units near HCT", "Jobs near HCT")))

saveRDS(pop_hsg_jobs, here(rtp_dashboard_process_url, "pop_hsg_jobs.rds"))

# Safety Data -------------------------------------------------------------
# First process Data
fatal_collisions <- process_wstc_fatal_collisions(data_years=seq(2010, 2024, by = 1))
serious_collisions <- process_wsdot_serious_injury_collisions()
mpo_collisions <- process_fars_data(safety_yrs=c(seq(2010,2023,by=1)))

# Save processed data to save time
saveRDS(fatal_collisions, here(rtp_dashboard_process_url, "fatal_collisions.rds"))
saveRDS(serious_collisions, here(rtp_dashboard_process_url, "serious_collisions.rds"))
saveRDS(mpo_collisions, here(rtp_dashboard_process_url, "mpo_collisions.rds"))

# Now summarize Data in RTP Dashboard format
processed_collision_data <- bind_rows(fatal_collisions, serious_collisions)
collision_data <- summarise_collision_data_dashboard(data_file = processed_collision_data)
collision_data <- bind_rows(collision_data, mpo_collisions)

#collision_data <- process_safety_data(base_yr=2010, wtsc_yr=2024, fars_yr=2021)
saveRDS(collision_data, here(rtp_dashboard_process_url, "collision_data.rds"))

# Travel Time -------------------------------------------------------------
congested_lanes_miles <- summarize_npmrds_data(file_path = rtp_dashboard_congestion_url)
saveRDS(congested_lanes_miles, here(rtp_dashboard_process_url, "congestion_data.rds"))

congestion_map_data <- create_npmrds_map_data(file_path = rtp_dashboard_congestion_url, data_mo = "jan", data_yr = 2026)
saveRDS(congestion_map_data, here(rtp_dashboard_process_url, "congestion_map_data.rds"))
