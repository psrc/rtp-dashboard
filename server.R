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
  dashboard_overview_server('Mainoverview')
  
  # Climate Page
  banner_server('climateBanner', 
                banner_title = "Addressing Climate Change", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftClimate', page_nm = "Climate")
  climate_overview_server('climateOverview')
  climate_zev_server('ZEVclimate')
  climate_vmt_server('VMTclimate')
  telework_server('WFHmode')
  
  # Growth Page
  banner_server('growthBanner', 
                banner_title = "Planning for Growth", 
                banner_subtitle = "VISION 2050",
                banner_url = "https://www.psrc.org/planning-2050/vision-2050")
  
  left_panel_server('leftGrowth', page_nm = "Growth")
  growth_overview_server('growthOverview')
  growth_server('PopHsgJobgrowth')
  
  # Safety Page
  banner_server('safetyBanner', 
                banner_title = "Addressing Safety: Safe System Approach", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftSafety', page_nm = "Safety")
  safety_overview_server('safetyOverview')
  safety_geography_server('Geographysafety')
  safety_demographics_server('Demographicsafety')
  safety_other_server('Othersafety')
  
  # Transit Page
  banner_server('transitBanner', 
                banner_title = "Transit Performance", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftTransit', page_nm = "Transit")
  transit_overview_server('transitOverview')
  transit_metrics_server('Metricstransit')
  modeshare_server('Modetransit')
  
  # Modes Page
  banner_server('modeBanner', 
                banner_title = "Alternative Modes of Transportation", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftMode', page_nm = "Modes")
  mode_overview_server('modeOverview')
  walk_server('Walkmode')
  bike_server('Bikemode')
  
  # Travel Time Page
  banner_server('timeBanner', 
                banner_title = "Travel Time & Congestion", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftTime', page_nm = "Travel-Time")
  time_overview_server('timeOverview')
  tt_server('TTtime')
  dt_server('DTtime')
  congestion_server('Congestiontime')
  
  # Data Sources
  source_server('dataSource')
  
  # Data Download
  output$downloadData <- downloadHandler(
    filename = "PSRC RTP Monitoring Data Download.xlsx",
    content = function(file) {saveWorkbook(create_public_spreadsheet(download_table_list), file = file)},
    contentType = "application/Excel"
  )
  
})    
