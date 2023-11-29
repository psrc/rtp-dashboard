# Packages ----------------------------------------------------------------

# Packages for Interactive Web application
library(shiny)
library(shinydashboard)
library(bs4Dash)
library(shinycssloaders)

# Packages for Data Cleaning/Processing
library(tidyverse)

# Packages for Chart Creation
library(psrcplot)
library(echarts4r)

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
source("functions.R")

# Page Information --------------------------------------------------------
left_panel_info <- read_csv("data/left_panel_information.csv", show_col_types = FALSE)
page_text <- read_csv("data/page_text.csv", show_col_types = FALSE)

# Inputs ---------------------------------------------------------------
base_year <- "2005"
pre_covid <- "2019"
current_population_year <- "2022"
current_jobs_year <- "2021"
current_census_year <- "2021"
current_vmt_year <- 2021

wgs84 <- 4326

yr_ord <- c("2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010")
county_ord <- c("King\nCounty", "Kitsap\nCounty", "Pierce\nCounty", "Snohomish\nCounty", "Region")
county_short_ord <- c("King", "Kitsap", "Pierce", "Snohomish", "Region")
tod_ord <- c("Early\nMorning", "AM Peak", "Late\nMorning", "Afternoon", "Evening", "Overnight")

# SVG values for ehcarts pictorial charts
fa_user <- "path://M256 288A144 144 0 1 0 256 0a144 144 0 1 0 0 288zm-94.7 32C72.2 320 0 392.2 0 481.3c0 17 13.8 30.7 30.7 30.7H481.3c17 0 30.7-13.8 30.7-30.7C512 392.2 439.8 320 350.7 320H161.3z"
fa_wfh <- "path://M218.3 8.5c12.3-11.3 31.2-11.3 43.4 0l208 192c6.7 6.2 10.3 14.8 10.3 23.5H336c-19.1 0-36.3 8.4-48 21.7V208c0-8.8-7.2-16-16-16H208c-8.8 0-16 7.2-16 16v64c0 8.8 7.2 16 16 16h64V416H112c-26.5 0-48-21.5-48-48V256H32c-13.2 0-25-8.1-29.8-20.3s-1.6-26.2 8.1-35.2l208-192zM352 304V448H544V304H352zm-48-16c0-17.7 14.3-32 32-32H560c17.7 0 32 14.3 32 32V448h32c8.8 0 16 7.2 16 16c0 26.5-21.5 48-48 48H544 352 304c-26.5 0-48-21.5-48-48c0-8.8 7.2-16 16-16h32V288z"
fa_bus <- "path://M224 0C348.8 0 448 35.2 448 80V96 416c0 17.7-14.3 32-32 32v32c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V448H128v32c0 17.7-14.3 32-32 32H64c-17.7 0-32-14.3-32-32l0-32c-17.7 0-32-14.3-32-32V96 80C0 35.2 99.2 0 224 0zM64 128V256c0 17.7 14.3 32 32 32H352c17.7 0 32-14.3 32-32V128c0-17.7-14.3-32-32-32H96c-17.7 0-32 14.3-32 32zM80 400a32 32 0 1 0 0-64 32 32 0 1 0 0 64zm288 0a32 32 0 1 0 0-64 32 32 0 1 0 0 64z"
fa_house <- "path://M575.8 255.5c0 18-15 32.1-32 32.1h-32l.7 160.2c0 2.7-.2 5.4-.5 8.1V472c0 22.1-17.9 40-40 40H456c-1.1 0-2.2 0-3.3-.1c-1.4 .1-2.8 .1-4.2 .1H416 392c-22.1 0-40-17.9-40-40V448 384c0-17.7-14.3-32-32-32H256c-17.7 0-32 14.3-32 32v64 24c0 22.1-17.9 40-40 40H160 128.1c-1.5 0-3-.1-4.5-.2c-1.2 .1-2.4 .2-3.6 .2H104c-22.1 0-40-17.9-40-40V360c0-.9 0-1.9 .1-2.8V287.6H32c-18 0-32-14-32-32.1c0-9 3-17 10-24L266.4 8c7-7 15-8 22-8s15 2 21 7L564.8 231.5c8 7 12 15 11 24z"
fa_walking <- "path://M160 48a48 48 0 1 1 96 0 48 48 0 1 1 -96 0zM126.5 199.3c-1 .4-1.9 .8-2.9 1.2l-8 3.5c-16.4 7.3-29 21.2-34.7 38.2l-2.6 7.8c-5.6 16.8-23.7 25.8-40.5 20.2s-25.8-23.7-20.2-40.5l2.6-7.8c11.4-34.1 36.6-61.9 69.4-76.5l8-3.5c20.8-9.2 43.3-14 66.1-14c44.6 0 84.8 26.8 101.9 67.9L281 232.7l21.4 10.7c15.8 7.9 22.2 27.1 14.3 42.9s-27.1 22.2-42.9 14.3L247 287.3c-10.3-5.2-18.4-13.8-22.8-24.5l-9.6-23-19.3 65.5 49.5 54c5.4 5.9 9.2 13 11.2 20.8l23 92.1c4.3 17.1-6.1 34.5-23.3 38.8s-34.5-6.1-38.8-23.3l-22-88.1-70.7-77.1c-14.8-16.1-20.3-38.6-14.7-59.7l16.9-63.5zM68.7 398l25-62.4c2.1 3 4.5 5.8 7 8.6l40.7 44.4-14.5 36.2c-2.4 6-6 11.5-10.6 16.1L54.6 502.6c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3L68.7 398z"
fa_biking <- "path://M400 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm27.2 64l-61.8-48.8c-17.3-13.6-41.7-13.8-59.1-.3l-83.1 64.2c-30.7 23.8-28.5 70.8 4.3 91.6L288 305.1V416c0 17.7 14.3 32 32 32s32-14.3 32-32V288c0-10.7-5.3-20.7-14.2-26.6L295 232.9l60.3-48.5L396 217c5.7 4.5 12.7 7 20 7h64c17.7 0 32-14.3 32-32s-14.3-32-32-32H427.2zM56 384a72 72 0 1 1 144 0A72 72 0 1 1 56 384zm200 0A128 128 0 1 0 0 384a128 128 0 1 0 256 0zm184 0a72 72 0 1 1 144 0 72 72 0 1 1 -144 0zm200 0a128 128 0 1 0 -256 0 128 128 0 1 0 256 0z"
fa_car <- "path://M135.2 117.4L109.1 192H402.9l-26.1-74.6C372.3 104.6 360.2 96 346.6 96H165.4c-13.6 0-25.7 8.6-30.2 21.4zM39.6 196.8L74.8 96.3C88.3 57.8 124.6 32 165.4 32H346.6c40.8 0 77.1 25.8 90.6 64.3l35.2 100.5c23.2 9.6 39.6 32.5 39.6 59.2V400v48c0 17.7-14.3 32-32 32H448c-17.7 0-32-14.3-32-32V400H96v48c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32V400 256c0-26.7 16.4-49.6 39.6-59.2zM128 288a32 32 0 1 0 -64 0 32 32 0 1 0 64 0zm288 32a32 32 0 1 0 0-64 32 32 0 1 0 0 64z"

#my_logo <- fontawesome::fa("car")

# color for page loading spinner
load_clr <- "#91268F"

transit_modes <- c("Bus", "Commuter Rail", "Ferry", "Rail", "Vanpool")

# color for funded/not funded chart
stp_colors <- c("#91268F", "#F05A28", "#8CC63E", "#00A7A0", "#EB4584", "#4C4C4C",
                "#E3C9E3", "#FBD6C9", "#E2F1CF", "#BFE9E7", "#FFBCD9", "#BCBEC0")

cmaq_colors <- c("#91268F", "#F05A28", "#8CC63E", "#00A7A0", "#EB4584", "#EB4584", "#4C4C4C",
                "#E3C9E3", "#FBD6C9", "#E2F1CF", "#BFE9E7", "#FFBCD9", "#FFBCD9", "#BCBEC0")

# Items to use to fill chart
stp_plot_buckets <- c("center_Yes", "access_Yes", "equity_Yes", "safety_Yes", "climate_Yes", "readiness_Yes",
                      "center_No", "access_No", "equity_No", "safety_No", "climate_No", "readiness_No")

cmaq_plot_buckets <- c("center_Yes", "access_Yes", "equity_Yes", "safety_Yes", "climate_Yes", "waehd_Yes", "readiness_Yes", 
                       "center_No", "access_No", "equity_No", "safety_No", "climate_No", "waehd_No", "readiness_No")

fhwa_cols <- c("project_id", "sponsor", "title", "phase", "category", "funding_request", "total")


# Data via RDS files ------------------------------------------------------
safety_data <- readRDS("data/collision_data.rds") |> mutate(data_year = as.character(lubridate::year(date)))
commute_data <- readRDS("data/commute_data.rds")
climate_data <- readRDS("data/vehicle_data.rds")
ev_by_tract <- readRDS("data/ev_registration_by_tract.rds")
vmt_data <- readRDS("data/vmt.rds")
vkt_data <- readRDS("data/vkt.rds")
pop_hsg_jobs <- readRDS("data/pop_hsg_jobs.rds")
hct_growth <- readRDS("data/hct.rds") 
efa_income <- readRDS("data/efa_income.rds")
transit_data <- readRDS("data/transit_data.rds")
congestion_data <- readRDS("data/congestion_data.rds")
congestion_map_data <- readRDS("data/congestion_map_data.rds")
stp <- readRDS("data/stp.rds")
cmaq <- readRDS("data/cmaq.rds")
stp_lyr <- readRDS("data/stp_lyr.rds")
cmaq_lyr <- readRDS("data/cmaq_lyr.rds")

# Source Information ------------------------------------------------------------
source_info <- read_csv("data/source_information.csv", show_col_types = FALSE)

# Data Download Table List ------------------------------------------------------
download_table_list <- list("Sources" = source_info,
                            "Climate-ZEV" = climate_data %>% filter(metric == "vehicle-registrations"),
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
                            "Growth" = bind_rows(pop_hsg_jobs, hct_growth),
                            "Transit-Boardings" = transit_data,
                            "Transit-Mode" = commute_data %>% filter(variable == "Transit"),
                            "Walking" = commute_data %>% filter(variable %in% c("Walk", "Walked")),
                            "Biking" = commute_data %>% filter(variable %in% c("Bike", "Bicycle")),
                            "Time-Travel-Time" = commute_data %>% filter(metric %in% c("Mean Commute Time", "commute-times")),
                            "Time-Departure-Time" = commute_data %>% filter(metric %in% c("departure-time", "Departure Time Bins"))
                            )


