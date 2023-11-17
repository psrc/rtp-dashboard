library(tidyverse)
library(psrcrtp)
library(sf)

wgs84 <- 4326
current_year <- as.character(lubridate::year(Sys.Date()))
pre_covid <- 2019
metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

# NTD Transit Data --------------------------------------------------------
transit_data <- process_ntd_data()
forecast_data <- read_csv("C:/coding/rtp-dashboard/data/rtp-transit-metrics.csv", show_col_types = FALSE) |> mutate(date = lubridate::mdy(date)) |> mutate(year = as.character(year))

mpo_transit_pre_covid <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==pre_covid & grouping=="YTD") |> 
  rename(previous=estimate) |>
  select("geography", "metric", "previous")

mpo_transit_current <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==current_year & grouping=="YTD") |> 
  rename(current=estimate) 

mpo_transit <- left_join(mpo_transit_current, mpo_transit_pre_covid, by=c("geography", "metric")) |>
  mutate(estimate = current/previous) |>
  select(-"previous", -"current") |>
  filter(metric != "Revenue-Miles") |>
  mutate(grouping = "COVID Recovery") |>
  arrange(metric, estimate)

transit_data <- bind_rows(transit_data, forecast_data, mpo_transit)
saveRDS(transit_data, "C:/coding/rtp-dashboard/data/transit_data.rds")
rm(forecast_data, mpo_transit_pre_covid, mpo_transit_current, mpo_transit)
  
# Census Commute Data -----------------------------------------------------
commute_data <- process_commute_data(data_years = c(2011, 2016, 2021))
saveRDS(commute_data, "C:/coding/rtp-dashboard/data/commute_data.rds")

# Vehicle Registrations ------------------------------------------------------------
vehicle_data <- process_vehicle_registration_data(dol_registration_file="C:/coding/Vehicle_Title_Transactions.csv")
saveRDS(vehicle_data, "C:/coding/rtp-dashboard/data/vehicle_data.rds")

# Vehicle Registrations on Census Tracts for Mapping ----------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Census_Tracts_2020/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |> select(geography="geoid20")
registrations <- vehicle_data |> filter(geography_type == "Tract" & year == current_year & variable == "Battery Electric Vehicle" & grouping == "New") 
tract_registrations <- left_join(tracts, registrations, by=c("geography"))
saveRDS(tract_registrations, "C:/coding/rtp-dashboard/data/ev_registration_by_tract.rds")
rm(tracts, registrations)

# Safety Data -------------------------------------------------------------
collision_data <- process_safety_data()
saveRDS(collision_data, "C:/coding/rtp-dashboard/data/collision_data.rds")

# Shapefiles --------------------------------------------------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/tract2010_nowater/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson")
saveRDS(tracts, "C:/coding/rtp-dashboard/data/tracts.rds")

efa_income <- read_csv("data/efa_income_tracts.csv", show_col_types = FALSE) |> select(GEOID) |> pull()
efa_income_lyr <- tracts |> filter(GEOID10 %in% efa_income) |> st_union() |> st_sf() 
saveRDS(efa_income_lyr, "C:/coding/rtp-dashboard/data/efa_income.rds")

# Travel Time -------------------------------------------------------------
congested_lanes_miles <- process_npmrds_data()
saveRDS(congested_lanes_miles, "C:/coding/rtp-dashboard/data/congestion_data.rds")

# VMT Data ----------------------------------------------------------------
vmt <- read_csv("data/vmt-data.csv", show_col_types = FALSE) |>
  mutate(date = lubridate::mdy(date)) |>
  mutate(data_year = as.character(lubridate::year(date)))

saveRDS(vmt, "C:/coding/rtp-dashboard/data/vmt.rds")

vkt_data <- read_csv("data/vkt-data.csv", show_col_types = FALSE) |> 
  mutate(plot_id=as.character(plot_id), metric="Annual Kilometers per Capita", geography=str_wrap(geography, 15)) |> 
  rename(estimate = "vkt") |>
  arrange(estimate)

vkt_order <- vkt_data |> select("geography") |> distinct() |> pull()
vkt_data <- vkt_data |> mutate(geography = factor(x=geography, levels=vkt_order))

saveRDS(vkt_data, "C:/coding/rtp-dashboard/data/vkt.rds")

# People, Housing and Jobs ------------------------------------------------
pop <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) |>
  mutate(data_year = as.character(lubridate::year(date))) |>
  filter(grouping %in% c("Population") & geography == "Region") |>
  mutate(grouping = variable, variable = metric, metric = "Population") |>
  select(-"moe", -"share_moe", -"estimate_moe") |>
  mutate(variable = str_remove_all(variable, " Population"))
  
hsg <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) |>
  mutate(data_year = as.character(lubridate::year(date))) |>
  filter(variable == "Total Housing Units" & geography == "Region") |>
  mutate(variable = metric, metric = "Housing Units") |>
  select(-"moe", -"share_moe", -"estimate_moe")

jobs <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) |>
  mutate(data_year = as.character(lubridate::year(date))) |>
  filter(grouping=="Total Employment" & geography == "Region") |>
  mutate(grouping = variable, variable = metric, metric = "Jobs") |>
  select(-"moe", -"share_moe", -"estimate_moe") |>
  mutate(variable = str_remove_all(variable, " Employment"))

pop_hsg_jobs <- bind_rows(pop, hsg, jobs) |> mutate(metric = factor(x=metric, levels = c("Population", "Housing Units",  "Jobs")))
rm(pop, hsg, jobs)

saveRDS(pop_hsg_jobs, "C:/coding/rtp-dashboard/data/pop_hsg_jobs.rds")

# Growth Near HCT ---------------------------------------------------------
hct <- read_csv("data/rtp-dashboard-data.csv", show_col_types = FALSE) |>
  mutate(data_year = as.character(lubridate::year(date))) |>
  filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area") |>
  mutate(grouping=variable, variable = "HCT Growth", geography = "Near HCT") |>
  select(-"moe", -"share_moe", -"estimate_moe") 

hct_total_jobs <- data |> 
  filter(metric=="Total Employment", variable=="Inside HCT Area") |>
  mutate(grouping="Total", variable = "HCT Growth", geography = "Near HCT", metric = "Jobs", geography_type = "Region") |>
  select(-"moe", -"share_moe", -"estimate_moe") 

total_job_change <- data %>% filter(metric=="Total Employment", variable=="Region") |>
  mutate(total = (estimate-lag(estimate))) |>
  select(date, data_year, geography, total)

hct_job_change <- data %>% filter(metric=="Total Employment", variable=="Inside HCT Area") |>
  mutate(hct = (estimate-lag(estimate))) |>
  select(date, data_year, geography, hct)

job_change <- left_join(total_job_change, hct_job_change, by=c("date","data_year", "geography")) |>
  mutate(share=hct/total) |>
  rename(estimate=hct) |>
  mutate(variable = "HCT Growth", geography_type="Region", metric="Jobs", grouping="Change", geography="Near HCT") |>
  select(-total) |>
  drop_na()

hct <- bind_rows(hct, hct_total_jobs, job_change)
rm(hct_total_jobs, total_job_change, hct_job_change, job_change)
hct <- hct |> mutate(metric = factor(x=metric, levels = c("Population", "Housing Units",  "Jobs")))

saveRDS(hct, "C:/coding/rtp-dashboard/data/hct.rds")

