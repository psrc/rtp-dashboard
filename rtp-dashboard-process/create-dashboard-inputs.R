library(tidyverse)
library(sf)
library(here)
library(forcats)
library(colorspace)

wgs84 <- 4326

# Model Mode Share Results ------------------------------------------------
wfh_2050 <- 0.208
transit_2050 <- 0.052
bike_2050 <- 0.018
walk_2050 <- 0.151

# Mode Travel Time Results ------------------------------------------------
tt_2050 <- 23.3
dt_2050 <- .300
cong_2050 <- 0.48

# Federal Performance Targets ---------------------------------------------
phed <- 28
non_sov <- 0.368
interstate <- 72.5
non_interstate <- 88.4
trucks <- 1.53

# Years -------------------------------------------------------------------
earliest_year <- 2010
current_registration_year <- 2025
current_vmt_year <- 2024
rtp_base_year <- 2023
pre_covid <- 2019

climate_base_year <- 1990
climate_vision_year <- 2018
climate_current_year <- 2024
climate_horizon_year <- 2050

census_base_year <- 2014
census_vision_year <- 2019
census_current_year <- 2024
census_horizon_year <- 2050

pums_base_year <- 2014
pums_vision_year <- 2019
pums_current_year <- 2024
pums_horizon_year <- 2050

transit_base_year <- 2014
transit_vision_year <- 2019
transit_current_year <- 2025
transit_horizon_year <- 2050

growth_base_year <- 2010
growth_vision_year <- 2018
growth_current_year <- 2025
growth_horizon_year <- 2050

safety_base_year <- 2010
safety_vision_year <- 2015
safety_current_year <- 2019
safety_horizon_year <- 2024
safety_mpo_year <- 2023

congestion_base_year <- 2019
congestion_vision_year <- 2022
congestion_current_year <- 2026
congestion_horizon_year <- 2050

federal_base_year <- 2018
federal_vision_year <- 2021
federal_current_year <- 2023
federal_horizon_year <- 2025

congestion_month <- "01"

rtp_dashboard_process_url <- "C:/Users/chelmann/OneDrive - PSRC/coding/rtp-dashboard/rtp-dashboard-process/data"
rtp_dashboard_data_url <- "C:/Users/chelmann/OneDrive - PSRC/coding/rtp-dashboard/rtp-dashboard/data"

vehicle_ord <- c("Battery Electric Vehicle", "Hybrid Electric Vehicle", "Plug-in Hybrid Electric Vehicle", "Internal Combustion Engine")
forecast_ord <- c("Annual", "Observed", "Forecast")
county_ord <- c("King", "Kitsap", "Pierce", "Snohomish", "Region")

# Color Palette -----------------------------------------------------------

agency_palette <- c(
  "Battery Electric Vehicle"   = "#91268F",
  "Hybrid Electric Vehicle" = "#8CC63E",
  "Plug-in Hybrid Electric Vehicle"     = "#00A7A0",
  "Internal Combustion Engine"   = "#F05A28",
  "Observed" = "#91268F",
  "Annual" = "#00A7A0",
  "Forecast" = "#F05A28",
  "in station area" = "#91268F",
  "Traffic Related Deaths" = "#F05A28",
  "Serious Injury" = "#91268F",
  "Biking" = "#8CC63E",
  "Motor Vehicle" = "#00A7A0",
  "Walking" = "#F05A28",
  "after 6pm" = "#8CC63E",
  "before 6pm" = "#00A7A0",
  "Fri-Sat" = "#8CC63E",
  "Sun-Thu" = "#00A7A0"
)

#c("#8CC63E", "#F05A28", "#00A7A0","#999999", "#91268F")

# Relative luminance
rel_luminance <- function(hex) {
  rgb <- hex2RGB(hex)@coords
  f <- function(x) ifelse(x <= 0.03928, x / 12.92, ((x + 0.055) / 1.055)^2.4)
  rgb <- f(rgb)
  0.2126 * rgb[,1] + 0.7152 * rgb[,2] + 0.0722 * rgb[,3]
}

contrast_ratio <- function(hex1, hex2) {
  l1 <- rel_luminance(hex1)
  l2 <- rel_luminance(hex2)
  (pmax(l1, l2) + 0.05) / (pmin(l1, l2) + 0.05)
}

enforce_wcag <- function(
    palette,
    background = "#FFFFFF",
    min_ratio = 3
) {
  
  sapply(palette, function(col) {
    
    ratio <- contrast_ratio(col, background)
    if (ratio >= min_ratio) return(col)
    
    # Try darkening first
    for (amt in seq(0.05, 0.6, by = 0.05)) {
      darker <- darken(col, amt)
      if (contrast_ratio(darker, background) >= min_ratio)
        return(darker)
    }
    
    # Fallback: lighten
    for (amt in seq(0.05, 0.6, by = 0.05)) {
      lighter <- lighten(col, amt)
      if (contrast_ratio(lighter, background) >= min_ratio)
        return(lighter)
    }
    
    col
  })
}

wcag_palette <- enforce_wcag(agency_palette)
saveRDS(wcag_palette, here(rtp_dashboard_data_url, "wcag_palette.rds"))

# Processed Data via RDS files ------------------------------------------------------
vehicle_data <- readRDS(here(rtp_dashboard_process_url, "vehicle_data.rds"))
ev_by_tract <- readRDS(here(rtp_dashboard_process_url, "ev_registration_by_tract.rds"))
vmt_data <- readRDS(here(rtp_dashboard_process_url, "vmt.rds"))
vkt_data <- readRDS(here(rtp_dashboard_process_url, "vkt.rds"))
commute_data <- readRDS(here(rtp_dashboard_process_url, "commute_data.rds"))
transit_data <- readRDS(here(rtp_dashboard_process_url, "transit_data.rds"))
pop_hsg_jobs_data <- readRDS(here(rtp_dashboard_process_url, "pop_hsg_jobs.rds"))
collision_data <- readRDS(here(rtp_dashboard_process_url, "collision_data.rds"))
congestion_data <- readRDS(here(rtp_dashboard_process_url, "congestion_data.rds"))
congestion_map_data <- readRDS(here(rtp_dashboard_process_url, "congestion_map_data.rds"))

# Pre-Processed Data for Climate: ZEV -------------------------------------------
bev <- paste0(round((vehicle_data |> 
                       filter(metric == "title-transactions" & year == current_registration_year) |> 
                       filter(variable == "Battery Electric Vehicle") |> 
                       select("share") |> pull())*100, 1), "%")

hev <- paste0(round((vehicle_data |> 
                       filter(metric == "title-transactions" & year == current_registration_year) |> 
                       filter(variable == "Hybrid Electric Vehicle") |> 
                       select("share") |> pull())*100, 1), "%")

phev <- paste0(round((vehicle_data |> 
                        filter(metric == "title-transactions" & year == current_registration_year) |> 
                        filter(variable == "Plug-in Hybrid Electric Vehicle") |> 
                        select("share") |> pull())*100, 1), "%")

ic <- paste0(round((vehicle_data |> 
                      filter(metric == "title-transactions" & year == current_registration_year) |> 
                      filter(variable == "Internal Combustion Engine") |> 
                      select("share") |> pull())*100, 1), "%")

registration_box_values <- list(c(bev, paste(current_registration_year, "Electric Vehicle share of all title transactions")), 
                                c(hev, paste(current_registration_year, "Hybrid Vehicle share of all title transactions")), 
                                c(phev, paste(current_registration_year, "Plug-In Hybrid Vehicle share of all title transactions")), 
                                c(ic, paste(current_registration_year, "Gas or Diesel Vehicle share of all title transactions")))

vehicle_registration_chart_data <- vehicle_data |>
  filter(year >= earliest_year) |>
  filter(variable %in% vehicle_ord) |>
  filter(geography == "Region") |>
  filter(metric == "vehicle-registrations") |>
  select(x = "year", y = "estimate", f = "variable", c = "grouping") |>
  group_by(x,f,c) |>
  summarise(y = sum(y)) |>
  as_tibble()
  
t <- vehicle_registration_chart_data |>
  group_by(x, c) |>
  summarise(total = sum(y)) |>
  as_tibble()

vehicle_registration_chart_data <- left_join(vehicle_registration_chart_data, t, by=c("x", "c")) |>
  mutate(y = y / total) |>
  select(-"total") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%")) |>
  mutate(f = factor(f, levels = vehicle_ord))
  
rm(t)  
  
tract_ev_share <- ev_by_tract |>
  mutate(share = replace_na(share, 0))

saveRDS(registration_box_values, here(rtp_dashboard_data_url, "registration_box_values.rds"))  
saveRDS(vehicle_registration_chart_data, here(rtp_dashboard_data_url, "vehicle_region_data.rds"))
saveRDS(tract_ev_share, here(rtp_dashboard_data_url, "tract_ev_data.rds"))

# Pre-Processed Data for Climate: VMT -------------------------------------
base <- paste0(round((vmt_data |> 
                        filter(geography == "Region" & variable == "Observed" & year == climate_base_year & grouping == "per Capita") |> 
                        select("estimate") |> pull()), 1))

vision <- paste0(round((vmt_data |> 
                          filter(geography == "Region" & variable == "Observed" & year == climate_vision_year & grouping == "per Capita") |> 
                          select("estimate") |> pull()), 1))

current <- paste0(round((vmt_data |> 
                           filter(geography == "Region" & variable == "Observed" & year == climate_current_year & grouping == "per Capita") |> 
                           select("estimate") |> pull()), 1))

horizon <- paste0(round((vmt_data |> 
                           filter(geography == "Region" & variable == "Forecast" & year == climate_horizon_year & grouping == "per Capita") |> 
                           select("estimate") |> pull()), 1))

vmt_box_values <- list(c(base, paste(climate_base_year, "daily vehicle miles per capita")), 
                       c(vision, paste(climate_vision_year, "daily vehicle miles per capita")),
                       c(current, paste(climate_current_year, "daily vehicle miles per capita")), 
                       c(horizon, paste(climate_horizon_year, "RTP forecasted daily vehicle miles per capita")))

vmt_region_data <- vmt_data |>
  filter(year >= 2000) |>
  filter(!(year < rtp_base_year & variable == "Forecast")) |>
  filter(variable %in% forecast_ord) |>
  filter(geography == "Region") |>
  filter(metric == "Vehicle Miles Traveled") |>
  select(x = "date", y = "estimate", f = "variable", c = "grouping") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")),
    c == "per Capita" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")))) |>
  mutate(f = factor(f, levels = forecast_ord))

king_df <- vmt_data |> 
  filter(year >= earliest_year & variable %in% c("Observed") & geography == "King") |>
  select(x = "year", y = "estimate", f = "geography", c = "grouping") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")),
    c == "per Capita" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

kitsap_df <- vmt_data |> 
  filter(year >= earliest_year & variable %in% c("Observed") & geography == "Kitsap") |>
  select(x = "year", y = "estimate", f = "geography", c = "grouping") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")),
    c == "per Capita" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

pierce_df <- vmt_data |> 
  filter(year >= earliest_year & variable %in% c("Observed") & geography == "Pierce") |>
  select(x = "year", y = "estimate", f = "geography", c = "grouping") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")),
    c == "per Capita" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

snohomish_df <- vmt_data |> 
  filter(year >= earliest_year & variable %in% c("Observed") & geography == "Snohomish") |>
  select(x = "year", y = "estimate", f = "geography", c = "grouping") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")),
    c == "per Capita" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

vmt_county_data <- list(king_df, kitsap_df, pierce_df, snohomish_df)

vkt_data <- vkt_data |> 
  mutate(year = current_vmt_year) |>
  select(x = "geography", y = "estimate", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y, -1), nsmall=0, big.mark=","))) |>
  mutate(x = fct_reorder(x, y, .desc = FALSE))

saveRDS(vmt_box_values, here(rtp_dashboard_data_url, "vmt_box_values.rds"))  
saveRDS(vmt_region_data, here(rtp_dashboard_data_url, "vmt_region_data.rds"))
saveRDS(vmt_county_data, here(rtp_dashboard_data_url, "vmt_county_data.rds"))
saveRDS(vkt_data, here(rtp_dashboard_data_url, "vkt_data.rds"))

# Pre-Processed Data for Climate: WFH -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "Work from Home" & year == census_base_year & metric == "commute-modes") |> 
                        select("share") |> pull())*100, 1), "%")

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "Work from Home" & year == census_vision_year & metric == "commute-modes") |> 
                          select("share") |> pull())*100, 1), "%")

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "Work from Home" & year == census_current_year & metric == "commute-modes") |> 
                           select("share") |> pull())*100, 1), "%")

horizon <- paste0(round((wfh_2050)*100, 1), "%")

wfh_box_values <- list(c(base, paste(census_base_year, "share of workers who worked from home")), 
                       c(vision, paste(census_vision_year, "share of workers who worked from home")),
                       c(current, paste(census_current_year, "share of workers who worked from home")), 
                       c(horizon, paste(census_horizon_year, "RTP forecasted share of workers who worked from home")))

wfh_county <- commute_data |> 
  filter(metric == "commute-modes" & variable %in% c("Work from Home") & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "share", f = "geography", c = "year") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%")) |>
  mutate(x = str_remove_all(x, " County")) |>
  mutate(f = str_remove_all(f, " County")) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

wfh_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "Worked from home" & metric == "Commute Mode") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

wfh_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "Work from Home") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

wfh_city <- commute_data |> 
  filter(geography_type == "City" & variable == "Work from Home") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(wfh_box_values, here(rtp_dashboard_data_url, "wfh_box_values.rds")) 
saveRDS(wfh_county, here(rtp_dashboard_data_url, "wfh_county_data.rds")) 
saveRDS(wfh_race, here(rtp_dashboard_data_url, "wfh_race_data.rds")) 
saveRDS(wfh_metro, here(rtp_dashboard_data_url, "wfh_metro_data.rds")) 
saveRDS(wfh_city, here(rtp_dashboard_data_url, "wfh_city_data.rds")) 

# Pre-Processed Data for Transit: Boardings and Hours -------------------------------------
base <- paste0(round((transit_data |> 
                        filter(geography == "Region" & variable == "All Transit Modes" & grouping == "Annual" & year == transit_base_year & metric == "Boardings") |> 
                        mutate(estimate = estimate / 1000000) |>
                        select("estimate") |> pull())*1, 1), " million")

vision <- paste0(round((transit_data |> 
                          filter(geography == "Region" & variable == "All Transit Modes" & grouping == "Annual" & year == transit_vision_year & metric == "Boardings") |> 
                          mutate(estimate = estimate / 1000000) |>
                          select("estimate") |> pull())*1, 1), " million")

current <- paste0(round((transit_data |> 
                           filter(geography == "Region" & variable == "All Transit Modes" & grouping == "Annual" & year == transit_current_year & metric == "Boardings") |> 
                           mutate(estimate = estimate / 1000000) |>
                           select("estimate") |> pull())*1, 1), " million")

horizon <- paste0(round((transit_data |> 
                           filter(geography == "Region" & variable == "All Transit Modes" & grouping == "Forecast" & year == transit_horizon_year & metric == "Boardings") |> 
                           mutate(estimate = estimate / 1000000) |>
                           select("estimate") |> pull())*1, 1), " million")

transit_metric_box_values <- list(c(base, paste(transit_base_year, "annual boardings")), 
                                  c(vision, paste(transit_vision_year, "annual boardings")),
                                  c(current, paste(transit_current_year, "annual boardings")), 
                                  c(horizon, paste(transit_horizon_year, "RTP forecasted annual boardings")))

transit_metric_region <- transit_data |> 
  filter(variable %in% c("All Transit Modes") & geography_type %in% c("Region") & grouping %in% c("Annual", "Forecast")) |>
  select(x = "year", y = "estimate", f = "grouping", c = "metric") |>
  mutate(l = case_when(
    c == "Boardings-per-Hour" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")),
    c != "Boardings-per-Hour" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=","))))

transit_metric_by_mode <- transit_data |> 
  filter(variable != "All Transit Modes" & geography_type %in% c("Region") & grouping %in% c("Annual")) |>
  filter(year >= pre_covid) |>
  select(x = "year", y = "estimate", f = "variable", c = "metric") |>
  mutate(l = case_when(
    c == "Boardings-per-Hour" ~ paste0(f, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")),
    c != "Boardings-per-Hour" ~ paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=","))))

transit_metric_metro <- transit_data |> 
  filter(geography_type == "Metro Areas" & grouping == "COVID Recovery") |>
  select(x = "geography", y = "estimate", f = "plot_id", c = "metric") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 0), nsmall=0, big.mark=","), "%"))

saveRDS(transit_metric_box_values, here(rtp_dashboard_data_url, "transit_metric_box_values.rds")) 
saveRDS(transit_metric_region, here(rtp_dashboard_data_url, "transit_metric_region_data.rds")) 
saveRDS(transit_metric_by_mode, here(rtp_dashboard_data_url, "transit_metric_by_mode_data.rds")) 
saveRDS(transit_metric_metro, here(rtp_dashboard_data_url, "transit_metric_metro_data.rds")) 

# Pre-Processed Data for Transit: Transit Share -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "Transit" & year == census_base_year & metric == "commute-modes") |> 
                        select("share") |> pull())*100, 1), "%")

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "Transit" & year == census_vision_year & metric == "commute-modes") |> 
                          select("share") |> pull())*100, 1), "%")

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "Transit" & year == census_current_year & metric == "commute-modes") |> 
                           select("share") |> pull())*100, 1), "%")

horizon <- paste0(round((transit_2050)*100, 1), "%")

transit_mode_box_values <- list(c(base, paste(census_base_year, "share of workers who commute by public transportation")), 
                                c(vision, paste(census_vision_year, "share of workers who commute by public transportation")),
                                c(current, paste(census_current_year, "share of workers who commute by public transportation")), 
                                c(horizon, paste(census_horizon_year, "RTP forecasted share of workers who commute by public transportation")))

transit_county <- commute_data |> 
  filter(metric == "commute-modes" & variable %in% c("Transit") & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "share", f = "geography", c = "year") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%")) |>
  mutate(x = str_remove_all(x, " County")) |>
  mutate(f = str_remove_all(f, " County")) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

transit_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "Transit" & metric == "Commute Mode") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

transit_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "Transit") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

transit_city <- commute_data |> 
  filter(geography_type == "City" & variable == "Transit") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(transit_mode_box_values, here(rtp_dashboard_data_url, "transit_mode_box_values.rds")) 
saveRDS(transit_county, here(rtp_dashboard_data_url, "transit_mode_county_data.rds")) 
saveRDS(transit_race, here(rtp_dashboard_data_url, "transit_mode_race_data.rds")) 
saveRDS(transit_metro, here(rtp_dashboard_data_url, "transit_mode_metro_data.rds")) 
saveRDS(transit_city, here(rtp_dashboard_data_url, "transit_mode_city_data.rds")) 

# Pre-Processed Data for Walking: Commute Share -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "Walk" & year == census_base_year & metric == "commute-modes") |> 
                        select("share") |> pull())*100, 1), "%")

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "Walk" & year == census_vision_year & metric == "commute-modes") |> 
                          select("share") |> pull())*100, 1), "%")

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "Walk" & year == census_current_year & metric == "commute-modes") |> 
                           select("share") |> pull())*100, 1), "%")

horizon <- paste0(round((walk_2050)*100, 1), "%")

walk_mode_box_values <- list(c(base, paste(census_base_year, "share of workers who walk to work")), 
                                c(vision, paste(census_vision_year, "share of workers who walk to work")),
                                c(current, paste(census_current_year, "share of workers who walk to work")), 
                                c(horizon, paste(census_horizon_year, "RTP forecasted share of workers who walk to work")))
walk_county <- commute_data |> 
  filter(metric == "commute-modes" & variable %in% c("Walk") & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "share", f = "geography", c = "year") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%")) |>
  mutate(x = str_remove_all(x, " County")) |>
  mutate(f = str_remove_all(f, " County")) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

walk_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "Walked" & metric == "Commute Mode") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

walk_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "Walk") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

walk_city <- commute_data |> 
  filter(geography_type == "City" & variable == "Walk") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(walk_mode_box_values, here(rtp_dashboard_data_url, "walk_mode_box_values.rds")) 
saveRDS(walk_county, here(rtp_dashboard_data_url, "walk_mode_county_data.rds")) 
saveRDS(walk_race, here(rtp_dashboard_data_url, "walk_mode_race_data.rds")) 
saveRDS(walk_metro, here(rtp_dashboard_data_url, "walk_mode_metro_data.rds")) 
saveRDS(walk_city, here(rtp_dashboard_data_url, "walk_mode_city_data.rds")) 

# Pre-Processed Data for Biking: Commute Share -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "Bike" & year == census_base_year & metric == "commute-modes") |> 
                        select("share") |> pull())*100, 1), "%")

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "Bike" & year == census_vision_year & metric == "commute-modes") |> 
                          select("share") |> pull())*100, 1), "%")

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "Bike" & year == census_current_year & metric == "commute-modes") |> 
                           select("share") |> pull())*100, 1), "%")

horizon <- paste0(round((bike_2050)*100, 1), "%")

bike_mode_box_values <- list(c(base, paste(census_base_year, "share of workers who Bike to work")), 
                             c(vision, paste(census_vision_year, "share of workers who Bike to work")),
                             c(current, paste(census_current_year, "share of workers who Bike to work")), 
                             c(horizon, paste(census_horizon_year, "RTP forecasted share of workers who Bike to work")))
bike_county <- commute_data |> 
  filter(metric == "commute-modes" & variable %in% c("Bike") & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "share", f = "geography", c = "year") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%")) |>
  mutate(x = str_remove_all(x, " County")) |>
  mutate(f = str_remove_all(f, " County")) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

bike_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "Bicycle" & metric == "Commute Mode") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

bike_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "Bike") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

bike_city <- commute_data |> 
  filter(geography_type == "City" & variable == "Bike") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(bike_mode_box_values, here(rtp_dashboard_data_url, "bike_mode_box_values.rds")) 
saveRDS(bike_county, here(rtp_dashboard_data_url, "bike_mode_county_data.rds")) 
saveRDS(bike_race, here(rtp_dashboard_data_url, "bike_mode_race_data.rds")) 
saveRDS(bike_metro, here(rtp_dashboard_data_url, "bike_mode_metro_data.rds")) 
saveRDS(bike_city, here(rtp_dashboard_data_url, "bike_mode_city_data.rds")) 

# Pre-Processed Data for Growth -------------------------------------
base <- paste0(round((pop_hsg_jobs_data |> 
                        filter(geography == "Region" & variable == "Observed" & grouping == "Total" & year == growth_base_year & metric == "Population") |> 
                        mutate(estimate = estimate / 1000000) |>
                        select("estimate") |> pull())*1, 2), " million")

vision <- paste0(round((pop_hsg_jobs_data |> 
                          filter(geography == "Region" & variable == "Observed" & grouping == "Total" & year == growth_vision_year & metric == "Population") |> 
                          mutate(estimate = estimate / 1000000) |>
                          select("estimate") |> pull())*1, 2), " million")

current <- paste0(round((pop_hsg_jobs_data |> 
                           filter(geography == "Region" & variable == "Observed" & grouping == "Total" & year == growth_current_year & metric == "Population") |> 
                           mutate(estimate = estimate / 1000000) |>
                           select("estimate") |> pull())*1, 2), " million")

horizon <- paste0(round((pop_hsg_jobs_data |> 
                           filter(geography == "Region" & variable == "Forecast" & grouping == "Total" & year == growth_horizon_year & metric == "Population") |> 
                           mutate(estimate = estimate / 1000000) |>
                           select("estimate") |> pull())*1, 2), " million")


growth_box_values <- list(c(base, paste("people in", growth_base_year)), 
                          c(vision, paste("people in", growth_vision_year)),
                          c(current, paste("people in", growth_current_year)), 
                          c(horizon, paste("people in", growth_horizon_year)))

growth_region_data <- pop_hsg_jobs_data |> 
  filter(grouping ==  "Total") |>
  select(x = "year", y = "estimate", f = "variable", c = "metric") |>
  mutate(l = paste0(f, ": ", format(round(y*1, -3), nsmall=0, big.mark=",")))

growth_hct_data <- pop_hsg_jobs_data |> 
  filter(grouping ==  "Change") |>
  select(x = "year", y = "share", f = "variable", c = "metric") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","),"%"))

saveRDS(growth_box_values, here(rtp_dashboard_data_url, "growth_box_values.rds")) 
saveRDS(growth_region_data, here(rtp_dashboard_data_url, "growth_region_data.rds")) 
saveRDS(growth_hct_data, here(rtp_dashboard_data_url, "growth_hct_data.rds")) 

# Pre-Processed Data for Safety: Geography -------------------------------------
base <- paste0(round((collision_data |> 
                        mutate(year = year(date)) |>
                        filter(geography == "Region" & variable == "Total" & metric == "Traffic Related Deaths" & year == safety_base_year & grouping == "All") |> 
                        select("estimate") |> pull())*1, 0))

vision <- paste0(round((collision_data |> 
                          mutate(year = year(date)) |>
                          filter(geography == "Region" & variable == "Total" & metric == "Traffic Related Deaths" & year == safety_vision_year & grouping == "All") |> 
                          select("estimate") |> pull())*1, 0))

current <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography == "Region" & variable == "Total" & metric == "Traffic Related Deaths" & year == safety_current_year & grouping == "All") |> 
                           select("estimate") |> pull())*1, 0))

horizon <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography == "Region" & variable == "Total" & metric == "Traffic Related Deaths" & year == safety_horizon_year & grouping == "All") |> 
                           select("estimate") |> pull())*1, 0))


safety_geography_box_values <- list(c(base, paste("people died on our region's roadways in", safety_base_year)), 
                                    c(vision, paste("people died on our region's roadways in", safety_vision_year)),
                                    c(current, paste("people died on our region's roadways in", safety_current_year)),
                                    c(horizon, paste("people died on our region's roadways in", safety_horizon_year)))

deaths_region_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography == "Region" & metric == "Traffic Related Deaths" & grouping == "All") |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

serious_region_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography == "Region" & metric == "Serious Injury" & grouping == "All") |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

deaths_rural_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(metric == "Traffic Related Deaths" & grouping == "Urban or Rural") |>
  select(x = "year", y = "estimate", f = "geography", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

serious_rural_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(metric == "Serious Injury" & grouping == "Urban or Rural") |>
  select(x = "year", y = "estimate", f = "geography", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

deaths_hdc_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Historically Disadvantaged Community" & metric == "Traffic Related Deaths" & variable == "Total") |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

serious_hdc_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Historically Disadvantaged Community" & metric == "Serious Injury" & variable == "Total") |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

safety_king_df <- collision_data |> 
  mutate(year = year(date)) |>
  filter(geography_type == "County" & geography == "King" & year >= pre_covid) |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, " Total: ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(f, " Rate: ", format(round(y*1, 1), nsmall=0, big.mark=","))))

safety_kitsap_df <- collision_data |> 
  mutate(year = year(date)) |>
  filter(geography_type == "County" & geography == "Kitsap" & year >= pre_covid) |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, " Total: ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(f, " Rate: ", format(round(y*1, 1), nsmall=0, big.mark=","))))

safety_pierce_df <- collision_data |> 
  mutate(year = year(date)) |>
  filter(geography_type == "County" & geography == "Pierce" & year >= pre_covid) |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, " Total: ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(f, " Rate: ", format(round(y*1, 1), nsmall=0, big.mark=","))))

safety_snohomish_df <- collision_data |> 
  mutate(year = year(date)) |>
  filter(geography_type == "County" & geography == "Snohomish" & year >= pre_covid) |>
  select(x = "year", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(f, " Total: ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(f, " Rate: ", format(round(y*1, 1), nsmall=0, big.mark=","))))

safety_county_data <- list(safety_king_df, safety_kitsap_df, safety_pierce_df, safety_snohomish_df)

deaths_mpo_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Metro Regions" & metric == "Traffic Related Deaths" & grouping == "All" & year == safety_mpo_year) |>
  mutate(plot_id = case_when(
    geography == "Seattle" ~ "PSRC",
    geography != "Seattle" ~ "Other MPO")) |>
  select(x = "geography", y = "estimate", f = "plot_id", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(x, " Total: ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(x, " Rate: ", format(round(y*1, 1), nsmall=0, big.mark=","))))

saveRDS(safety_geography_box_values, here(rtp_dashboard_data_url, "safety_geography_box_values.rds")) 
saveRDS(deaths_region_data, here(rtp_dashboard_data_url, "deaths_region_data.rds")) 
saveRDS(serious_region_data, here(rtp_dashboard_data_url, "serious_region_data.rds")) 
saveRDS(deaths_rural_data, here(rtp_dashboard_data_url, "deaths_rural_data.rds")) 
saveRDS(serious_rural_data, here(rtp_dashboard_data_url, "serious_rural_data.rds")) 
saveRDS(deaths_hdc_data, here(rtp_dashboard_data_url, "deaths_hdc_data.rds")) 
saveRDS(serious_hdc_data, here(rtp_dashboard_data_url, "serious_hdc_data.rds")) 
saveRDS(safety_county_data, here(rtp_dashboard_data_url, "safety_county_data.rds")) 
saveRDS(deaths_mpo_data, here(rtp_dashboard_data_url, "deaths_mpo_data.rds")) 

# Pre-Processed Data for Safety: Person -------------------------------------
base <- paste0(round((collision_data |> 
                        mutate(year = year(date)) |>
                        filter(geography == "Region" & variable == "Rate per 100k people" & metric == "Traffic Related Deaths" & year == safety_horizon_year & grouping == "All") |> 
                        select("estimate") |> pull())*1, 1))

vision <- paste0(round((collision_data |> 
                          mutate(year = year(date)) |>
                          filter(geography_type == "Age Group" & variable == "Rate per 100k people" & metric == "Traffic Related Deaths" & year == safety_horizon_year & grouping == "18 to 29") |> 
                          select("estimate") |> pull())*1, 1))

current <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography_type == "Race" & variable == "Rate per 100k people" & metric == "Traffic Related Deaths" & year == safety_horizon_year & grouping == "American Indian and Alaska Native") |> 
                           select("estimate") |> pull())*1, 1))

horizon <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography_type == "Gender" & variable == "Rate per 100k people" & metric == "Traffic Related Deaths" & year == safety_horizon_year & grouping == "Male") |> 
                           select("estimate") |> pull())*1, 1))


safety_person_box_values <- list(c(base, paste("total people in the region per 100k died in", safety_horizon_year)),
                                 c(vision, paste("people aged 18 to 29 per 100k died in", safety_horizon_year)),
                                 c(current, paste("American Indian and Alaska Native people per 100k died in", safety_horizon_year)),
                                 c(horizon, paste("men per 100k died in", safety_horizon_year)))

deaths_race_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Race" & metric == "Traffic Related Deaths" & year == safety_horizon_year) |>
  select(x = "grouping", y = "estimate", f = "variable", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, " ", x, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, " ", x, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

deaths_age_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Age Group" & metric == "Traffic Related Deaths" & year == safety_horizon_year) |>
  select(x = "grouping", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 1), nsmall=0, big.mark=","))))

serious_age_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Age Group" & metric == "Serious Injury" & year == safety_horizon_year) |>
  select(x = "grouping", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")))) |>
  filter(x != "Unknown")

deaths_gender_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Gender" & metric == "Traffic Related Deaths" & year == safety_horizon_year) |>
  select(x = "grouping", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")))) |>
  filter(x != "Not Reported")

serious_gender_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Gender" & metric == "Serious Injury" & year == safety_horizon_year) |>
  select(x = "grouping", y = "estimate", f = "metric", c = "variable") |>
  mutate(l = case_when(
    c == "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")),
    c != "Total" ~ paste0(c, " people aged ", x, ": ", format(round(y*1, 1), nsmall=0, big.mark=",")))) |>
  filter(x %in% c("Female", "Male"))


saveRDS(safety_person_box_values, here(rtp_dashboard_data_url, "safety_person_box_values.rds")) 
saveRDS(deaths_race_data, here(rtp_dashboard_data_url, "deaths_race_data.rds")) 
saveRDS(deaths_age_data, here(rtp_dashboard_data_url, "deaths_age_data.rds")) 
saveRDS(serious_age_data, here(rtp_dashboard_data_url, "serious_age_data.rds")) 
saveRDS(deaths_gender_data, here(rtp_dashboard_data_url, "deaths_gender_data.rds")) 
saveRDS(serious_gender_data, here(rtp_dashboard_data_url, "serious_gender_data.rds"))

# Pre-Processed Data for Safety: Other -------------------------------------
base <- paste0(round((collision_data |> 
                        mutate(year = year(date)) |>
                        filter(geography_type == "Mode" & variable == "Total" & year == safety_base_year & metric == "Traffic Related Deaths" & grouping %in% c("Walking", "Biking")) |> 
                        select("estimate") |> 
                        pull() |>
                        sum())*1, 0))

vision <- paste0(round((collision_data |> 
                          mutate(year = year(date)) |>
                          filter(geography_type == "Mode" & variable == "Total" & year == safety_vision_year & metric == "Traffic Related Deaths" & grouping %in% c("Walking", "Biking")) |> 
                          select("estimate") |> 
                          pull() |>
                          sum())*1, 0))

current <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography_type == "Mode" & variable == "Total" & year == safety_current_year & metric == "Traffic Related Deaths" & grouping %in% c("Walking", "Biking")) |> 
                           select("estimate") |> 
                           pull() |>
                           sum())*1, 0))

horizon <- paste0(round((collision_data |> 
                           mutate(year = year(date)) |>
                           filter(geography_type == "Mode" & variable == "Total" & year == safety_horizon_year & metric == "Traffic Related Deaths" & grouping %in% c("Walking", "Biking")) |> 
                           select("estimate") |> 
                           pull() |>
                           sum())*1, 0))

safety_mode_box_values <- list(c(base, paste("people died walking & biking in", safety_base_year)),
                               c(vision, paste("people died walking & biking in", safety_vision_year)),
                               c(current, paste("people died walking & biking in", safety_current_year)),
                               c(horizon, paste("people died walking & biking in", safety_horizon_year)))

deaths_mode_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Mode" & metric == "Traffic Related Deaths" & variable == "Total" & grouping != "Other") |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

serious_mode_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Mode" & metric == "Serious Injury" & variable == "Total" & grouping != "Other") |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

deaths_tod_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Time of Day" & metric == "Traffic Related Deaths" & variable == "Total") |>
  mutate(grouping = case_when(
    grouping %in% c("AM Peak", "Midday", "PM Peak") ~ "before 6pm",
    grouping %in% c("Evening", "Overnight") ~ "after 6pm")) |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  group_by(x, f, c) |>
  summarise(y = sum(y)) |>
  as_tibble() |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

serious_tod_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Time of Day" & metric == "Serious Injury" & variable == "Total") |>
  mutate(grouping = case_when(
    grouping %in% c("AM Peak", "Midday", "PM Peak") ~ "before 6pm",
    grouping %in% c("Evening", "Overnight") ~ "after 6pm")) |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  group_by(x, f, c) |>
  summarise(y = sum(y)) |>
  as_tibble() |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

deaths_dow_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Day of Week" & metric == "Traffic Related Deaths" & variable == "Total") |>
  mutate(grouping = case_when(
    grouping %in% c("Fri", "Sat") ~ "Fri-Sat",
    grouping %in% c("Sun", "Mon", "Tue", "Wed", "Thu") ~ "Sun-Thu")) |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  group_by(x, f, c) |>
  summarise(y = sum(y)) |>
  as_tibble() |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

serious_dow_data <- collision_data |>
  mutate(year = year(date)) |>
  filter(geography_type == "Day of Week" & metric == "Serious Injury" & variable == "Total") |>
  mutate(grouping = case_when(
    grouping %in% c("Fri", "Sat") ~ "Fri-Sat",
    grouping %in% c("Sun", "Mon", "Tue", "Wed", "Thu") ~ "Sun-Thu")) |>
  select(x = "year", y = "estimate", f = "grouping", c = "variable") |>
  group_by(x, f, c) |>
  summarise(y = sum(y)) |>
  as_tibble() |>
  mutate(l = paste0(f, ": ", format(round(y*1, 0), nsmall=0, big.mark=",")))

saveRDS(safety_mode_box_values, here(rtp_dashboard_data_url, "safety_mode_box_values.rds")) 
saveRDS(deaths_mode_data, here(rtp_dashboard_data_url, "deaths_mode_data.rds")) 
saveRDS(serious_mode_data, here(rtp_dashboard_data_url, "serious_mode_data.rds")) 
saveRDS(deaths_tod_data, here(rtp_dashboard_data_url, "deaths_tod_data.rds")) 
saveRDS(serious_tod_data, here(rtp_dashboard_data_url, "serious_tod_data.rds"))
saveRDS(deaths_dow_data, here(rtp_dashboard_data_url, "deaths_dow_data.rds")) 
saveRDS(serious_dow_data, here(rtp_dashboard_data_url, "serious_dow_data.rds"))

# Pre-Processed Data for Travel: Time -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "travel time to work" & year == pums_base_year & metric == "Mean Commute Time" & geography_type == "Region") |> 
                        select("estimate") |> pull())*1, 1))

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "travel time to work" & year == pums_vision_year & metric == "Mean Commute Time" & geography_type == "Region") |> 
                          select("estimate") |> pull())*1, 1))

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "travel time to work" & year == pums_current_year & metric == "Mean Commute Time" & geography_type == "Region") |> 
                           select("estimate") |> pull())*1, 1))

horizon <- paste0(round((tt_2050)*1, 1))

tt_box_values <- list(c(base, paste("average commute time by auto in", pums_base_year)),
                      c(vision, paste("average commute time by auto in", pums_vision_year)),
                       c(current, paste("average commute time by auto in", pums_current_year)), 
                       c(horizon, paste("RTP forecasted average commute time by auto in", pums_horizon_year)))

tt_county <- commute_data |> 
  filter(variable == "travel time to work" & metric == "Mean Commute Time" & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "estimate", f = "geography", c = "year") |>
  mutate(l = paste0(f, " travel time to work: ", format(round(y*1, 1), nsmall=0, big.mark=","))) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

tt_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "more than 60 minutes" & metric == "Travel Time Bins") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

tt_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "more than 60 minutes" & metric == "commute-times") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

tt_city <- commute_data |> 
  filter(geography_type == "City" & variable == "more than 60 minutes" & metric == "commute-times") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(tt_box_values, here(rtp_dashboard_data_url, "tt_box_values.rds")) 
saveRDS(tt_county, here(rtp_dashboard_data_url, "tt_county_data.rds")) 
saveRDS(tt_race, here(rtp_dashboard_data_url, "tt_race_data.rds")) 
saveRDS(tt_metro, here(rtp_dashboard_data_url, "tt_metro_data.rds")) 
saveRDS(tt_city, here(rtp_dashboard_data_url, "tt_city_data.rds")) 

# Pre-Processed Data for Travel: Departure -------------------------------------
base <- paste0(round((commute_data |> 
                        filter(geography == "Region" & variable == "Early Morning" & year == pums_base_year & metric == "Departure Time Bins" & geography_type == "Region") |> 
                        select("share") |> pull())*100, 1), "%")

vision <- paste0(round((commute_data |> 
                          filter(geography == "Region" & variable == "Early Morning" & year == pums_vision_year & metric == "Departure Time Bins" & geography_type == "Region") |> 
                          select("share") |> pull())*100, 1), "%")

current <- paste0(round((commute_data |> 
                           filter(geography == "Region" & variable == "Early Morning" & year == pums_current_year & metric == "Departure Time Bins" & geography_type == "Region") |> 
                           select("share") |> pull())*100, 1), "%")

horizon <- paste0(round((dt_2050)*100, 1), "%")

dt_box_values <- list(c(base, paste("of commuters who leave before 7am in", pums_base_year)),
                      c(vision, paste("of commuters who leave before 7am in", pums_vision_year)),
                      c(current, paste("of commuters who leave before 7am in", pums_current_year)), 
                      c(horizon, paste("RTP forecasted commuters who leave before 7am in", pums_horizon_year)))

dt_county <- commute_data |> 
  filter(variable == "Early Morning" & metric == "Departure Time Bins" & geography_type %in% c("County", "Region")) |>
  select(x = "geography", y = "share", f = "geography", c = "year") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","),"%")) |>
  mutate(x = factor(x, levels = county_ord)) |>
  mutate(f = factor(f, levels = county_ord)) |>
  arrange(c, x, f)

dt_race <- commute_data |> 
  filter(geography_type == "Race" & variable == "Early Morning" & metric == "Departure Time Bins") |>
  select(x = "grouping", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

dt_metro <- commute_data |> 
  filter(geography_type == "Metro Areas" & variable == "Early Morning" & metric == "departure-time") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

dt_city <- commute_data |> 
  filter(geography_type == "City" & variable == "Early Morning" & metric == "departure-time") |>
  select(x = "geography", y = "share", f = "plot_id", c = "year") |>
  mutate(l = paste0(x, ": ", format(round(y*100, 1), nsmall=0, big.mark=","), "%"))

saveRDS(dt_box_values, here(rtp_dashboard_data_url, "dt_box_values.rds")) 
saveRDS(dt_county, here(rtp_dashboard_data_url, "dt_county_data.rds")) 
saveRDS(dt_race, here(rtp_dashboard_data_url, "dt_race_data.rds")) 
saveRDS(dt_metro, here(rtp_dashboard_data_url, "dt_metro_data.rds")) 
saveRDS(dt_city, here(rtp_dashboard_data_url, "dt_city_data.rds")) 

# Pre-Processed Data for Travel: Congestion -------------------------------------
base <- paste0(round((congestion_data |> 
                        filter(geography == "Region" & 
                                 variable == "AM Peak" & 
                                 year == congestion_base_year & 
                                 grouping %in% c("Heavy", "Severe") & 
                                 date == lubridate::mdy(paste0(congestion_month,"-01-",congestion_base_year)) &
                                 geography_type == "Weekday") |> 
                        select("share") |> 
                        pull() |>
                        sum())*100, 0), "%")

vision <- paste0(round((congestion_data |> 
                          filter(geography == "Region" & 
                                   variable == "AM Peak" & 
                                   year == congestion_vision_year & 
                                   grouping %in% c("Heavy", "Severe") & 
                                   date == lubridate::mdy(paste0(congestion_month,"-01-",congestion_vision_year)) &
                                   geography_type == "Weekday") |> 
                          select("share") |> 
                          pull() |>
                          sum())*100, 0), "%")

current <- paste0(round((congestion_data |> 
                           filter(geography == "Region" & 
                                    variable == "AM Peak" & 
                                    year == congestion_current_year & 
                                    grouping %in% c("Heavy", "Severe") & 
                                    date == lubridate::mdy(paste0(congestion_month,"-01-",congestion_current_year)) &
                                    geography_type == "Weekday") |> 
                           select("share") |> 
                           pull() |>
                           sum())*100, 0), "%")

horizon <- paste0(round((cong_2050)*100, 0), "%")

congestion_box_values <- list(c(base, paste("of NHS roadways with heavy or severe congestion in", congestion_base_year)),
                              c(vision, paste("of NHS roadways with heavy or severe congestion in", congestion_vision_year)),
                              c(current, paste("of NHS roadways with heavy or severe congestion in", congestion_current_year)), 
                              c(horizon, paste("RTP forecasted highways with heavy or severe congestion in", congestion_horizon_year)))

congestion_region_weekday <- congestion_data |> 
  filter(geography_type == "Weekday" & geography == "Region" & grouping %in% c("Heavy", "Severe") & variable %in% c("AM Peak", "Midday", "PM Peak")) |>
  select(x = "date", y = "share", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","),"%"))

congestion_region_weekend <- congestion_data |> 
  filter(geography_type == "Weekend" & geography == "Region" & grouping %in% c("Heavy", "Severe") & variable %in% c("AM Peak", "Midday", "PM Peak")) |>
  select(x = "date", y = "share", f = "grouping", c = "variable") |>
  mutate(l = paste0(f, ": ", format(round(y*100, 1), nsmall=0, big.mark=","),"%"))

congestion_am_map <- congestion_map_data |>
  filter(geography_type == "Weekday" & am_peak < 0.50) |>
  mutate(grouping = case_when(
    am_peak < 0.25 ~ "Severe",
    am_peak < 0.5 ~ "Heavy")) |>
  select("roadway", ratio = "am_peak", "grouping") |>
  mutate(l = paste0("Speed Ratio: ", format(round(ratio*100, 0), nsmall=0, big.mark=","),"%"))

congestion_pm_map <- congestion_map_data |>
  filter(geography_type == "Weekday" & pm_peak < 0.50) |>
  mutate(grouping = case_when(
    pm_peak < 0.25 ~ "Severe",
    pm_peak < 0.5 ~ "Heavy")) |>
  select("roadway", ratio = "pm_peak", "grouping") |>
  mutate(l = paste0("Speed Ratio: ", format(round(ratio*100, 0), nsmall=0, big.mark=","),"%"))
  
saveRDS(congestion_box_values, here(rtp_dashboard_data_url, "congestion_box_values.rds")) 
saveRDS(congestion_region_weekday, here(rtp_dashboard_data_url, "congestion_region_weekday_data.rds")) 
saveRDS(congestion_region_weekend, here(rtp_dashboard_data_url, "congestion_region_weekend_data.rds")) 
saveRDS(congestion_am_map, here(rtp_dashboard_data_url, "congestion_am_map_data.rds"))
saveRDS(congestion_pm_map, here(rtp_dashboard_data_url, "congestion_pm_map_data.rds"))
