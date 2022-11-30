# Packages ----------------------------------------------------------------
library(tidyverse)
library(psrccensus)
library(psrctrends)
library(tidycensus)
library(openxlsx)

# Basic Inputs ------------------------------------------------------------
census_yrs <- c(seq(2010,2019,by=1),2021)
forecast_years <-c(2018,2030,2040,2050)

# Population Growth -------------------------------------------------------
ofm.pop <- get_ofm_intercensal_population()

t1 <- ofm.pop %>% 
  filter(Jurisdiction=="Region") %>% 
  mutate(Variable="Observed") %>% 
  select(Year, Estimate, Variable) %>%
  mutate(geography="Region", Variable="Observed Population", concept="Population", data_source="ofm_intercensal", geography_type="PSRC Region", share=1) %>%
  rename(year=Year, estimate=Estimate, label=Variable)

t2 <- t1 %>% 
  filter(year<=2018) %>% 
  mutate(label="Forecast Population") %>% 
  select(year, estimate, label) %>%
  mutate(geography="Region", concept="Population", data_source="macroforecast", geography_type="PSRC Region", share=1)

t3 <- get_elmer_table("Macroeconomic.pop_facts") %>% 
  filter(pop_group_dim_id==7 & data_year >= 2019) %>%
  rename(year=data_year, estimate=population) %>%
  mutate(label="Forecast Population") %>% 
  select(year, estimate, label) %>%
  mutate(geography="Region", concept="Population", data_source="macroforecast", geography_type="PSRC Region", share=1)

population <- bind_rows(list(t1, t2, t3))
rm(ofm.pop, t1, t2, t3)

# Job Growth -------------------------------------------------------
qcew_jobs <- process_qcew_monthly_msa(c.yr=2022, c.mo=8)

t1 <- qcew_jobs %>%
  filter(geography=="Region" & month=="08" & variable=="Total Nonfarm") %>%
  select(geography, year, estimate) %>%
  mutate(year=as.numeric(year)) %>%
  mutate(label="Observed Employment", concept="Employment", data_source="qcew_monthly_msa", geography_type="PSRC Region", share=1)

t2 <- t1 %>% 
  filter(year<=2018) %>% 
  mutate(label="Forecast Employment")

t3 <- get_elmer_table("Macroeconomic.employment_facts") %>% 
  filter(employment_sector_dim_id==18 & data_year >= 2019) %>%
  rename(year=data_year, estimate=jobs) %>%
  mutate(label="Forecast Employment") %>% 
  select(year, estimate, label) %>%
  mutate(geography="Region", concept="Employment", data_source="macroforecast", geography_type="PSRC Region", share=1)

employment <- bind_rows(list(t1, t2, t3))
rm(qcew_jobs, t1, t2, t3)

# Housing Units Growth -------------------------------------------------------
ofm_housing <- get_ofm_postcensal_housing()

t1 <- ofm_housing %>% 
  filter(Jurisdiction=="Region" & Variable=="Total Housing Units") %>% 
  select(Year, Estimate, Variable) %>%
  mutate(geography="Region", Variable="Observed Housing Units", concept="Housing", data_source="ofm_postcensal", geography_type="PSRC Region", share=1) %>%
  rename(year=Year, estimate=Estimate, label=Variable)

t2 <- t1 %>% 
  filter(year<2018) %>% 
  mutate(label="Forecast Housing Units") %>% 
  select(year, estimate, label) %>%
  mutate(geography="Region", concept="Housing", data_source="ofm_postcensal", geography_type="PSRC Region", share=1)

t3 <- as_tibble(read_csv('data/regional-housing.csv')) %>% 
  filter(Year>=2018) %>%
  select(Year, Forecast) %>%
  rename(year=Year, estimate=Forecast) %>%
  mutate(label="Forecast Housing Units") %>% 
  select(year, estimate, label) %>%
  mutate(geography="Region", concept="Housing", data_source="ofm_postcensal", geography_type="PSRC Region", share=1)

housing <- bind_rows(list(t1, t2, t3))
rm(ofm_housing, t1, t2, t3)

# Work Mode Share for PSRC Region ------------------------------------------------------
total.work.trips <- c("B08006_001")
da.work.trips <- c("B08006_003")
cp.work.trips <- c("B08006_004")
trn.work.trips <- c("B08006_008")
bke.work.trips <- c("B08006_014")
wlk.work.trips <- c("B08006_015")
oth.work.trips <- c("B08006_016")
wfh.work.trips <- c("B08006_017")

all.trips <- c(total.work.trips, da.work.trips, cp.work.trips, trn.work.trips, bke.work.trips, wlk.work.trips, oth.work.trips, wfh.work.trips)
non.da.trips <- c(cp.work.trips,trn.work.trips,bke.work.trips,wlk.work.trips,wfh.work.trips)

vehicles.available <- c("B08014_001","B08014_002","B08014_003","B08014_004","B08014_005","B08014_006","B08014_007")

t1 <- get_acs_recs(geography = 'county',table.names = c('B08006'), years=census_yrs, acs.type = 'acs1') %>% filter(variable %in% all.trips)
t2 <- get_acs_recs(geography = 'county',table.names = c('B08006'), years=2020, acs.type = 'acs5') %>% filter(variable %in% all.trips)
modes <-bind_rows(t1,t2)
t3 <- modes %>% filter(variable %in% total.work.trips) %>% select(name, year, estimate) %>% rename(total=estimate)
modes <- left_join(modes, t3, by=c("name","year")) %>% mutate(share=estimate/total)
rm(t1,t2,t3)

modes <- modes %>%
  select(-state,-geography, -total, -GEOID, -census_geography, -moe) %>%
  mutate(concept="Mode to Work") %>%
  mutate(label = case_when(
    variable %in% da.work.trips ~ "Drove Alone",
    variable %in% c(cp.work.trips,oth.work.trips) ~ "Carpooled",
    variable %in% trn.work.trips ~ "Transit",
    variable %in% c(bke.work.trips, wlk.work.trips) ~ "Biked & Walked",
    variable %in% wfh.work.trips ~ "Worked from Home",
    variable %in% total.work.trips ~ "Total Work Trips")) %>%
  group_by(name,label,concept,acs_type,year) %>%
  summarise(estimate=sum(estimate), share=sum(share)) %>%
  as_tibble() %>%
  rename(geography=name) %>%
  mutate(geography_type="PSRC Region")

# Work Mode Share for Metro Regions -----------------------------------------
mpo.file <- system.file('extdata', 'regional-councils-counties.csv', package='psrctrends')
mpo <- readr::read_csv(mpo.file, show_col_types = FALSE) %>% 
  dplyr::mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY_FIPS, width=3, side=c("left"), pad="0")) %>%
  dplyr::mutate(STATE_FIPS=stringr::str_pad(.data$STATE_FIPS, width=2, side=c("left"), pad="0")) %>%
  dplyr::mutate(GEOID = paste0(.data$STATE_FIPS,.data$COUNTY_FIPS)) %>% 
  mutate(MSA_FIPS=as.character(MSA_FIPS))

t1 <- tidycensus::get_acs(geography = "metropolitan statistical area/micropolitan statistical area", table = 'B08006', year = 2021, survey = 'acs1') %>% mutate(GEOID=as.character(GEOID)) %>% filter(variable %in% all.trips)

t2 <- left_join(t1, mpo, by=c("GEOID"="MSA_FIPS")) %>%
  drop_na() %>%
  select(MPO_AREA, variable, estimate) %>%
  group_by(MPO_AREA, variable) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble %>%
  mutate(label = case_when(
    variable %in% da.work.trips ~ "Drove Alone",
    variable %in% c(cp.work.trips,oth.work.trips) ~ "Carpooled",
    variable %in% trn.work.trips ~ "Transit",
    variable %in% c(bke.work.trips, wlk.work.trips) ~ "Biked & Walked",
    variable %in% wfh.work.trips ~ "Worked from Home",
    variable %in% total.work.trips ~ "Total Work Trips")) %>%
  group_by(MPO_AREA,label) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble() %>%
  rename(geography=MPO_AREA)
  
t3 <- t2 %>% filter(label == "Total Work Trips") %>% select(geography, estimate) %>% rename(total=estimate)
t2 <- left_join(t2, t3, by=c("geography")) %>% mutate(share=estimate/total, acs_type="acs1", year=2021, geography_type="Metro Regions", concept="Mode to Work") %>% select(-total)

modes <- bind_rows(modes, t2) %>% rename(data_source=acs_type)
rm(t1,t2,t3, mpo.file, mpo)

# Mode Share Forecast -------------------------------------------
for (y in forecast_years) {
  
  t1 <- as_tibble(read_csv(paste0('data/mode_share_county_',y,'.csv'))) %>%
    filter(dpurp=="Work") %>%
    drop_na() %>%
    mutate(label = case_when(
      mode=="Walk" ~ "Biked & Walked",
      mode=="Bike" ~ "Biked & Walked",
      mode=="SOV" ~ "Drove Alone",
      mode=="TNC" ~ "Drove Alone",
      mode=="HOV2" ~ "Carpooled",
      mode=="HOV3+" ~ "Carpooled",
      mode=="Transit" ~ "Transit",
      mode=="School Bus" ~ "Transit")) %>%
    group_by(hh_county, label) %>%
    summarise(estimate=sum(trexpfac)) %>%
    as_tibble() %>%
    rename(geography=hh_county)
  
  t2 <- as_tibble(read_csv(paste0('data/wfh_county_',y,'.csv'))) %>%
    drop_na() %>%
    rename(geography=person_county, estimate=psexpfac) %>%
    mutate(label="Worked from Home")
  
  t1 <- bind_rows(t1, t2)
  
  t3 <- t1 %>%
    mutate(label="Total Work Trips") %>%
    group_by(geography, label) %>%
    summarise(estimate=sum(estimate)) %>%
    as_tibble()
  
  t1 <- bind_rows(t1, t3)
  
  t4 <- t1 %>%
    group_by(label)%>%
    summarise(estimate=sum(estimate)) %>%
    as_tibble() %>%
    mutate(geography="Region")
  
  t1 <- bind_rows(t1, t4)
  
  t5 <- t1 %>%
    filter(label=="Total Work Trips") %>%
    select(-label) %>%
    rename(total=estimate)
  
  t1 <- left_join(t1, t5, by=c("geography")) %>%
    mutate(share=estimate/total) %>%
    select(-total) %>%
    mutate(year=y, concept="Mode to Work", data_source="SoundCast", geography_type="PSRC Region")
  
  modes <- bind_rows(modes, t1)
  rm(t1,t2,t3,t4,t5)
  
}

# Vehicle Availability for PSRC Region ------------------------------------------------------
t1 <- get_acs_recs(geography = 'county',table.names = c('B08014'), years=census_yrs, acs.type = 'acs1') %>% filter(variable %in% vehicles.available)
t2 <- get_acs_recs(geography = 'county',table.names = c('B08014'), years=2020, acs.type = 'acs5') %>% filter(variable %in% vehicles.available)
vehicles <-bind_rows(t1,t2)
t3 <- vehicles %>% filter(variable == "B08014_001") %>% select(name, year, estimate) %>% rename(total=estimate)
vehicles <- left_join(vehicles, t3, by=c("name","year")) %>% mutate(share=estimate/total)
rm(t1,t2,t3)

vehicles <- vehicles %>%
  select(-state,-geography, -total, -GEOID, -census_geography, -moe) %>%
  mutate(concept="Vehicle Availability") %>%
  mutate(label = case_when(
    variable ==  "B08014_001" ~ "Total Households",
    variable ==  "B08014_002" ~ "0 vehicles available",
    variable ==  "B08014_003" ~ "1 vehicle available",
    variable ==  "B08014_004" ~ "2 vehicles available",
    variable %in% c("B08014_005","B08014_006","B08014_007") ~ "3 or more vehicles available")) %>%
  group_by(name,label,concept,acs_type,year) %>%
  summarise(estimate=sum(estimate), share=sum(share)) %>%
  as_tibble() %>%
  rename(geography=name) %>%
  mutate(geography_type="PSRC Region")

# Vehicle Availability for for Metro Regions -----------------------------------------
mpo.file <- system.file('extdata', 'regional-councils-counties.csv', package='psrctrends')
mpo <- readr::read_csv(mpo.file, show_col_types = FALSE) %>% 
  dplyr::mutate(COUNTY_FIPS=stringr::str_pad(.data$COUNTY_FIPS, width=3, side=c("left"), pad="0")) %>%
  dplyr::mutate(STATE_FIPS=stringr::str_pad(.data$STATE_FIPS, width=2, side=c("left"), pad="0")) %>%
  dplyr::mutate(GEOID = paste0(.data$STATE_FIPS,.data$COUNTY_FIPS)) %>% 
  mutate(MSA_FIPS=as.character(MSA_FIPS))

t1 <- tidycensus::get_acs(geography = "metropolitan statistical area/micropolitan statistical area", table = 'B08014', year = 2021, survey = 'acs1') %>% mutate(GEOID=as.character(GEOID)) %>% filter(variable %in% vehicles.available)

t2 <- left_join(t1, mpo, by=c("GEOID"="MSA_FIPS")) %>%
  drop_na() %>%
  select(MPO_AREA, variable, estimate) %>%
  group_by(MPO_AREA, variable) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble %>%
  mutate(label = case_when(
    variable ==  "B08014_001" ~ "Total Households",
    variable ==  "B08014_002" ~ "0 vehicles available",
    variable ==  "B08014_003" ~ "1 vehicle available",
    variable ==  "B08014_004" ~ "2 vehicles available",
    variable %in% c("B08014_005","B08014_006","B08014_007") ~ "3 or more vehicles available")) %>%
  group_by(MPO_AREA,label) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble() %>%
  rename(geography=MPO_AREA)

t3 <- t2 %>% filter(label == "Total Households") %>% select(geography, estimate) %>% rename(total=estimate)
t2 <- left_join(t2, t3, by=c("geography")) %>% mutate(share=estimate/total, acs_type="acs1", year=2021, geography_type="Metro Regions", concept="Vehicle Availability") %>% select(-total)

vehicles <- bind_rows(vehicles, t2) %>% rename(data_source=acs_type)
rm(t1,t2,t3, mpo.file, mpo)

# Vehicle Availability Forecast -------------------------------------------
for (y in forecast_years) {
  
  t1 <- as_tibble(read_csv(paste0('data/auto_ownership_',y,'.csv'))) %>%
    drop_na() %>%
    mutate(label = case_when(
      hhvehs==0 ~ "0 vehicles available",
      hhvehs==1 ~ "1 vehicle available",
      hhvehs==2 ~ "2 vehicles available",
      hhvehs>=3 ~ "3 or more vehicles available")) %>%
    group_by(hh_county, label) %>%
    summarise(estimate=sum(hhexpfac)) %>%
    as_tibble() %>%
    rename(geography=hh_county)
  
  t2 <- as_tibble(read_csv(paste0('data/auto_ownership_',y,'.csv'))) %>%
    drop_na() %>%
    mutate(label="Total Households") %>%
    group_by(hh_county, label) %>%
    summarise(estimate=sum(hhexpfac)) %>%
    as_tibble() %>%
    rename(geography=hh_county)
  
  t1 <- bind_rows(t1, t2)
  
  t3 <- t1 %>%
    group_by(label)%>%
    summarise(estimate=sum(estimate)) %>%
    as_tibble() %>%
    mutate(geography="Region")
  
  t1 <- bind_rows(t1, t3)
  
  t4 <- t1 %>%
    filter(label=="Total Households") %>%
    select(-label) %>%
    rename(total=estimate)
    
  t1 <- left_join(t1, t4, by=c("geography")) %>%
    mutate(share=estimate/total) %>%
    select(-total) %>%
    mutate(year=y, concept="Vehicle Availability", data_source="SoundCast", geography_type="PSRC Region")
  
  vehicles <- bind_rows(vehicles, t1)
  rm(t1,t2,t3,t4)
  
}

# Safety Data -------------------------------------------------------------
t <- as_tibble(read.xlsx('data/FARS_ WSDOT_Summaries PSRC.xlsx', sheet = 'PSRCBoundaries', skipEmptyRows = TRUE, startRow = 4, colNames = TRUE)) %>%
  select(`Jurisdiction.boundary`, `Name.of.City,.County,.or.MPO`, `Year`,`Fatal.Crashes.(TZ.definition,.FARS)`,`Fatalities.(FARS)`
         ,`Suspected.Serious.Injury.Crashes.(TZ.definition)`,`Suspected.Serious.Injuries.(TZ.definition)`) %>%
  set_names("geography_type","geography","year","fatal_collisions","fatalities","serious_injury_collisions", "serious_injuries") %>%
  pivot_longer(values_to="estimate", names_to="label", cols=c("fatal_collisions","fatalities","serious_injury_collisions", "serious_injuries")) %>%
  mutate(concept="Safety Data", data_source="WSDOT/FARS", share=1)


# Final Data Output --------------------------------------------------------
rtp_data <- bind_rows(population, housing, employment, modes, vehicles)
write_csv(rtp_data, "data/rtp-dashboard-data.csv")
