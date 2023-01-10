# Packages ----------------------------------------------------------------

# Packages for Interactive Web application
library(shiny)
library(shinydashboard)
library(bs4Dash)

# Packages for Data Cleaning/Processing
library(tidyverse)

# Packages for Chart Creation
library(psrcplot)
#library(ggplot2)
#library(scales)
library(plotly)

# Packages for Table Creation
#library(DT)

install_psrc_fonts()

# Inputs ---------------------------------------------------------------
base_year <- "2018"
pre_covid <- "2019"
current_population_year <- "2022"

data <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) %>%
  mutate(data_year = as.character(lubridate::year(date)))

# Create MPO Data for Charts ----------------------------------------------
metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

safety_min_year <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="5yr Fatality Rate" & variable=="Fatalities per 100,000 People") %>%
  select(date) %>%
  distinct() %>% 
  pull() %>%
  min() %>%
  lubridate::year()

safety_max_year <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="5yr Fatality Rate" & variable=="Fatalities per 100,000 People") %>%
  select(date) %>%
  distinct() %>% 
  pull() %>%
  max() %>%
  lubridate::year()

mpo_safety_tbl_min <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="5yr Fatality Rate" & variable=="Fatalities per 100,000 People" & lubridate::year(date)==safety_min_year) %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_safety_tbl_min %>% select(geography) %>% pull()
mpo_safety_tbl_min <- mpo_safety_tbl_min %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_safety_tbl_max <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="5yr Fatality Rate" & variable=="Fatalities per 100,000 People" & lubridate::year(date)==safety_max_year) %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_safety_tbl_max %>% select(geography) %>% pull()
mpo_safety_tbl_max <- mpo_safety_tbl_max %>% mutate(geography = factor(x=geography, levels=mpo_order))

# Population Data for Text ---------------------------------------------------------
vision_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Forecast Population") %>% select(estimate) %>% pull()
actual_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Observed Population") %>% select(estimate) %>% pull()
population_delta <- actual_pop_today - vision_pop_today

safety_caption <- paste0("Safety impacts every aspect of the transportation system, covering all modes and encompassing a ",
                         "variety of attributes from facility design to security to personal behavior. The Federal Highway ",
                         "Administration (FHWA) refers to the Four E’s of safety: engineering, enforcement, education and ",
                         "emergency medical services. Many organizations and jurisdictions have implemented programs ",
                         "and projects aimed at improving safety and reducing deaths and serious injuries. All seek to ",
                         "achieve the long-term goal of zero fatalities and serious injuries.")

fatal_trends_caption <- paste0("The total number of crashes that resulted in fatalities in the ",
                               "Puget Sound region between ",
                               safety_min_year,
                               " and ",
                               safety_max_year,
                               " are shown below. After a decrease in the early part of the decade, there was a ",
                               "significant increase between 2013 and 2016, followed by a leveling-out through ",
                               safety_max_year,
                               ".")

pop_vision_caption <- paste0("Between ",base_year," and ", current_population_year,
                             " population growth is in-line with VISION 2050. In VISION 2050 forecasts, the population in ",
                             current_population_year, 
                             " was forecasted to be ", 
                             prettyNum(round(vision_pop_today,-3), big.mark = ","),
                             ". The observed population in 2022 was  ",
                             prettyNum(round(actual_pop_today,-3), big.mark = ","), 
                             ", a difference of ",
                             prettyNum(round(population_delta,-3), big.mark = ","),
                             " people.")


