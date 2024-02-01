library(tidyverse)
library(usethis)
library(psrcrtp)
library(sf)
library(here)

wgs84 <- 4326
current_year <- "2023"
pre_covid <- 2019
metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

rtp_network_url <- "X:/DSA/rtp-dashboard/"
rtp_local_url <- "C:/coding/"
rtp_dashboard_url <- "C:/coding/rtp-dashboard/data/"

# NTD Transit Data --------------------------------------------------------
transit_data <- process_ntd_data()
forecast_data <- read_csv(here(rtp_network_url, "PSRC/rtp-transit-metrics.csv"), show_col_types = FALSE) |> mutate(date = lubridate::mdy(date)) |> mutate(year = as.character(year))

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
saveRDS(transit_data, here(rtp_dashboard_url, "transit_data.rds"))
rm(forecast_data, mpo_transit_pre_covid, mpo_transit_current, mpo_transit)
  
# Census Commute Data -----------------------------------------------------
commute_data <- process_commute_data(data_years = c(2012, 2017, 2022))
saveRDS(commute_data, here(rtp_dashboard_url, "commute_data.rds"))

# Vehicle Registrations ------------------------------------------------------------
vehicle_data <- process_vehicle_registration_data(dol_registration_file=here(rtp_local_url, "Vehicle_Title_Transactions.csv"))
vehicle_data <- vehicle_data |> filter(variable != "Non-Powered")|> filter(variable != "FCEV (Fuel Cell Electric Vehicle)")
saveRDS(vehicle_data, here(rtp_dashboard_url, "vehicle_data.rds"))

# Vehicle Registrations on Census Tracts for Mapping ----------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Census_Tracts_2020/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |> select(geography="geoid20")
registrations <- vehicle_data |> filter(geography_type == "Tract" & year == "2023" & variable == "Battery Electric Vehicle" & grouping == "New") 
tract_registrations <- left_join(tracts, registrations, by=c("geography"))
saveRDS(tract_registrations, here(rtp_dashboard_url, "ev_registration_by_tract.rds"))
rm(tracts, registrations)

# Safety Data -------------------------------------------------------------
collision_data <- process_safety_data()
saveRDS(collision_data, here(rtp_dashboard_url, "collision_data.rds"))

# Shapefiles --------------------------------------------------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/tract2010_nowater/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson")
saveRDS(tracts, here(rtp_dashboard_url, "tracts.rds"))

efa_income <- read_csv(here(rtp_network_url,"PSRC/efa_income_tracts.csv"), show_col_types = FALSE) |> select(GEOID) |> pull()
efa_income_lyr <- tracts |> filter(GEOID10 %in% efa_income) |> st_union() |> st_sf() 
saveRDS(efa_income_lyr, here(rtp_dashboard_url, "efa_income.rds"))

# Travel Time -------------------------------------------------------------
congested_lanes_miles <- process_npmrds_data()
saveRDS(congested_lanes_miles, here(rtp_dashboard_url, "congestion_data.rds"))

congestion_map_data <- map_npmrds_data()
saveRDS(congestion_map_data, here(rtp_dashboard_url, "congestion_map_data.rds"))

# VMT Data ----------------------------------------------------------------
vmt <- read_csv(here(rtp_network_url, "PSRC/vmt-data.csv"), show_col_types = FALSE) |>
  mutate(date = lubridate::mdy(date)) |>
  mutate(data_year = as.character(lubridate::year(date)))

saveRDS(vmt, here(rtp_dashboard_url, "vmt.rds"))

vkt_data <- read_csv(here(rtp_network_url, "PSRC/vkt-data.csv"), show_col_types = FALSE) |> 
  mutate(plot_id=as.character(plot_id), metric="Annual Kilometers per Capita", geography=str_wrap(geography, 15)) |> 
  rename(estimate = "vkt") |>
  arrange(estimate)

vkt_order <- vkt_data |> select("geography") |> distinct() |> pull()
vkt_data <- vkt_data |> mutate(geography = factor(x=geography, levels=vkt_order))

saveRDS(vkt_data, here(rtp_dashboard_url, "vkt.rds"))

# People, Housing and Jobs ------------------------------------------------
pop <- regional_population_data() |> filter(!(variable == "Forecast" & year <2018) & grouping == "Total")
hsg <- regional_housing_data() |> filter(!(variable == "Forecast" & year <2018) & grouping == "Total")
jobs <- jobs_data() |> filter(grouping == "Total" & !(variable == "Forecast" & year <2018))
jobs_hct <- jobs_near_hct() |> filter(grouping == "Change" & variable == "in station area")
pop_hsg_hct <- pop_hsg_near_hct() |> filter(grouping == "Change" & variable == "in station area")

pop_hsg_jobs <- bind_rows(pop_hsg_hct, jobs_hct, pop, hsg, jobs) |> 
  mutate(metric = factor(x=metric, levels = c("Population", "Housing Units",  "Jobs", "Population near HCT", "Housing Units near HCT", "Jobs near HCT")))

saveRDS(pop_hsg_jobs, here(rtp_dashboard_url, "pop_hsg_jobs.rds"))

# Project Data ------------------------------------------------------------
funding_ord <- c("Yes", "No")
stp_buckets <- c("center", "access", "equity", "safety", "climate", "readiness")
cmaq_buckets <- c("center", "access", "equity", "safety", "climate", "waehd", "readiness")

projects <- read_csv(here(rtp_network_url, "PSRC/fhwa_scoring.csv"), show_col_types = FALSE)
projects_lyr <- st_read(here(rtp_network_url, "PSRC/2022_FHWA_regional_mapped_revised.shp")) |> st_transform(crs = wgs84) 

stp <- projects |> 
  filter(process=="STP") |> 
  select(-"waehd") |>
  pivot_wider(names_from = funded, values_from = all_of(stp_buckets)) |>
  arrange(desc(project_id)) |>
  mutate(project_id = as.character(project_id))

cmaq <- projects |> 
  filter(process=="CMAQ") |> 
  pivot_wider(names_from = funded, values_from = all_of(cmaq_buckets)) |>
  arrange(desc(project_id)) |>
  mutate(project_id = as.character(project_id))

prj_lyr <- left_join(projects_lyr, projects, by=c("process", "project_id")) |> select("process", "project_id", "sponsor", "title", "description", "funding_request", "funded")
cmaq_lyr <- prj_lyr |> filter(process == "CMAQ")
stp_lyr <- prj_lyr |> filter(process == "STP")

saveRDS(stp, here(rtp_dashboard_url, "stp.rds"))
saveRDS(cmaq, here(rtp_dashboard_url, "cmaq.rds"))
saveRDS(stp_lyr, here(rtp_dashboard_url, "stp_lyr.rds"))
saveRDS(cmaq_lyr, here(rtp_dashboard_url, "cmaq_lyr.rds"))

# TIP Data ----------------------------------------------------------------
bike_ped_projects <- c("Sidewalk", "Bike Lanes", "Regional Trail (Separate Facility)", "Non-Regional Trail (Separate Facility)", "Other -- nonmotorized")
its_projects <- c("ITS")
transit_projects <-c("Other -- Transit", "Transit Center or Station -- new or expansion", "New/Relocated Transit Alignment", "Service Expansion", "Operations -- Transit", 
                     "Transit Center or Station -- maintenance", "Park and Ride (new facility or expansion)")
ferry_projects <- c("New/Relocated/Expanded terminal", "Terminal preservation", "Other -- Ferry" )
preservation_projects <- c("Preservation/Maintenance/Reconstruction", "Resurfacing")
bridge_projects <- c("Bridge Rehabilitation", "Bridge Replacement", "New Bridge or Bridge Widening")
roadway_projects <- c("Minor Interchange -- GP", "Major Widening -- GP", "New Facility -- Roadway", "Minor Widening -- Nonmodelable",  
                      "Major Interchange -- GP", "Other -- Roadway", "Major Widening -- HOV", "Minor Widening -- Modelable", "Relocation -- Roadway")
intersection_projects <-c("Single Intersection -- Roadway", "Multiple Intersections -- Roadway")
safety_projects <- c("Safety -- Roadway")
other_projects  <-c("Study or Planning Activity", "Environmental Improvement -- Roadway", "Other -- Special")

tip_lyr <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/TIP_Projects/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |>
  select(`TIP ID`="ProjNo", Sponsor="PlaceShort", Description="ProjDesc", `Estimated Completion Year`="EstComplet", `Total Project Cost`="TotCost", `Project Type`="ImproveTyp", "Phase", `Funding Type`="FedFundSou", `Federal Funding`="FedFundAmo", `State Funding`="StateFundA", `Local Funding`="LocalFundA", `Projected Obligation Date`="ObYear") |>
  mutate(Projects = case_when(
    `Project Type` %in% bike_ped_projects ~ "Pedestrian / Bicycle",
    `Project Type` %in% its_projects ~ "ITS",
    `Project Type` %in% transit_projects ~ "Transit",
    `Project Type` %in% ferry_projects ~ "Ferry",
    `Project Type` %in% preservation_projects ~ "Roadway Preservation",
    `Project Type` %in% bridge_projects ~ "Bridges",
    `Project Type` %in% roadway_projects ~ "Roadways",
    `Project Type` %in% intersection_projects ~ "Intersections",
    `Project Type` %in% safety_projects ~ "Safety",
    `Project Type` %in% other_projects ~ "Other")) |>
  mutate(`Total Project Cost` = as.integer(`Total Project Cost`))

tip_projects_by_type <- tip_lyr |> 
  st_drop_geometry() |>
  drop_na() |>
  mutate(`Total Projects` = 1) |>
  mutate(`Federal Project` = case_when(
    `Federal Funding`==0 ~0, 
    `Federal Funding` >0 ~1)) |>
  mutate(`State Project` = case_when(
    `State Funding`==0 ~0, 
    `State Funding` >0 ~1)) |>
  mutate(`Local Project` = case_when(
    `Local Funding`==0 ~0, 
    `Local Funding` >0 ~1)) |>
  group_by(Projects) |>
  summarise(`Total Cost` = sum(`Total Project Cost`),
            `Total Projects` = sum(`Total Projects`),
            `Federal Funding` = sum(`Federal Funding`),
            `Federal Project` = sum(`Federal Project`),
            `State Funding` = sum(`State Funding`),
            `State Project` = sum(`State Project`),
            `Local Funding` = sum(`State Funding`),
            `Local Project` = sum(`Local Project`)) |>
  as_tibble()

saveRDS(tip_lyr, here(rtp_dashboard_url, "tip_lyr.rds"))
saveRDS(tip_projects_by_type, here(rtp_dashboard_url, "tip_projects_by_type.rds"))
