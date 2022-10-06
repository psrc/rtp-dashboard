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
#library(plotly)

# Packages for Table Creation
#library(DT)

install_psrc_fonts()

# Inputs ---------------------------------------------------------------
setwd("C:/Users/chelmann/OneDrive - Puget Sound Regional Council/coding/rtp-dashboard")
#setwd("/home/shiny/apps/rtp-dashboard")

base_year <- "2018"
pre_covid <- "2019"
current_population_year <- "2022"

data <- read_csv("data/rtp-dashboard-data.csv") %>% mutate(year=as.character(year))

# Population Data for Text ---------------------------------------------------------
vision_pop_today <- data %>% filter(year==current_population_year & label=="Forecast Population") %>% select(estimate) %>% pull()
actual_pop_today <- data %>% filter(year==current_population_year & label=="Observed Population") %>% select(estimate) %>% pull()
population_delta <- actual_pop_today - vision_pop_today

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



#test <- create_column_chart(t=data %>% filter(concept=="Mode to Work" & geography=="Region" & label!="Total Work Trips" & year >= 2019),
#                            x="year", y="share", f="label",pos="stack", interactive = "yes",
#                            title = "Commute Mode Share",
#                            subtitle = "People over 16 who work",
#                            source="Source: U.S. Census Bureau, American Community Survey\n1-Year Estimates, table B08006 & SoundCast Output")
