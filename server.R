# Define server logic
shinyServer(function(input, output) {
  
  # Footer
  footer_server('psrcfooter')
  
  # Main Overview Page
  banner_server('overviewBanner', 
                banner_title = "RTP Performance Dashboard", 
                banner_subtitle = "Planning for 2050",
                banner_url = "https://www.psrc.org/planning-2050")
  
  left_panel_server('leftOverview', page_nm = "Overview")
  
  # Climate Page
  banner_server('climateBanner', 
                banner_title = "Addressing Climate Change", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftClimate', page_nm = "Climate")
  climate_overview_server('climateOverview')
  climate_zev_server('ZEVclimate')
  climate_vmt_server('VMTclimate')
  
  # Growth Page
  banner_server('growthBanner', 
                banner_title = "Planning for Growth", 
                banner_subtitle = "VISION 2050",
                banner_url = "https://www.psrc.org/planning-2050/vision-2050")
  
  left_panel_server('leftGrowth', page_nm = "Growth")
  growth_overview_server('growthOverview')
  population_server('Populationgrowth')
  housing_server('Housinggrowth')
  jobs_server('Jobsgrowth')
  
  # Safety Page
  banner_server('safetyBanner', 
                banner_title = "Addressing Safety: Safe System Approach", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftSafety', page_nm = "Safety")
  safety_overview_server('safetyOverview')
  safety_geography_server('Geographysafety')
  safety_demographics_server('Demographicsafety')
  
  # Modes Page
  banner_server('modeBanner', 
                banner_title = "Alternative Modes of Transportation", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftMode', page_nm = "Modes")
  mode_overview_server('modeOverview')
  walk_server('Walkmode')
  bike_server('Bikemode')
  telework_server('WFHmode')
  
  # Transit Page
  banner_server('transitBanner', 
                banner_title = "Transit Performance", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftTransit', page_nm = "Transit")
  transit_overview_server('transitOverview')
  boardings_server('Boardingstransit')
  revhours_server('Hourstransit')
  modeshare_server('Modetransit')

})    
