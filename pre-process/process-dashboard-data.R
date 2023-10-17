library(tidyverse)
library(psrcrtp)
library(sf)

wgs84 <- 4326

# Census Commute Data -----------------------------------------------------
mode_to_work <- process_acs_data(years=c(2021))
time_to_work <- process_acs_data(years=c(2021), acs_tbl="B08303", acs_variables="commute-times")
departure_to_work <- process_acs_data(years=c(2021), acs_tbl="B08011", acs_variables="departure-time")
commute_data <- bind_rows(mode_to_work, time_to_work, departure_to_work)
rm(mode_to_work, time_to_work, departure_to_work)
saveRDS(commute_data, "C:/coding/rtp-dashboard/data/commute_data.rds")
commute_data <- readRDS("C:/coding/rtp-dashboard/data/commute_data.rds")

# Safety Data -------------------------------------------------------------
fatal_collisions <- wstc_fatal_collisions(data_years=seq(10, 22, by = 1))
serious_collisions <- wsdot_serious_injury_collisions(data_file="X:/DSA/rtp-dashboard/serious_injury_data.csv")
collisions <- bind_rows(fatal_collisions, serious_collisions)
saveRDS(collisions, "X:/DSA/rtp-dashboard/processed_collision_data.rds")
collision_data <- summarise_collision_data(data_file="X:/DSA/rtp-dashboard/processed_collision_data.rds")
saveRDS(collision_data, "C:/coding/rtp-dashboard/data/collision_data.rds")

# Shapefiles --------------------------------------------------------------
zipcodes <- st_read("C:/coding/rtp-dashboard/data/psrc_zipcodes.shp") %>% st_transform(wgs84)
saveRDS(zipcodes, "C:/coding/rtp-dashboard/data/zipcodes.rds")

tracts <- st_read("https://services6.arcgis.com/GWxg6t7KXELn1thE/arcgis/rest/services/tract2010_nowater/FeatureServer/0/query?where=0=0&outFields=*&f=pgeojson")
saveRDS(tracts, "C:/coding/rtp-dashboard/data/tracts.rds")
