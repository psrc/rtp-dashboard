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

# Packages for Map Creation
library(sf)
library(leaflet)

# Packages for Table Creation
#library(DT)

install_psrc_fonts()

# Inputs ---------------------------------------------------------------
base_year <- "2005"
pre_covid <- "2019"
current_population_year <- "2022"

wgs84 <- 4326

data <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) %>%
  #mutate(date = lubridate::mdy(date)) %>%
  mutate(data_year = as.character(lubridate::year(date)))

vmt <- read_csv("data/vmt-data.csv", show_col_types = FALSE) %>%
  mutate(date = lubridate::mdy(date)) %>%
  mutate(data_year = as.character(lubridate::year(date)))

data <- bind_rows(data, vmt)
rm(vmt)

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

vkt_data <- read_csv("data/vkt-data.csv", show_col_types = FALSE) %>% 
  mutate(plot_id=as.character(plot_id)) %>% 
  arrange(vkt)

vkt_order <- vkt_data %>% select(geography) %>% distinct %>% pull()
vkt_data <- vkt_data %>% mutate(geography = factor(x=geography, levels=vkt_order))

efa_income <- read_csv("data/efa_income_tracts.csv", show_col_types = FALSE) %>% select(GEOID) %>% pull()

zipcodes <- st_read("data/psrc_zipcodes.shp") %>% st_transform(wgs84)

tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/tract2010_nowater/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson")

# Functions ---------------------------------------------------------------
create_share_map<- function(lyr, title, colors="Blues", dec=0) {
  
  # Determine Bins
  rng <- range(lyr$share)
  max_bin <- max(abs(rng))
  round_to <- 10^floor(log10(max_bin))
  max_bin <- ceiling(max_bin/round_to)*round_to
  breaks <- (max_bin*c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1))
  bins <- c(0, breaks)
  pal <- colorBin(colors, domain = lyr$share, bins = bins)
  
  labels <- paste0("<b>",paste0(title,": "), "</b>", prettyNum(round(lyr$share*100, dec), big.mark = ","),"%") %>% lapply(htmltools::HTML)
  
  working_map <- leaflet(data = lyr) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>%
    addLayersControl(baseGroups = c("Base Map"),
                     overlayGroups = c(title,"Equity Focus Area"),
                     options = layersControlOptions(collapsed = TRUE)) %>%
    addPolygons(data = efa_tracts,
                fillColor = "#91268F",
                weight = 0,
                opacity = 0,
                color = "#91268F",
                dashArray = "1",
                fillOpacity = 0.5,
                group = "Equity Focus Area") %>% 
    addPolygons(fillColor = pal(lyr$share),
                weight = 1.0,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                highlight = highlightOptions(
                  weight =5,
                  color = "76787A",
                  dashArray ="",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto"),
                group = title) %>%
    addLegend(colors=c("#91268F"),
              labels=c("Yes"),
              group = "Equity Focus Area",
              position = "bottomright",
              title = "Equity Focus Area: Income")
  
  return(working_map)
  
}

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

mpo_transit_boardings_precovid <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Boardings" & variable=="All Transit Modes" & lubridate::year(date)==pre_covid & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_transit_boardings_precovid %>% select(geography) %>% pull()
mpo_transit_boardings_precovid <- mpo_transit_boardings_precovid %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_boardings_today <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Boardings" & variable=="All Transit Modes" & lubridate::year(date)==current_population_year & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_transit_boardings_today %>% select(geography) %>% pull()
mpo_transit_boardings_today <- mpo_transit_boardings_today %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_hours_precovid <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Revenue-Hours" & variable=="All Transit Modes" & lubridate::year(date)==pre_covid & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_transit_hours_precovid %>% select(geography) %>% pull()
mpo_transit_hours_precovid <- mpo_transit_hours_precovid %>% mutate(geography = factor(x=geography, levels=mpo_order))

mpo_transit_hours_today <- data %>% 
  filter(geography_type=="Metro Regions" & metric=="YTD Transit Revenue-Hours" & variable=="All Transit Modes" & lubridate::year(date)==current_population_year & geography!="New York City") %>%
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography %in% metros ~ "Comparable Metros")) %>%
  mutate(plot_id=replace_na(plot_id,"Other")) %>%
  arrange(estimate)

mpo_order <- mpo_transit_hours_today %>% select(geography) %>% pull()
mpo_transit_hours_today <- mpo_transit_hours_today %>% mutate(geography = factor(x=geography, levels=mpo_order))

# Population Data for Text ---------------------------------------------------------
vision_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Forecast Population") %>% select(estimate) %>% pull()
actual_pop_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Observed Population") %>% select(estimate) %>% pull()
population_delta <- actual_pop_today - vision_pop_today

# Employment Data for Text ------------------------------------------------
#vision_jobs_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Forecast Population") %>% select(estimate) %>% pull()
#actual_jons_today <- data %>% filter(lubridate::year(date)==current_population_year & variable=="Observed Population") %>% select(estimate) %>% pull()
#emoloyment_delta <- actual_pop_today - vision_pop_today

# Vehicle Registration Data for Text --------------------------------------
min_ev_date <- data %>% filter(metric=="New Vehicle Registrations" & geography=="Region") %>% select(date) %>% pull() %>% min()
max_ev_date <- data %>% filter(metric=="New Vehicle Registrations" & geography=="Region") %>% select(date) %>% pull() %>% max()

evs_previous <- 1 - (data %>% filter(metric=="New Vehicle Registrations" & geography=="Region" & date==min_ev_date & variable=="ICE (Internal Combustion Engine)") %>% select(share) %>% pull())
evs_today <- 1 - (data %>% filter(metric=="New Vehicle Registrations" & geography=="Region" & date==max_ev_date & variable=="ICE (Internal Combustion Engine)") %>% select(share) %>% pull())

ev_zips <- data %>% 
  filter(metric=="New Vehicle Registrations" & geography_type=="Zipcode" & date==max_ev_date & variable!="ICE (Internal Combustion Engine)") %>%
  select(geography, estimate, share) %>%
  group_by(geography) %>%
  summarise(estimate=sum(estimate), share=sum(share)) %>%
  as_tibble()

ev_zipcodes <- left_join(zipcodes, ev_zips, by=c("zipcode"="geography")) %>% 
  mutate(share = replace_na(share, 0)) %>%
  select(zipcode, share)

efa_tracts <- tracts %>% 
  filter(GEOID10 %in% efa_income) %>%
  st_union() %>%
  st_sf() 

# Text Data ---------------------------------------------------------------
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

employment_overview <- paste("Over the next 30 years, the central Puget Sound region will add another million jobs, reaching an employment total of 3.2 million.", 
                             "How can we ensure that all residents benefit from the region’s strong economy?",
                             "Local counties, cities, Tribes and other partners have worked together with PSRC to develop")

climate_overview_1 <- paste0("Climate change is a primary focus of VISION 2050, with a goal for the region to substantially reduce ",
                          "emissions of greenhouse gases that contribute to climate change in accordance with the goals of the ", 
                          "Puget Sound Clean Air Agency (50% below 1990 levels by 2030 and 80% below 1990 levels by 2050) ", 
                          "as well as to prepare for climate change impacts.")

climate_overview_2 <- paste0("The challenges to meeting this goal are great.", 
                             "In 1990, the region was home to approximately 2.75 million people and almost 1.37 million jobs, ",
                             "with travel of almost 62 million miles a day (an average of 22.6 miles per capita). ",
                             "By 2050, the region is expected to grow to more than 5.82 million people (more than double from 1990) ",
                             "and more than 3.16 million jobs.")

climate_overview_3 <- paste0("There are numerous solutions required to reach the regional climate goals ",
                             "– no one solution will get us there, and all are necessary for success. ",
                             "The Regional Transportation Plan includes the adopted Four-Part Greenhouse Gas Strategy, ",
                             "recognizing that decisions and investments in the categories of Land Use, Transportation Choices, ",
                             "Pricing and Technology/Decarbonization are the primary factors that influence greenhouse gas emissions ",
                             "from on-road transportation and are factors for which PSRC’s planning efforts have either direct or indirect influence. ",
                             "The plan identifies ongoing work to advance actions within each category, as well as necessary future steps to ensure full implementation.")

climate_overview_4 <- paste0("With full implementation of the Greenhouse Gas Strategy, the region is on track to achieve the climate ",
                             "goals with a forecasted -83% reduction in GHG emissions below 1990 levels by 2050. The figure below ",
                             "highlights the impacts of the various steps required to meet the regional climate goals.")

ev_registration_caption <- paste0("Decarbonization of the transporation fleet is an important part of the Four-Part Greenhouse Gas Strategy. ",
                                  "In ", lubridate::month(min_ev_date, label=TRUE, abbr = FALSE), " of ", lubridate::year(min_ev_date),
                                  " electric and hybrid vehicles made up approximately ", round(evs_previous*100,0), "% of all new vehicle registrations. ",
                                  "By ", lubridate::month(max_ev_date, label=TRUE, abbr = FALSE), " of ", lubridate::year(max_ev_date),
                                  ", electric and hybrid vehicles made up approximately ", round(evs_today*100,0), "% of all new vehicle registrations.")
ev_zipcode_caption <- paste0("Electric vehicle registrations are all the across the Puget Sound Region but some of the highest levels of ",
                              "market penetration are in the Seattle, Bellevue and Redmond area. There are noticable areas in Kitsap, Pierce and ",
                              "Snohomish counties that have lower ZEV registration levels and they tend to overlap with areas of lower incomes.")

vmt_caption <- paste0("Vehicle miles traveled peaked in the late 1990’s at around 24 miles per person per day. In 2018, the ",
                      "average miles driven per day had reduced to about 21 miles per day. Over the next thirty years, the ",
                      "average distance driven per capita is forecasted to reduce even further to approximately 18 miles per ",
                      "day per person, helping the region to contribute to goals of reducing VMT per capita.")

vmt_county_caption <- paste0("Vehicle miles driven vary greatly across the region as well as by equity focus areas. For ",
                             "example, even though the average resident of the region travels almost 18 miles per day in 2050, people of ",
                             "lower incomes travel about 15 miles per day and people living in regional growth centers travel around 7 miles per day")

vkt_caption <- paste0("Under VISION 2050, growth between 2018 and 2050 is focused near high-capacity transit stations. ",
                      "The majority of these investments are located in the VISION 2050 regional geographies of ",
                      "Metropolitan Cities, Core Cities and High-Capacity Transit Communities, the most urbanized and ",
                      "densely developed parts of the region. As shown below, driving in these places is more like many ",
                      "European countries than to other parts of the United States by 2050.")

safety_overview_1 <- paste0("Safety was one of the key policy focus areas identified by PSRC’s Transportation Policy Board early in ",
                            "the development of the RTP and is a cross-cutting issue addressed throughout all relevant sections of ",
                            "the plan. VISION 2050 set a goal for the region to have a “sustainable, equitable, affordable, safe, and ",
                            "efficient multimodal transportation system, with specific emphasis on an integrated regional transit ",
                            "network that supports the Regional Growth Strategy and promotes vitality of the economy, ",
                            "environment, and health.” In addition, VISION 2050 adopted the following policy related to safety:")

safety_overview_2 <- paste0("MPP T-4: Improve the safety of the transportation system and, in the long term, achieve the ",
                            "state’s goal of zero deaths and serious injuries.")

safety_overview_3 <- paste0("In 2019, the State of Washington adopted the Target Zero plan with the goal to reduce the number of ",
                            "traffic deaths and serious injuries on Washington's roadways to zero by the year 2030. The RTP will ",
                            "implement the region’s safety goals through a Safe Systems Approach.")

safety_overview_4 <- paste0("Safety impacts every aspect of the transportation system, covering all modes and encompassing a ",
                            "variety of attributes from facility design to security to personal behavior. The Federal Highway ",
                            "Administration (FHWA) refers to the Four E’s of safety: engineering, enforcement, education and emergency medical services.")

safety_overview_5 <- paste0("Many organizations and jurisdictions have implemented programs and projects aimed at improving ",
                            "safety and reducing deaths and serious injuries. All seek to achieve the long-term goal of zero fatalities ",
                            "and serious injuries.")


fatal_county_caption <- paste0("Trends in Fatal collisions vary across the region's counties. Although King and Kitsap counties have seen ",
                             "slight reductions in fatal collisions in 2020, there were still more fatalaities than 2015.",
                             "Pierce and Snohomich counties but experienced small increases in traffic realted deaths in 2020.")

fatal_mpo_caption <- paste0("The Puget Sound region had the fifth lowest fatal accident rate per 100,000 people in 2020 among the 27 largest MPO regions, down slightly since ",
                            "2010. Some the regions with rates lower than the PSRC region include New York and Boston. One region similar is size to PSRC with one of the lowest ",
                            "rates are the Twin Cities. The highest fatality rates amongst MPO regions are in Florida.")

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


