library(tidyverse)
library(psrcrtp)
library(sf)

wgs84 <- 4326
current_year <- lubridate::year(Sys.Date())

# Census Commute Data -----------------------------------------------------
mode_to_work <- process_acs_data(years=c(2021))
time_to_work <- process_acs_data(years=c(2021), acs_tbl="B08303", acs_variables="commute-times")
departure_to_work <- process_acs_data(years=c(2021), acs_tbl="B08011", acs_variables="departure-time")
commute_data <- bind_rows(mode_to_work, time_to_work, departure_to_work)
rm(mode_to_work, time_to_work, departure_to_work)
saveRDS(commute_data, "C:/coding/rtp-dashboard/data/commute_data.rds")

# Safety Data -------------------------------------------------------------
fatal_collisions <- wstc_fatal_collisions(data_years=seq(10, 22, by = 1))
serious_collisions <- wsdot_serious_injury_collisions(data_file="X:/DSA/rtp-dashboard/serious_injury_data.csv")
collisions <- bind_rows(fatal_collisions, serious_collisions)
saveRDS(collisions, "X:/DSA/rtp-dashboard/processed_collision_data.rds")
collision_data <- summarise_collision_data(data_file="X:/DSA/rtp-dashboard/processed_collision_data.rds")
mpo_collisions <- process_mpo_fars_data(safety_yrs=c(seq(2010,2021,by=1)))
collision_data <- bind_rows(collision_data, mpo_collisions)
saveRDS(collision_data, "C:/coding/rtp-dashboard/data/collision_data.rds")

# Electric Vehicle Registrations by County, Region and Manufacturer ------------------------------------------------------------
total_vehicle_registrations <- all_ev_registrations()

new_vehicle_original_registrations <- new_ev_registrations(data_file="C:/coding/Vehicle_Title_Transactions.csv", 
                                                           title_type="Original Title", 
                                                           vehicle_type="New")

used_vehicle_original_registrations <- new_ev_registrations(data_file="C:/coding/Vehicle_Title_Transactions.csv", 
                                                            title_type="Original Title", 
                                                            vehicle_type="Used")

ev_manufacturers <- new_ev_models(data_file="C:/coding/Vehicle_Title_Transactions.csv")

climate_data <- bind_rows(total_vehicle_registrations, new_vehicle_original_registrations, used_vehicle_original_registrations, ev_manufacturers)
climate_data  <- climate_data  |> filter(!(variable %in% c("FCEV (Fuel Cell Electric Vehicle)", "Non-Powered")))

saveRDS(climate_data, "C:/coding/rtp-dashboard/data/ev_registrations.rds")

rm(total_vehicle_registrations, new_vehicle_original_registrations, used_vehicle_original_registrations, ev_manufacturers)

# Electric Vehicle Registrations by Census Tract --------------------------
registrations_by_tract <- ev_registrations_tract(data_file="C:/coding/Vehicle_Title_Transactions.csv",
                                                 title_type=c("Original Title"), 
                                                 vehicle_type=c("New"))

tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Census_Tracts_2020/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |>
  select(geography="geoid20")

registrations <- registrations_by_tract |> 
  filter(lubridate::year(date) == current_year & variable == "Battery Electric Vehicle") |>
  mutate(geography = as.character(geography))

tract_registrations <- left_join(tracts, registrations, by=c("geography"))

saveRDS(tract_registrations, "C:/coding/rtp-dashboard/data/ev_registration_by_tract.rds")

rm(tracts, registrations, registrations_by_tract)

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

# Shapefiles --------------------------------------------------------------
zipcodes <- st_read("C:/coding/rtp-dashboard/data/psrc_zipcodes.shp") |> st_transform(wgs84)
saveRDS(zipcodes, "C:/coding/rtp-dashboard/data/zipcodes.rds")

tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/tract2010_nowater/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson")
saveRDS(tracts, "C:/coding/rtp-dashboard/data/tracts.rds")

efa_income <- read_csv("data/efa_income_tracts.csv", show_col_types = FALSE) |> select(GEOID) |> pull()
efa_income_lyr <- tracts |> filter(GEOID10 %in% efa_income) |> st_union() |> st_sf() 
saveRDS(efa_income_lyr, "C:/coding/rtp-dashboard/data/efa_income.rds")
