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
library(plotly)
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

# SVG values for ehcarts pictorial charts
fa_user <- "path://M256 288A144 144 0 1 0 256 0a144 144 0 1 0 0 288zm-94.7 32C72.2 320 0 392.2 0 481.3c0 17 13.8 30.7 30.7 30.7H481.3c17 0 30.7-13.8 30.7-30.7C512 392.2 439.8 320 350.7 320H161.3z"
fa_wfh <- "path://M218.3 8.5c12.3-11.3 31.2-11.3 43.4 0l208 192c6.7 6.2 10.3 14.8 10.3 23.5H336c-19.1 0-36.3 8.4-48 21.7V208c0-8.8-7.2-16-16-16H208c-8.8 0-16 7.2-16 16v64c0 8.8 7.2 16 16 16h64V416H112c-26.5 0-48-21.5-48-48V256H32c-13.2 0-25-8.1-29.8-20.3s-1.6-26.2 8.1-35.2l208-192zM352 304V448H544V304H352zm-48-16c0-17.7 14.3-32 32-32H560c17.7 0 32 14.3 32 32V448h32c8.8 0 16 7.2 16 16c0 26.5-21.5 48-48 48H544 352 304c-26.5 0-48-21.5-48-48c0-8.8 7.2-16 16-16h32V288z"
fa_bus <- "path://M224 0C348.8 0 448 35.2 448 80V96 416c0 17.7-14.3 32-32 32v32c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V448H128v32c0 17.7-14.3 32-32 32H64c-17.7 0-32-14.3-32-32l0-32c-17.7 0-32-14.3-32-32V96 80C0 35.2 99.2 0 224 0zM64 128V256c0 17.7 14.3 32 32 32H352c17.7 0 32-14.3 32-32V128c0-17.7-14.3-32-32-32H96c-17.7 0-32 14.3-32 32zM80 400a32 32 0 1 0 0-64 32 32 0 1 0 0 64zm288 0a32 32 0 1 0 0-64 32 32 0 1 0 0 64z"
fa_house <- "path://M575.8 255.5c0 18-15 32.1-32 32.1h-32l.7 160.2c0 2.7-.2 5.4-.5 8.1V472c0 22.1-17.9 40-40 40H456c-1.1 0-2.2 0-3.3-.1c-1.4 .1-2.8 .1-4.2 .1H416 392c-22.1 0-40-17.9-40-40V448 384c0-17.7-14.3-32-32-32H256c-17.7 0-32 14.3-32 32v64 24c0 22.1-17.9 40-40 40H160 128.1c-1.5 0-3-.1-4.5-.2c-1.2 .1-2.4 .2-3.6 .2H104c-22.1 0-40-17.9-40-40V360c0-.9 0-1.9 .1-2.8V287.6H32c-18 0-32-14-32-32.1c0-9 3-17 10-24L266.4 8c7-7 15-8 22-8s15 2 21 7L564.8 231.5c8 7 12 15 11 24z"

# color for page loading spinner
load_clr <- "#91268F"

transit_modes <- c("Bus", "Commuter Rail", "Ferry", "Rail", "Vanpool")

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

# Data via CSV ------------------------------------------------------------
data <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) %>%
  mutate(data_year = as.character(lubridate::year(date)))

# Source information
source_info <- read_csv("data/source_information.csv", show_col_types = FALSE)

# Create MPO Data for Charts ----------------------------------------------
metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

mpo_safety <- safety_data |> 
  filter(geography_type=="Metro Regions" & variable=="Rate per 100k people" & data_year == current_census_year) |>
  mutate(metric = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) |>
  mutate(metric=replace_na(metric,"Other")) |>
  arrange(estimate)

mpo_order <- mpo_safety |> select(geography) |> pull()
mpo_safety <- mpo_safety |> mutate(geography = factor(x=geography, levels=mpo_order))
