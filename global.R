# Packages ----------------------------------------------------------------

# Packages for Interactive Web application
library(shiny)
library(bslib)

# Packages for Data Cleaning/Processing
library(dplyr)
library(readr)
library(tidyr)
library(forcats)

# Packages for Chart Creation
library(plotly)
library(scales)
library(htmlwidgets)

# Packages for Map Creation
library(sf)
library(leaflet)

# Packages for Table Creation
library(DT)

# Run Modules Files ---------------------------------------------------------------------------
module_files <- list.files('modules', full.names = TRUE)
sapply(module_files, source)

# Page Information --------------------------------------------------------
page_text <- read_csv("data/page_text.csv", show_col_types = FALSE)

# Inputs ---------------------------------------------------------------
wgs84 <- 4326

acs_yrs <- c(2024, 2019, 2014)
pums_yrs <- c(2024, 2019, 2014)

wcag_palette <- readRDS("data/wcag_palette.rds")

# Climate Data ------------------------------------------------------------
# ZEV
registration_box_values <- readRDS("data/registration_box_values.rds")
vehicle_region_data <- readRDS("data/vehicle_region_data.rds")
tract_ev_data <- readRDS("data/tract_ev_data.rds")

# VMT
vmt_box_values <- readRDS("data/vmt_box_values.rds")
vmt_region_data <- readRDS("data/vmt_region_data.rds")
vmt_county_data <- readRDS("data/vmt_county_data.rds")
vkt_data <- readRDS("data/vkt_data.rds")

# Work from Home
wfh_box_values <- readRDS("data/wfh_box_values.rds")
wfh_county_data <- readRDS("data/wfh_county_data.rds")
wfh_race_data <- readRDS("data/wfh_race_data.rds")
wfh_metro_data <- readRDS("data/wfh_metro_data.rds")
wfh_city_data <- readRDS("data/wfh_city_data.rds")

# Growth Data ------------------------------------------------------------
growth_box_values <- readRDS("data/growth_box_values.rds")
growth_region_data <- readRDS("data/growth_region_data.rds")
growth_hct_data <- readRDS("data/growth_hct_data.rds")

# Transit Data ------------------------------------------------------------
# Metrics
transit_metric_box_values <- readRDS("data/transit_metric_box_values.rds")
transit_metric_region <- readRDS("data/transit_metric_region_data.rds")
transit_metric_by_mode <- readRDS("data/transit_metric_by_mode_data.rds")
transit_metric_metro <- readRDS("data/transit_metric_metro_data.rds")

# Mode
transit_mode_box_values <- readRDS("data/transit_mode_box_values.rds")
transit_mode_county_data <- readRDS("data/transit_mode_county_data.rds")
transit_mode_race_data <- readRDS("data/transit_mode_race_data.rds")
transit_mode_metro_data <- readRDS("data/transit_mode_metro_data.rds")
transit_mode_city_data <- readRDS("data/transit_mode_city_data.rds")

# Walk and Bike Data ------------------------------------------------------------
# Walk
walk_mode_box_values <- readRDS("data/walk_mode_box_values.rds")
walk_mode_county_data <- readRDS("data/walk_mode_county_data.rds")
walk_mode_race_data <- readRDS("data/walk_mode_race_data.rds")
walk_mode_metro_data <- readRDS("data/walk_mode_metro_data.rds")
walk_mode_city_data <- readRDS("data/walk_mode_city_data.rds")

# Bike
bike_mode_box_values <- readRDS("data/bike_mode_box_values.rds")
bike_mode_county_data <- readRDS("data/bike_mode_county_data.rds")
bike_mode_race_data <- readRDS("data/bike_mode_race_data.rds")
bike_mode_metro_data <- readRDS("data/bike_mode_metro_data.rds")
bike_mode_city_data <- readRDS("data/bike_mode_city_data.rds")

# Safety Data ------------------------------------------------------------
# Geography Based
safety_geography_box_values <- readRDS("data/safety_geography_box_values.rds")
deaths_region_data <- readRDS("data/deaths_region_data.rds")
serious_region_data <- readRDS("data/serious_region_data.rds")
deaths_rural_data <- readRDS("data/deaths_rural_data.rds")
serious_rural_data <- readRDS("data/serious_rural_data.rds")
deaths_hdc_data <- readRDS("data/deaths_hdc_data.rds")
serious_hdc_data <- readRDS("data/serious_hdc_data.rds")
safety_county_data <- readRDS("data/safety_county_data.rds")
deaths_mpo_data <- readRDS("data/deaths_mpo_data.rds")

# Person Based
safety_person_box_values <- readRDS("data/safety_person_box_values.rds")
deaths_race_data <- readRDS("data/deaths_race_data.rds")
deaths_age_data <- readRDS("data/deaths_age_data.rds")
serious_age_data <- readRDS("data/serious_age_data.rds")
deaths_gender_data <- readRDS("data/deaths_gender_data.rds")
serious_gender_data <- readRDS("data/serious_gender_data.rds")

# Other Based
safety_mode_box_values <- readRDS("data/safety_mode_box_values.rds")
deaths_mode_data <- readRDS("data/deaths_mode_data.rds")
serious_mode_data <- readRDS("data/serious_mode_data.rds")
deaths_tod_data <- readRDS("data/deaths_tod_data.rds")
serious_tod_data <- readRDS("data/serious_tod_data.rds")
deaths_dow_data <- readRDS("data/deaths_dow_data.rds")
serious_dow_data <- readRDS("data/serious_dow_data.rds")

# Travel Time -------------------------------------------------------------
# Commutes
tt_box_values <- readRDS("data/tt_box_values.rds")
tt_county_data <- readRDS("data/tt_county_data.rds")
tt_race_data <- readRDS("data/tt_race_data.rds")
tt_metro_data <- readRDS("data/tt_metro_data.rds")
tt_city_data <- readRDS("data/tt_city_data.rds")

# Departure Time
dt_box_values <- readRDS("data/dt_box_values.rds")
dt_county_data <- readRDS("data/dt_county_data.rds")
dt_race_data <- readRDS("data/dt_race_data.rds")
dt_metro_data <- readRDS("data/dt_metro_data.rds")
dt_city_data <- readRDS("data/dt_city_data.rds")

# Congestion
congestion_box_values <- readRDS("data/congestion_box_values.rds")
congestion_region_weekday <- readRDS("data/congestion_region_weekday_data.rds")
congestion_region_weekend <- readRDS("data/congestion_region_weekend_data.rds")
congestion_am_map <- readRDS("data/congestion_am_map_data.rds")
congestion_pm_map <- readRDS("data/congestion_pm_map_data.rds")

# Source Information ------------------------------------------------------------
source_info <- read_csv("data/source_information.csv", show_col_types = FALSE)
summary_info <- read_csv("data/summary_information.csv", show_col_types = FALSE)

# Data Download Table List ------------------------------------------------------
# download_table_list <- list("Sources" = source_info,
#                             "Climate-ZEV" = vehicle_data %>% filter(metric == "vehicle-registrations"),
#                             "Climate-VMT" = bind_rows(vmt_data, vkt_data),
#                             "Climate-WFH" = commute_data %>% filter(variable %in% c("Work from Home", "Worked from home")),
#                             "Safety-Geography" = safety_data %>% filter(geography_type %in% c("Region",
#                                                                                               "County",
#                                                                                               "Historically Disadvantaged Community",
#                                                                                               "Metro Regions")),
#                             "Safety-Demographics" = safety_data %>% filter(geography_type %in% c("Race",
#                                                                                                  "Age Group",
#                                                                                                  "Gender")),
#                             "Safety-Other" = safety_data %>% filter(geography_type %in% c("Mode",
#                                                                                           "Time of Day",
#                                                                                           "Day of Week",
#                                                                                           "Roadway Type")),
#                             "Growth" = pop_hsg_jobs,
#                             "Transit-Boardings" = transit_data,
#                             "Transit-Mode" = commute_data %>% filter(variable == "Transit"),
#                             "Walking" = commute_data %>% filter(variable %in% c("Walk", "Walked")),
#                             "Biking" = commute_data %>% filter(variable %in% c("Bike", "Bicycle")),
#                             "Time-Travel-Time" = commute_data %>% filter(metric %in% c("Mean Commute Time", "commute-times")),
#                             "Time-Departure-Time" = commute_data %>% filter(metric %in% c("departure-time", "Departure Time Bins"))
#                             )


psrc_mission <- "Our mission is to advance solutions to achieve a thriving, racially equitable, and sustainable central Puget Sound region through leadership, visionary planning, and collaboration."
