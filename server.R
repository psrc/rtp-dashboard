# # Define server logic
# shinyServer(function(input, output) {
#   
#   
#   # Growth Page
#   banner_server('growthBanner', 
#                 banner_title = "Planning for Growth", 
#                 banner_subtitle = "VISION 2050",
#                 banner_url = "https://www.psrc.org/planning-2050/vision-2050")
#   
#   left_panel_server('leftGrowth', page_nm = "Growth")
#   growth_overview_server('growthOverview')
#   growth_server('PopHsgJobgrowth')
#   
#   # Safety Page
#   banner_server('safetyBanner', 
#                 banner_title = "Addressing Safety: Safe System Approach", 
#                 banner_subtitle = "Regional Transportation Plan",
#                 banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
#   
#   left_panel_server('leftSafety', page_nm = "Safety")
#   safety_overview_server('safetyOverview')
#   safety_geography_server('Geographysafety')
#   safety_demographics_server('Demographicsafety')
#   safety_other_server('Othersafety')
#   
#   # Transit Page
#   banner_server('transitBanner', 
#                 banner_title = "Transit Performance", 
#                 banner_subtitle = "Regional Transportation Plan",
#                 banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
#   
#   left_panel_server('leftTransit', page_nm = "Transit")
#   transit_overview_server('transitOverview')
#   transit_metrics_server('Metricstransit')
#   modeshare_server('Modetransit')
#   
#   # Modes Page
#   banner_server('modeBanner', 
#                 banner_title = "Alternative Modes of Transportation", 
#                 banner_subtitle = "Regional Transportation Plan",
#                 banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
#   
#   left_panel_server('leftMode', page_nm = "Modes")
#   mode_overview_server('modeOverview')
#   walk_server('Walkmode')
#   bike_server('Bikemode')
#   
#   # Travel Time Page
#   banner_server('timeBanner', 
#                 banner_title = "Travel Time & Congestion", 
#                 banner_subtitle = "Regional Transportation Plan",
#                 banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
#   
#   left_panel_server('leftTime', page_nm = "Travel-Time")
#   time_overview_server('timeOverview')
#   tt_server('TTtime')
#   dt_server('DTtime')
#   congestion_server('Congestiontime')
#   
#   # Projects Page
#   banner_server('projectsBanner', 
#                 banner_title = "Funding", 
#                 banner_subtitle = "Programs at PSRC",
#                 banner_url = "https://www.psrc.org/our-work/funding")
#   
#   left_panel_server('leftProjects', page_nm = "Projects")
#   projects_overview_server('projectsOverview')
#   project_selection_server('Projectsselection')
#   tip_server('Projectstip')
#   
#   # Data Sources
#   source_server('dataSource')
#   
#   # Data Download
#   output$downloadData <- downloadHandler(
#     filename = "PSRC RTP Monitoring Data Download.xlsx",
#     content = function(file) {saveWorkbook(create_public_spreadsheet(download_table_list), file = file)},
#     contentType = "application/Excel"
#   )
#   
# })    

shinyServer(function(input, output) {
  
  footer_server('psrcfooter')
  
  # Overview Page -----------------------------------------------------------
  
  overview_server('OVERVIEW')
  output$howto_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview-HowTo", page_info = "description"))})
  
  # Climate Page -----------------------------------------------------------
  
  output$climate_overview <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "Overview", page_info = "description"))})
  output$climate_registrations_region <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "RegistrationsRegion", page_info = "description"))})
  output$climate_registrations_tract <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "RegistrationsTract", page_info = "description"))})
  
  # Vehicle Registrations
  value_box_registrations_server('REGIONregistrationvaluebox', df=region_registrations)
  
  line_chart_server('REGISTRATIONSlinechart', 
                    df = climate_data, 
                    m = c("vehicle-registrations"),
                    v = c("Battery Electric Vehicle", "Hybrid Electric Vehicle", "Internal Combustion Engine", "Plug-in Hybrid Electric Vehicle"), 
                    g = c("Region"), 
                    color = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"), 
                    d = "yes",
                    ch = c("New", "Used"),
                    s = "Source: Washington State Department of Licensing",
                    x = "date",
                    y = "share",
                    f = "variable",
                    p = "yes",
                    dp = 1)
  
  output$ev_tract_map <- renderLeaflet({create_share_map(lyr=ev_by_tract, title="ZEV Share", efa_lyr=efa_income, efa_title="Equiy Focus Area: Income")})
  
  # Region Vehicle Miles Traveled
  line_chart_server('VMTlinechart', 
                    df = vmt_data, 
                    m = c("Vehicle Miles Traveled"), 
                    v = c("Observed", "Forecast"), 
                    g = c("Region"),
                    color = c("#91268F", "#F05A28"), 
                    d = "no",
                    ch = c("Total", "per Capita"),
                    s = "Source: Washington State Department of Transportation HPMS and SoundCast Model",
                    x = "year",
                    y = "estimate",
                    f = "variable",
                    p = "no",
                    dp = 1)
  
  output$climate_vmt_region <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "VMTRegion", page_info = "description"))})
  
  value_box_server('VMTvaluebox', 
                   df = vmt_data,
                   by = climate_base_year,
                   bv = "Observed",
                   vy = climate_vision_year,
                   vv = "Observed",
                   cy = climate_vmt_year,
                   cv = "Observed",
                   hy = climate_horizon_year,
                   hv = "Forecast",
                   gr = "per Capita",
                   ge = "Region",
                   me = "Vehicle Miles Traveled",
                   ti = "daily vehicle miles per capita",
                   fac = 1,
                   dec = 1,
                   s = "",
                   val = "estimate")
  
  # County Vehicle Miles Traveled
  column_chart_counties_server('VMTcounty',
                            df = vmt_data,
                            v = c("Observed"),
                            ch = c("Total", "per Capita"),
                            s = "Source: Washington State Department of Transportation Highway Performance Monitoring System")
  
  output$climate_vmt_county <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "VMTCounty", page_info = "description"))})
  
  # National Vehicle Kilometers Traveled Annual Comparison
  
  output$climate_vkt_compare <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "VKTCompare", page_info = "description"))})
  
  bar_chart_server('VKTcompare',
                   df = vkt_data,
                   x = "geography",
                   y = "estimate",
                   f = "plot_id",
                   color = c("#8CC63E", "#F05A28", "#00A7A0","#999999", "#91268F"),
                   h = "600px",
                   s = "Source: Washington State Department of Transportation Highway Performance Monitoring System, SoundCast")
  
  
  # Work from Home
  
  output$climate_wfh_region <- renderUI({HTML(page_information(tbl=page_text, page_name="Climate", page_section = "WFHRegion", page_info = "description"))})
  
  value_box_server('WFHvaluebox', 
                   df = commute_data,
                   by = wfh_base_year,
                   bv = "Work from Home",
                   vy = wfh_vision_year,
                   vv = "Work from Home",
                   cy = wfh_vmt_year,
                   cv = "Work from Home",
                   hy = wfh_horizon_year,
                   hv = "Work from Home",
                   gr = "All",
                   ge = "Region",
                   me = "commute-modes",
                   ti = "share of workers who worked from home",
                   fac = 100,
                   dec = 0,
                   s = "%",
                   val = "share")
  
  column_chart_server('WFHcounty',
                      df = commute_data,
                      v = "Work from Home",
                      ch = c(2023, 2018, 2013),
                      s = "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties",
                      me = "commute-modes",
                      gr = "All",
                      gt = "County",
                      val = "share",
                      p = "yes",
                      dp = 1)
  
  
  #df, v, ch, s, me,gr, gt
  
})  
  