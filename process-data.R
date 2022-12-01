# Packages ----------------------------------------------------------------
library(tidyverse)
library(psrccensus)
library(psrctrends)
library(tidycensus)
library(openxlsx)

# Basic Inputs ------------------------------------------------------------
census_yrs <- c(seq(2010,2019,by=1),2021)
forecast_years <-c(2018,2030,2040,2050)
safety_yrs <- c(seq(2010,2020,by=1))
fars_yrs <- c(seq(2006,2020,by=1))

# PUMS Data ---------------------------------------------------------------
source("pums_processing.R")
p <- process_pums_data()
t <- p %>% filter(str_detect(metric,"count")) %>% mutate(metric=str_replace_all(metric,"count_",""))
s <- p %>% filter(str_detect(metric,"share")) %>% rename(share=estimate, share_moe=moe) %>% select(-metric)
pums_data <- left_join(t,s, by=c("geography","grouping","variable","data_year")) %>% mutate(geography_type="PSRC Region", grouping=replace_na(grouping,"All"))
rm(p,t,s)

# NTD Data ----------------------------------------------------------------
source("ntd_processing.R")
ntd_data <- process_ntd_data()
ntd_data <- ntd_data %>% mutate(geography_type="PSRC Region", moe=0, share=0, share_moe=0, grouping="All")

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

population <- population %>%
  select(-data_source) %>%
  rename(data_year=year, metric=concept, variable=label) %>%
  mutate(moe=0, share=0, share_moe=0, grouping="All")

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

employment <- employment %>%
  select(-data_source) %>%
  rename(data_year=year, metric=concept, variable=label) %>%
  mutate(moe=0, share=0, share_moe=0, grouping="All")

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

housing <- housing %>%
  select(-data_source) %>%
  rename(data_year=year, metric=concept, variable=label) %>%
  mutate(moe=0, share=0, share_moe=0, grouping="All")

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

modes <- modes %>%
  select(-data_source) %>%
  rename(data_year=year, metric=concept, variable=label) %>%
  mutate(moe=0, share_moe=0, grouping="All")

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

vehicles <- vehicles %>%
  select(-data_source) %>%
  rename(data_year=year, metric=concept, variable=label) %>%
  mutate(moe=0, share_moe=0, grouping="All")

# Safety Data -------------------------------------------------------------
mpo <- read_csv("X:/DSA/shiny-uploads/data/regional-councils-counties.csv") %>% 
  mutate(COUNTY_FIPS=str_pad(COUNTY_FIPS, width=3, side=c("left"), pad="0")) %>%
  mutate(STATE_FIPS=str_pad(STATE_FIPS, width=2, side=c("left"), pad="0")) %>%
  mutate(GEOID = paste0(STATE_FIPS,COUNTY_FIPS))

states <- mpo %>% select(STATE_FIPS) %>% distinct() %>% pull()
counties <- mpo %>% select(GEOID) %>% distinct() %>% pull()

# Population Data 
mpo_county_data <- NULL
for(yr in safety_yrs) {
  for (st in states) {
  
    c <- mpo %>% filter(STATE_FIPS %in% st) %>% select(COUNTY_FIPS) %>% pull()
  
    pop <- get_acs(geography = "county", state=st, county=c, variables = c("B03002_001"), year = yr, survey = "acs5") %>% 
      select(-moe) %>% 
      mutate(data_year=yr, variable="Population") %>%
      select(-NAME)
  
    ifelse(is.null(mpo_county_data), mpo_county_data <- pop, mpo_county_data <- bind_rows(mpo_county_data,pop))
  
    rm(c, pop)
  }
}

mpo_county_data <- left_join(mpo, mpo_county_data, by="GEOID")  

psrc <- mpo_county_data %>% 
  filter(MPO_FIPS=="PSRC") %>%
  select(COUNTY_NAME, variable, estimate, data_year) %>%
  rename(geography=COUNTY_NAME) %>%
  mutate(geography=paste0(geography, " County")) %>%
  mutate(metric="Fatality Rate", geography_type="PSRC Region", share=0, moe=0, share_moe=0, grouping="All")

metros <- mpo_county_data %>%
  select(MPO_AREA, variable, estimate, data_year) %>%
  rename(geography=MPO_AREA) %>%
  group_by(geography, variable, data_year) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble() %>%
  mutate(metric="Fatality Rate", geography_type="Metro Regions", share=0, moe=0, share_moe=0, grouping="All")

fars_data <- bind_rows(psrc,metros)
rm(mpo_county_data, psrc, metros)

# Fatality Data
collision_data <- NULL
for (y in fars_yrs) {
  
  # Open Current Years FARS Accident Data
  all_files <- as.character(unzip(paste0("X:/DSA/shiny-uploads/data/FARS",y,"NationalCSV.zip"), list = TRUE)$Name)
  
  f <- read_csv(unz(paste0("X:/DSA/shiny-uploads/data/FARS",y,"NationalCSV.zip"), all_files[1])) %>%
    mutate(COUNTY_FIPS=str_pad(COUNTY, width=3, side=c("left"), pad="0")) %>%
    mutate(STATE_FIPS=str_pad(STATE, width=2, side=c("left"), pad="0")) %>%
    mutate(GEOID = paste0(STATE_FIPS,COUNTY_FIPS)) %>%
    filter(GEOID %in% counties) %>%
    select(GEOID, FATALS) %>%
    group_by(GEOID) %>%
    summarise(estimate=sum(FATALS)) %>%
    as_tibble %>%
    mutate(data_year=y, variable="Fatalities")
  
  c <- read_csv(unz(paste0("X:/DSA/shiny-uploads/data/FARS",y,"NationalCSV.zip"), all_files[1])) %>%
    mutate(COUNTY_FIPS=str_pad(COUNTY, width=3, side=c("left"), pad="0")) %>%
    mutate(STATE_FIPS=str_pad(STATE, width=2, side=c("left"), pad="0")) %>%
    mutate(GEOID = paste0(STATE_FIPS,COUNTY_FIPS)) %>%
    filter(GEOID %in% counties) %>%
    select(GEOID) %>%
    mutate(FATAL_COLLISIONS = 1) %>%
    group_by(GEOID) %>%
    summarise(estimate =sum(FATAL_COLLISIONS)) %>%
    as_tibble %>%
    mutate(data_year=y, variable="Fatal Collisions")
  
  c <- bind_rows(c,f)
  
  ifelse(is.null(collision_data), collision_data <- c, collision_data <- bind_rows(collision_data,c))
  
  rm(c,f)
  
}

mpo_county_data <- left_join(mpo, collision_data, by="GEOID")

psrc <- mpo_county_data %>% 
  filter(MPO_FIPS=="PSRC") %>%
  select(COUNTY_NAME, variable, estimate, data_year) %>%
  rename(geography=COUNTY_NAME) %>%
  mutate(geography=paste0(geography, " County")) %>%
  mutate(metric="1yr Fatality Rate", geography_type="PSRC Region", share=0, moe=0, share_moe=0, grouping="All")

metros <- mpo_county_data %>%
  select(MPO_AREA, variable, estimate, data_year) %>%
  rename(geography=MPO_AREA) %>%
  group_by(geography, variable, data_year) %>%
  summarise(estimate=sum(estimate)) %>%
  as_tibble() %>%
  mutate(metric="1yr Fatality Rate", geography_type="Metro Regions", share=0, moe=0, share_moe=0, grouping="All")

annual_data <- bind_rows(psrc,metros)
rm(psrc, metros, mpo_county_data)

five_yr_data <- NULL
for (y in safety_yrs) {
  
  c <- annual_data %>% 
    filter(data_year >= y-4 & data_year <=y) %>%
    select(geography, variable, estimate, geography_type) %>%
    group_by(geography, variable, geography_type) %>%
    summarise(estimate=sum(estimate)) %>%
    as_tibble() %>%
    mutate(metric="5yr Fatality Rate", share=0, moe=0, share_moe=0, grouping="All", data_year=y)
  
  ifelse(is.null(five_yr_data), five_yr_data <- c, five_yr_data <- bind_rows(five_yr_data,c))
  
  rm(c)

}

# Trim Final Annual Data to Match the 5yr Average Time Period and Calculate Rate per Capita
annual_data <- annual_data %>% filter(data_year %in% safety_yrs)

# Calculate Per Capita Rates
p <- fars_data %>% select(geography, data_year, estimate) %>% rename(population=estimate)

# Annual Rates
ac <- annual_data %>% filter(variable=="Fatal Collisions") %>% rename(collisions=estimate)
ac <- left_join(ac, p, by=c("geography","data_year"))
ac <- ac %>% mutate(estimate=(collisions/population)*100000, variable="Fatal Collisions per 100,000 People") %>% select(-population, -collisions)

af <- annual_data %>% filter(variable=="Fatalities") %>% rename(collisions=estimate)
af <- left_join(af, p, by=c("geography","data_year"))
af <- af %>% mutate(estimate=(collisions/population)*100000, variable="Fatalities per 100,000 People") %>% select(-population, -collisions)

# 5yr Rates
fc <- five_yr_data %>% filter(variable=="Fatal Collisions") %>% rename(collisions=estimate)
fc <- left_join(fc, p, by=c("geography","data_year"))
fc <- fc %>% mutate(estimate=((collisions/5)/population)*100000, variable="Fatal Collisions per 100,000 People") %>% select(-population, -collisions)

ff <- five_yr_data %>% filter(variable=="Fatalities") %>% rename(collisions=estimate)
ff <- left_join(ff, p, by=c("geography","data_year"))
ff <- ff %>% mutate(estimate=((collisions/5)/population)*100000, variable="Fatalities per 100,000 People") %>% select(-population, -collisions)

fars_data <- bind_rows(fars_data, annual_data, five_yr_data, ac, af, fc, ff)

rm(annual_data, five_yr_data, ac, af, fc, ff, p, collision_data)

# Final Data Output --------------------------------------------------------
rtp_data <- bind_rows(ntd_data, population, housing, employment, modes, vehicles, fars_data)
write_csv(rtp_data, "data/rtp-dashboard-data.csv")
