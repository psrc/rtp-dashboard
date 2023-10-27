# Packages ----------------------------------------------------------------

# Packages for Interactive Web application
library(shiny)
library(shinydashboard)
library(bs4Dash)

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
#library(DT)

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

# Data via RDS files ------------------------------------------------------
safety_data <- readRDS("data/collision_data.rds") |> mutate(data_year = as.character(lubridate::year(date)))
commute_data <- readRDS("data/commute_data.rds") |> mutate(data_year = as.character(lubridate::year(date)))
climate_data <- readRDS("data/ev_registrations.rds") |> mutate(data_year = as.character(lubridate::year(date)))
ev_by_tract <- readRDS("data/ev_registration_by_tract.rds")
vmt_data <- readRDS("data/vmt.rds")
vkt_data <- readRDS("data/vkt.rds")

#zipcodes <- readRDS("data/zipcodes.rds")
tracts <- readRDS("data/tracts.rds")

# Data via CSV ------------------------------------------------------------
data <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) %>%
  mutate(data_year = as.character(lubridate::year(date)))

total_job_change <- data %>% filter(metric=="Total Employment", variable=="Region") %>%
  mutate(total = (estimate-lag(estimate))) %>%
  select(date, data_year, geography, total)

hct_job_change <- data %>% filter(metric=="Total Employment", variable=="Inside HCT Area") %>%
  mutate(hct = (estimate-lag(estimate))) %>%
  select(date, data_year, geography, hct)

job_change <- left_join(total_job_change, hct_job_change, by=c("date","data_year", "geography")) %>%
  mutate(share=hct/total) %>%
  rename(estimate=hct) %>%
  mutate(variable="Inside HCT Area", geography_type="PSRC Region", metric="Employment Growth Inside HCT Area", grouping="Change") %>%
  select(-total) %>%
  drop_na()

data <-bind_rows(data, job_change)

rm(total_job_change, hct_job_change, job_change)

boardings <- read_csv("data/rtp-transit-boardings.csv", show_col_types = FALSE) %>%
  mutate(date = lubridate::mdy(date)) %>%
  mutate(data_year = as.character(lubridate::year(date)))

data <- bind_rows(data, boardings)
rm(boardings)

hours <- read_csv("data/rtp-transit-hours.csv", show_col_types = FALSE) %>%
  mutate(date = lubridate::mdy(date)) %>%
  mutate(data_year = as.character(lubridate::year(date)))

data <- bind_rows(data, hours)
rm(hours)

efa_income <- read_csv("data/efa_income_tracts.csv", show_col_types = FALSE) %>% select(GEOID) %>% pull()

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

mpo_transit_boardings_precovid <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Boardings" & variable=="All Transit Modes" & lubridate::year(date)==pre_covid & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(desc(estimate))

mpo_order <- mpo_transit_boardings_precovid %>% select(geography) %>% pull()
mpo_transit_boardings_precovid <- mpo_transit_boardings_precovid %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_boardings_today <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Boardings" & variable=="All Transit Modes" & lubridate::year(date)==current_population_year & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(desc(estimate))

mpo_order <- mpo_transit_boardings_today %>% select(geography) %>% pull()
mpo_transit_boardings_today <- mpo_transit_boardings_today %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_hours_precovid <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Revenue-Hours" & variable=="All Transit Modes" & lubridate::year(date)==pre_covid & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(desc(estimate))

mpo_order <- mpo_transit_hours_precovid %>% select(geography) %>% pull()
mpo_transit_hours_precovid <- mpo_transit_hours_precovid %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_hours_today <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Revenue-Hours" & variable=="All Transit Modes" & lubridate::year(date)==current_population_year & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(desc(estimate))

mpo_order <- mpo_transit_hours_today %>% select(geography) %>% pull()
mpo_transit_hours_today <- mpo_transit_hours_today %>% mutate(geography = factor(x=geography, levels=mpo_order))

# Population Data for Text ---------------------------------------------------------
vision_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & metric=="Forecast Population" & variable=="Total" & geography=="Region") %>% select(estimate) %>% pull()
actual_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & metric=="Observed Population" & variable=="Total" & geography=="Region") %>% select(estimate) %>% pull()
population_delta <- actual_pop_today - vision_pop_today
actual_pop_hct_today <- data %>% filter(lubridate::year(date)==current_population_year & grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Population") %>% select(share) %>% pull()

# Housing Data for Text ---------------------------------------------------------
vision_housing_today <- data %>% filter(lubridate::year(date)==current_population_year & metric=="Forecast" & variable=="Total Housing Units" & geography=="Region") %>% select(estimate) %>% pull()
actual_housing_today <- data %>% filter(lubridate::year(date)==current_population_year & metric=="Observed" & variable=="Total Housing Units" & geography=="Region" & grouping=="Total") %>% select(estimate) %>% pull()
housing_delta <- actual_housing_today - vision_housing_today
actual_housing_hct_today <- data %>% filter(lubridate::year(date)==current_population_year & grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Housing Units") %>% select(share) %>% pull()

# Employment Data for Text ------------------------------------------------
vision_jobs_today <- data %>% filter(lubridate::year(date)==current_jobs_year & metric=="Forecast Employment" & variable=="Total") %>% select(estimate) %>% pull()
actual_jobs_today <- data %>% filter(lubridate::year(date)==current_jobs_year & metric=="Observed Employment" & variable=="Total") %>% select(estimate) %>% pull()
jobs_delta <- actual_jobs_today - vision_jobs_today
actual_jobs_hct_today <- data %>% filter(lubridate::year(date)==current_jobs_year & metric=="Employment Growth Inside HCT Area" & variable=="Inside HCT Area") %>% select(share) %>% pull()

# Vehicle Registration Data for Text --------------------------------------
efa_tracts <- tracts %>% 
  filter(GEOID10 %in% efa_income) %>%
  st_union() %>%
  st_sf() 

min_transit_years <- data %>% filter(metric=="Mode to Work" & geography=="Region") %>% select(data_year) %>% pull() %>% unique() %>% min()
max_min_transit_years <- as.character(as.integer(min_transit_years)+5)
transit_years <- data %>% filter(metric=="Mode to Work" & geography=="Region" & data_year>=max_min_transit_years) %>% select(data_year) %>% pull() %>% unique()

# Text Data ---------------------------------------------------------------
growth_overview_1 <- paste("The region's vision for 2050 is to provide exceptional quality of life, opportunity for all,",
                           "connected communities, a spectacular natural environment, and an innovative, thriving economy.")

growth_overview_2 <- paste("Over the next 30 years, the central Puget Sound region will add another million and a half people,",
                           "reaching a population of 5.8 million. How can we ensure that all residents benefit from the region’s",
                           "thriving communities, strong economy and healthy environment as population grows?",
                           "Local counties, cities, Tribes and other partners have worked together with PSRC to develop VISION 2050.")

growth_overview_3 <- paste("VISION 2050’s multicounty planning policies, actions, and regional growth strategy guide how and where",
                           "the region grows through 2050. The plan informs updates to the Regional Transportation Plan",
                           "and Regional Economic Strategy. VISION 2050 also sets the stage for updates to countywide planning",
                           "policies and local comprehensive plans done by cities and counties.")

housing_overview_1 <-paste("The region is expected to grow by 830,000 households by the year 2050.",
                           "Meeting the housing needs of all households at a range of income levels is",
                           "integral to creating a region that is livable for all residents, economically",
                           "prosperous and environmentally sustainable.")

housing_overview_2 <-paste("By providing data, guidance, and technical assistance,",
                           "PSRC supports jurisdictions in their efforts to adopt best",
                           "housing practices and establish coordinated local housing and affordable housing targets.")

pop_vision_caption <- paste0("In VISION 2050 forecasts, the population in ",
                             current_population_year, 
                             " was forecasted to be ", 
                             prettyNum(round(vision_pop_today,-3), big.mark = ","),
                             ". The observed population in 2022 was  ",
                             prettyNum(round(actual_pop_today,-3), big.mark = ","), 
                             ", a difference of ",
                             prettyNum(round(population_delta,-3), big.mark = ","),
                             " people.")
pop_hct_caption <- paste0("In VISION 2050, the population growth goal is for ",
                          "65% of population growth to be near high-capacity transit. ",
                          "In ",
                          current_population_year, 
                          ", the observed share of population growth near HCT was ",
                          prettyNum(round(actual_pop_hct_today*100,0), big.mark = ","),
                          "%.")

housing_vision_caption <- paste0("In VISION 2050 forecasts, the total housing units in the PSRC region in ",
                             current_population_year, 
                             " was forecasted to be ", 
                             prettyNum(round(vision_housing_today,-3), big.mark = ","),
                             ". The observed housing units in ",
                             current_population_year,
                             " were ",
                             prettyNum(round(actual_housing_today,-3), big.mark = ","), 
                             ", a difference of ",
                             prettyNum(round(housing_delta,-3), big.mark = ","),
                             " housing units.")

housing_hct_caption <- paste0("In VISION 2050, the population growth goal is for ",
                              "65% of population growth to be near high-capacity transit. ",
                              "There is no specific goal for housing unit shares near ",
                              "high-capacity transit however household sizes near stations ",
                              "tend to be smaller and hence will likely require slight more units ",
                              "near transit. In ",
                              current_population_year, 
                              ", the observed share of housing unit growth near HCT was ",
                              prettyNum(round(actual_housing_hct_today*100,0), big.mark = ","),
                              "%.")

jobs_vision_caption <- paste0("Job growth Between ",base_year," and ", current_population_year,
                             " has been significantly impacted by the COVID-19 pandemic. In VISION 2050 forecasts, the total employment in ",
                             current_jobs_year, 
                             " was forecasted to be ", 
                             prettyNum(round(vision_jobs_today,-3), big.mark = ","),
                             ". The observed employment at the end of 2021 was  ",
                             prettyNum(round(actual_jobs_today,-3), big.mark = ","), 
                             ", a difference of ",
                             prettyNum(round(jobs_delta,-3), big.mark = ","),
                             " jobs.")

employment_hct_caption <- paste0("In VISION 2050, the employment growth goal is for ",
                          "75% of job growth to be near high-capacity transit. ",
                          "In ",
                          current_population_year, 
                          ", the observed share of job growth near HCT was ",
                          prettyNum(round(actual_jobs_hct_today*100,0), big.mark = ","),
                          "%.")

employment_overview <- paste("Over the next 30 years, the central Puget Sound region will add another million jobs, reaching an employment total of 3.3 million jobs by 2050.", 
                             "How can we ensure that all residents benefit from the region’s strong economy?",
                             "Local counties, cities, Tribes and other partners have worked together with PSRC to develop")

transit_overview_1 <- paste0("The Regional Transportation Plan envisions an integrated system that supports the goals of VISION ",
                             "2050, which calls for increased investment in transportation to support a growing population and ",
                             "economy. VISION 2050 emphasizes investing in transportation projects and programs that support ",
                             "local and regional growth centers and high-capacity transit station areas in particular. These policies ",
                             "emphasize the importance of public transit to achieving the VISION 2050 regional growth strategy.")

transit_overview_2 <- paste0("When people think of transit, most often they think of fixed-route rail or bus service that stops at specific ",
                             "stations or stops on a schedule. For the purposes of this page, these types of transit services are referred to as ",
                             "regular transit.")

transit_overview_3 <- paste0("High-capacity transit in the region is provided by a variety of rail, bus rapid transit and ferry modes, ",
                             "including: Sound Transit’s Link light rail, Tacoma Link, and Sounder commuter rail; Seattle’s two streetcar lines ",
                             "and the historic 1962 monorail; Community Transit’s Swift and King County Metro’s RapidRide bus rapid transit services; ", 
                             "and multimodal and passenger-only ferry services provided by the Washington State Ferries, Pierce County Ferries, ",
                             "King County Metro and Kitsap Transit. Bus rapid transit (BRT) routes in the region are distinguished from other forms ",
                             "of bus transit by a combination of features that include branded buses and stations, off-board fare payment, wider stop ","
                             spacing than other local bus service, and other treatments such as transit signal priority and business access and transit (BAT) lanes.")
