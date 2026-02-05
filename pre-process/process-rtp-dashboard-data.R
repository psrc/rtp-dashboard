library(tidyverse)
library(psrccensus)
library(psrcrtp)
library(psrcelmer)
library(tidycensus)
library(sf)
library(here)

wgs84 <- 4326
current_year <- "2024"

pre_covid <- 2019
current_ntd_year <- "2025"

acs_data_yrs <- c(2014, 2019, 2024)
pums_data_yrs <- c(2014, 2019, 2023)

metros <- c("Portland", "Bay Area", "San Diego", "Denver", "Atlanta","Washington DC", "Boston", "Miami" ,"Phoenix", "Austin", "Dallas")

rtp_network_url <- "X:/DSA/rtp-dashboard/"
rtp_local_url <- "C:/Users/chelmann/OneDrive - Puget Sound Regional Council/coding"
rtp_dashboard_url <- "C:/Users/chelmann/OneDrive - Puget Sound Regional Council/coding/rtp-dashboard/data"

# Functions ---------------------------------------------------------------

acs_data <- function(years=c(2024), acs_tbl="B08301", acs_variables="commute-modes") {
  
  # Always use ACS 5yr data since we need it for places, tracts and MPO comparisons as well as 2020 data
  acs_type <- 'acs5'
  
  # Columns to keep from Tidy Census Pull
  cols_to_keep <- c("name", "variable", "estimate", "moe", "census_geography", "year")
  
  # Variables for dashboard
  variables <- read_csv(system.file('extdata', paste0(acs_variables,".csv"), package='psrcrtp'), show_col_types = FALSE)
  
  working_data <- NULL
  for (y in years) {
    print(str_glue("Working on {y}"))
    
    # County & Region data for PSRC region
    # Download the Data
    county_data <- get_acs_recs(geography = 'county', table.names = acs_tbl, years=y, acs.type = acs_type) 
    # Variables of interest
    county_data <- county_data |> filter(.data$variable %in% unique(variables$variable))
    # Clean up columns
    county_data <- county_data |> select(all_of(cols_to_keep))
    # Add labels
    county_data <- left_join(county_data, variables, by=c("variable"))
    # Consolidate rows based on simple labels
    county_data <- county_data |> 
      group_by(.data$name, .data$census_geography, .data$year, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label")
    # Get totals
    total <- county_data |>filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    county_data <- left_join(county_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    rm(total)
    
    # Cities in the PSRC region
    # Download the Data
    city_data <- get_acs(state = "53", geography = 'place', table = acs_tbl, year=y, survey = acs_type) 
    psrc_places <- get_psrc_places(y) |> st_drop_geometry()
    place_FIPS <- unique(psrc_places$GEOID)
    
    city_data <- city_data |> filter(GEOID %in% place_FIPS) |>
      filter(!(str_detect(NAME, "CDP"))) |>
      mutate(NAME = str_remove_all(NAME, " city, Washington")) |>
      mutate(NAME = str_remove_all(NAME, " town, Washington")) |>
      rename(name = "NAME") |>
      mutate(year = y, census_geography = "City")
    
    # Variables of interest
    city_data <- city_data |> filter(.data$variable %in% unique(variables$variable))
    # Clean up columns
    city_data <- city_data |> select(all_of(cols_to_keep))
    # Add labels
    city_data <- left_join(city_data, variables, by=c("variable"))
    # Consolidate rows based on simple labels
    city_data <- city_data |> 
      group_by(.data$name, .data$census_geography, .data$year, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label")
    # Get totals
    total <- city_data |> filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    city_data <- left_join(city_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    rm(total)
    
    # Metro Areas
    mpo <- read_csv(system.file('extdata', 'regional-councils-counties.csv', package='psrcrtp'), show_col_types = FALSE) |> 
      mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY_FIPS, width=3, side=c("left"), pad="0")) |>
      mutate(STATE_FIPS=stringr::str_pad(.data$STATE_FIPS, width=2, side=c("left"), pad="0")) |>
      mutate(GEOID = paste0(.data$STATE_FIPS,.data$COUNTY_FIPS))
    
    states <- mpo |> select("STATE_FIPS") |> distinct() |> pull()
    counties <- mpo |> select("GEOID") |> distinct() |>pull()
    
    mpo_data <- NULL
    for (st in states) {
      c <- mpo |> filter(.data$STATE_FIPS %in% st) |> select("COUNTY_FIPS") |> pull()
      d <- get_acs(geography = "county", state=st, county=c, table = acs_tbl, year = y, survey = acs_type)
      ifelse(is.null(mpo_data), mpo_data <- d, mpo_data <- bind_rows(mpo_data,d))
      rm(c, d)
    }
    
    # Variables of interest
    mpo_data <- mpo_data |> filter(.data$variable %in% unique(variables$variable))
    # Add labels
    mpo_data <- left_join(mpo_data, variables, by=c("variable"))
    # Add in MPO Information
    mpo_county_data <- left_join(mpo, mpo_data, by="GEOID", multiple = "all")
    # Consolidate rows based on simple labels
    mpo_county_data <- mpo_county_data |> 
      group_by(.data$MPO_AREA, .data$simple_label) |>
      summarise(estimate = sum(.data$estimate), moe = moe_sum(moe=.data$moe, estimate=.data$estimate)) |>
      as_tibble() |>
      rename(label = "simple_label", name = "MPO_AREA") |>
      mutate(year=y, census_geography="Metro Areas")
    # Get totals
    total <- mpo_county_data |> filter(.data$label == "Total") |> select("name", total="estimate")
    # Get Shares
    mpo_county_data <- left_join(mpo_county_data, total, by=c("name")) |> mutate(share=.data$estimate/.data$total) |> select(-"total")
    mpo_data <- mpo_county_data
    rm(total, mpo_county_data)
    
    d <- bind_rows(county_data, city_data, mpo_data)
    
    if(is.null(working_data)) {working_data <- d} else {working_data <- bind_rows(working_data, d)}
    
  }
  
  # Match column names to rtp-dashboard inputs
  working_data <- working_data |> 
    mutate(date=mdy(paste0("12-01-",.data$year)), grouping="All", metric=acs_variables) |>
    mutate(year = as.character(year(.data$date))) |>
    select("year", "date", geography="name", geography_type="census_geography", variable="label", "grouping", "metric", "estimate", "share", "moe")
  
  return(working_data)
}

process_acs_data <- function(data_years = c(2021)) {
  
  print("Working on Mode to Work")
  mw <- acs_data(years=data_years, acs_tbl="B08301", acs_variables="commute-modes")
  print("Working on Travel time to Work")
  tw <- acs_data(years=data_years, acs_tbl="B08303", acs_variables="commute-times")
  print("Working on Departure time to work")
  dw <- acs_data(years=data_years, acs_tbl="B08011", acs_variables="departure-time")

  processed <- bind_rows(mw, tw, dw)
  
  return(processed)
  
}

# Vehicle Registrations ------------------------------------------------------------
vehicle_data <- process_vehicle_registration_data(dol_registration_file=here(rtp_local_url, "Vehicle_Title_Transactions.csv"))

vehicle_data <- vehicle_data |> 
  filter(variable != "Non-Powered") |> 
  filter(variable != "FCEV (Fuel Cell Electric Vehicle)") |> 
  filter(variable != "Not Applicable") |> 
  drop_na() 

region_type <- vehicle_data |>
  filter(geography_type == "Region" & metric == "vehicle-registrations") |>
  group_by(year, variable) |>
  summarise(estimate = sum(estimate)) |>
  as_tibble()

region_total <- vehicle_data |>
  filter(geography_type == "Region" & metric == "vehicle-registrations") |>
  group_by(year) |>
  summarise(total = sum(estimate)) |>
  as_tibble()

region_registrations <- left_join(region_type, region_total, by = c("year")) |>
  mutate(share = estimate / total) |>
  select(-"total") |>
  mutate(date = mdy(paste0("12-01-",year)), geography = "Region", geography_type = "Region", grouping = "New & Used", metric = "title-transactions") 

vehicle_data <- bind_rows(vehicle_data, region_registrations)
saveRDS(vehicle_data, here(rtp_dashboard_url, "vehicle_data.rds"))
rm(region_type, region_total, region_registrations)

# Vehicle Registrations on Census Tracts for Mapping ----------------------
tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/Census_Tracts_2020/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson") |> select(geography="geoid20")
registrations <- vehicle_data |> filter(geography_type == "Tract" & year == "2025" & variable == "Battery Electric Vehicle" & grouping == "New") 
tract_registrations <- left_join(tracts, registrations, by=c("geography"))
saveRDS(tract_registrations, here(rtp_dashboard_url, "ev_registration_by_tract.rds"))
rm(tracts, registrations)

# VMT Data ----------------------------------------------------------------
vmt <- read_csv(here(rtp_network_url, "PSRC/vmt-data.csv"), show_col_types = FALSE) |>
  mutate(date = lubridate::mdy(date)) |>
  mutate(year = lubridate::year(date))

saveRDS(vmt, here(rtp_dashboard_url, "vmt.rds"))

vkt_data <- read_csv(here(rtp_network_url, "PSRC/vkt-data.csv"), show_col_types = FALSE) |> 
  mutate(plot_id=as.character(plot_id), metric="Annual Kilometers per Capita", geography=str_wrap(geography, 15)) |> 
  rename(estimate = "vkt") |>
  arrange(estimate)

vkt_order <- vkt_data |> select("geography") |> distinct() |> pull()
vkt_data <- vkt_data |> mutate(geography = factor(x=geography, levels=vkt_order))

saveRDS(vkt_data, here(rtp_dashboard_url, "vkt.rds"))

# Census Commute Data -----------------------------------------------------
acs_commute_data <- process_acs_data(data_years = acs_data_yrs)
pums_commute_data <- process_pums_data(pums_yr = pums_data_yrs)
commute_data <- bind_rows(acs_commute_data, pums_commute_data)

jurisdictions <- get_table(schema='Political', tbl_name='jurisdiction_dims')

jurisdictions <- jurisdictions |>
  mutate(juris_name = str_replace_all(juris_name, "Seatac", "SeaTac")) |>
  mutate(juris_name = str_replace_all(juris_name, "Beau Arts Village","Beaux Arts Village")) |>
  select("juris_name", "regional_geography") |>
  distinct() |>
  mutate(regional_geography=str_replace_all(regional_geography, "HCT", "High Capacity Transit Community")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "Metro", "Metropolitan Cities")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "Core", "Core Cities")) |>
  mutate(regional_geography=str_replace_all(regional_geography, "CitiesTowns", "Cities & Towns")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. King", "King County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Kitsap", "Kitsap County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Pierce", "Pierce County")) |>
  mutate(juris_name = str_replace_all(juris_name, "Uninc. Snohomish", "Snohomish County")) |>
  rename(Municipality = "juris_name", `Regional Geography` = "regional_geography")

metro <- jurisdictions |> filter(`Regional Geography` == "Metropolitan Cities") |> select("Municipality") |>pull() |> unique()
core <- jurisdictions |> filter(`Regional Geography` == "Core Cities") |> select("Municipality") |>pull() |> unique()
hct <- jurisdictions |> filter(`Regional Geography` == "High Capacity Transit Community") |> select("Municipality") |>pull() |> unique()
cities <- jurisdictions |> filter(`Regional Geography` == "Cities & Towns") |> select("Municipality") |>pull() |> unique()

commute_data <- commute_data |>
  mutate(plot_id = case_when(
    geography_type %in% c("County", "Region") ~ "PSRC Region",
    geography_type == "City" & geography %in% metro ~ "Metro City",
    geography_type == "City" & geography %in% core ~ "Core City",
    geography_type == "City" & geography %in% hct ~ "HCT City",
    geography_type == "City" & geography %in% cities ~ "Cities & Towns",
    geography_type == "Metro Areas" & geography == "Seattle" ~ "PSRC",
    geography_type == "Metro Areas" & geography != "Seattle" ~ "Other MPO",
    geography_type == "Race" ~ grouping)) |>
  filter(!(is.na(geography)))

saveRDS(commute_data, here(rtp_dashboard_url, "commute_data.rds"))
rm(acs_commute_data, pums_commute_data, jurisdictions)

# NTD Transit Data --------------------------------------------------------
transit_data <- process_ntd_data()

forecast_data <- read_csv(here(rtp_network_url, "PSRC/rtp-transit-metrics.csv"), show_col_types = FALSE) |> mutate(date = lubridate::mdy(date)) |> mutate(year = as.character(year))

mpo_transit_pre_covid <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==pre_covid & grouping=="YTD") |> 
  rename(previous=estimate) |>
  select("geography", "metric", "previous")

mpo_transit_current <- transit_data |> 
  filter(geography_type=="Metro Areas" & variable=="All Transit Modes" & year==current_ntd_year & grouping=="YTD") |> 
  rename(current=estimate) 

mpo_transit <- left_join(mpo_transit_current, mpo_transit_pre_covid, by=c("geography", "metric")) |>
  mutate(estimate = current/previous) |>
  select(-"previous", -"current") |>
  filter(metric != "Revenue-Miles") |>
  mutate(grouping = "COVID Recovery") |>
  arrange(metric, estimate)

transit_data <- bind_rows(transit_data, forecast_data, mpo_transit) |> 
  mutate(year = as.numeric(year)) |>
  mutate(plot_id = case_when(
    geography_type == "Metro Areas" & geography == "Seattle" ~ "PSRC",
    geography_type == "Metro Areas" & geography != "Seattle" ~ "Other MPO",
    TRUE ~ "PSRC Region"))

saveRDS(transit_data, here(rtp_dashboard_url, "transit_data.rds"))
rm(forecast_data, mpo_transit_pre_covid, mpo_transit_current, mpo_transit)
  


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
