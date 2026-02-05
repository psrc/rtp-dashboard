# Packages ----------------------------------------------------------------

# Packages for Interactive Web application
library(shiny)
library(bslib)
library(shinycssloaders)

# Packages for Data Cleaning/Processing
library(dplyr)
library(readr)
library(purrr)
library(lubridate)
library(stringr)
library(tidyr)
library(forcats)

# Packages for Chart Creation
library(ggplot2)
library(ggimage)
library(rsvg)
library(plotly)
library(scales)
library(htmlwidgets)

# Packages for Map Creation
library(sf)
library(leaflet)

# Packages for Table Creation
library(DT)

# Package for Excel Data Creation
library(openxlsx)

# Run Modules Files ---------------------------------------------------------------------------
module_files <- list.files('modules', full.names = TRUE)
sapply(module_files, source)

# Page Information --------------------------------------------------------
page_text <- read_csv("data/page_text.csv", show_col_types = FALSE)

# Inputs ---------------------------------------------------------------
base_year <- "2005"
pre_covid <- "2019"

current_population_year <- "2024"
current_jobs_year <- "2023"

current_census_year <- "2024"
current_pums_year <- "2023"

current_fars_year <- "2021"

current_registration_year <- "2025"

acs_yrs <- c(2024, 2019, 2014)
pums_yrs <- c(2023, 2019, 2014)

climate_base_year <- 1990
climate_vision_year <- 2018
climate_vmt_year <- 2024
climate_horizon_year <- 2050

wfh_base_year <- 2014
wfh_vision_year <- 2019
wfh_vmt_year <- 2024
wfh_horizon_year <- 2050

transit_base_year <- 2014
transit_vision_year <- 2019
transit_current_year <- 2024
transit_horizon_year <- 2050

wgs84 <- 4326

yr_ord <- c("2024", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010")
county_ord <- c("King\nCounty", "Kitsap\nCounty", "Pierce\nCounty", "Snohomish\nCounty", "Region")
county_short_ord <- c("King", "Kitsap", "Pierce", "Snohomish", "Region")
tod_ord <- c("Early\nMorning", "AM Peak", "Late\nMorning", "Afternoon", "Evening", "Overnight")

# color for page loading spinner
load_clr <- "#91268F"

transit_modes <- c("Bus", "Commuter Rail", "Ferry", "Rail", "Vanpool")

# Data via RDS files ------------------------------------------------------
vehicle_data <- readRDS("data/vehicle_data.rds")
ev_by_tract <- readRDS("data/ev_registration_by_tract.rds")
vmt_data <- readRDS("data/vmt.rds")
vkt_data <- readRDS("data/vkt.rds") |> mutate(year = 2024)
commute_data <- readRDS("data/commute_data.rds")
transit_data <- readRDS("data/transit_data.rds")


safety_data <- readRDS("data/collision_data.rds") |> mutate(data_year = as.character(lubridate::year(date)))

pop_hsg_jobs <- readRDS("data/pop_hsg_jobs.rds")
efa_income <- readRDS("data/efa_income.rds")

congestion_data <- readRDS("data/congestion_data.rds")
congestion_map_data <- readRDS("data/congestion_map_data.rds")

# Source Information ------------------------------------------------------------
source_info <- read_csv("data/source_information.csv", show_col_types = FALSE)
summary_info <- read_csv("data/summary_information.csv", show_col_types = FALSE)

# Data Download Table List ------------------------------------------------------
download_table_list <- list("Sources" = source_info,
                            "Climate-ZEV" = vehicle_data %>% filter(metric == "vehicle-registrations"),
                            "Climate-VMT" = bind_rows(vmt_data, vkt_data),
                            "Climate-WFH" = commute_data %>% filter(variable %in% c("Work from Home", "Worked from home")),
                            "Safety-Geography" = safety_data %>% filter(geography_type %in% c("Region",
                                                                                              "County",
                                                                                              "Historically Disadvantaged Community",
                                                                                              "Metro Regions")),
                            "Safety-Demographics" = safety_data %>% filter(geography_type %in% c("Race",
                                                                                                 "Age Group",
                                                                                                 "Gender")),
                            "Safety-Other" = safety_data %>% filter(geography_type %in% c("Mode",
                                                                                          "Time of Day",
                                                                                          "Day of Week",
                                                                                          "Roadway Type")),
                            "Growth" = pop_hsg_jobs,
                            "Transit-Boardings" = transit_data,
                            "Transit-Mode" = commute_data %>% filter(variable == "Transit"),
                            "Walking" = commute_data %>% filter(variable %in% c("Walk", "Walked")),
                            "Biking" = commute_data %>% filter(variable %in% c("Bike", "Bicycle")),
                            "Time-Travel-Time" = commute_data %>% filter(metric %in% c("Mean Commute Time", "commute-times")),
                            "Time-Departure-Time" = commute_data %>% filter(metric %in% c("departure-time", "Departure Time Bins"))
                            )


psrc_mission <- "Our mission is to advance solutions to achieve a thriving, racially equitable, and sustainable central Puget Sound region through leadership, visionary planning, and collaboration."
