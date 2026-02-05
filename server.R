# Define server logic
shinyServer(function(input, output) {
  
  footer_server('psrcfooter')

  # Overview Page -----------------------------------------------------------
  
  overview_server('OVERVIEW')
  output$howto_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview-HowTo", page_info = "description"))})
  
  # Climate Page -----------------------------------------------------------

  output$climate_section_ui <- renderUI({
    switch(input$climate_section,
           "zev" = climate_zev_ui("zev"),
           "vmt" = climate_vmt_ui("vmt"),
           "wfh" = climate_wfh_ui("wfh")
    )
  })
  
  output$climate_overview <- renderUI({
    HTML(page_information(tbl=page_text, 
                          page_name="Climate", 
                          page_section = "Overview", 
                          page_info = "description"))
  })
  
  loaded <- reactiveValues(
    zev = FALSE,
    vmt = FALSE,
    wfh = FALSE
  )
  
  observeEvent(input$climate_section, {
    if (input$climate_section == "zev" && !loaded$zev) {
      climate_zev_server("zev")
      loaded$zev <- TRUE
    }
    
    if (input$climate_section == "vmt" && !loaded$vmt) {
      climate_vmt_server("vmt")
      loaded$vmt <- TRUE
    }
    
    if (input$climate_section == "wfh" && !loaded$wfh) {
      climate_wfh_server("wfh")
      loaded$wfh <- TRUE
    }
  })
  
  # Transit Page -----------------------------------------------------------
  
  output$transit_overview <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITOverview", page_info = "description"))})
  
  value_box_server('TRANSITMETRICvaluebox', 
                   df = transit_data |> 
                     filter(!(grouping == "Forecast" & year <= transit_current_year)) |>
                     mutate(estimate = estimate / 1000000),
                   by = transit_base_year,
                   bv = "All Transit Modes",
                   vy = transit_vision_year,
                   vv = "All Transit Modes",
                   cy = transit_current_year,
                   cv = "All Transit Modes",
                   hy = transit_horizon_year,
                   hv = "All Transit Modes",
                   gr = c("Annual", "Forecast"),
                   ge = "Region",
                   me = "Boardings",
                   ti = "annual boardings",
                   fac = 1,
                   dec = 1,
                   s = " million",
                   val = "estimate")
  
  line_chart_metric_server('TRANSITlinechart', 
                           df = transit_data, 
                           v = c("All Transit Modes"), 
                           g = c("Region"),
                           gr = c("Annual", "Forecast"),
                           color = c("#91268F", "#F05A28"), 
                           d = "no",
                           ch = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"),
                           s = "Source: USDOT Federal Transit Administration (FTA) National Transit Database",
                           x = "year",
                           y = "estimate",
                           f = "grouping",
                           p = "no",
                           dp = 0)
  
  output$transit_metric_mode <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITMETRICMode", page_info = "description"))})
  
  column_chart_transit_modes_server('TRANSITMETRICmode',
                                    df = transit_data |> filter(year >= pre_covid),
                                    ch = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"),
                                    s = "Source: USDOT Federal Transit Administration (FTA) National Transit Database")
  
  output$transit_metric_metro <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITMETRICMetro", page_info = "description"))})
  
  bar_chart_metric_server('TRANSITMETRICmetro',
                          df = transit_data |> filter(geography_type == "Metro Areas" & grouping == "COVID Recovery"),
                          x = "geography",
                          y = "estimate",
                          f = "plot_id",
                          color = c("#8CC63E", "#91268F"),
                          h = "600px",
                          ch = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"),
                          p = "yes",
                          d = 0,
                          s = "Source: USDOT Federal Transit Administration (FTA) National Transit Database")
  
  value_box_server('TRANSITMODEvaluebox', 
                   df = commute_data,
                   by = wfh_base_year,
                   bv = "Transit",
                   vy = wfh_vision_year,
                   vv = "Transit",
                   cy = wfh_vmt_year,
                   cv = "Transit",
                   hy = wfh_horizon_year,
                   hv = "Transit",
                   gr = "All",
                   ge = "Region",
                   me = "commute-modes",
                   ti = "share of workers who used public transportation to get to work",
                   fac = 100,
                   dec = 0,
                   s = "%",
                   val = "share")
  
  output$transit_mode_region <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITRegion", page_info = "description"))})
  
  column_chart_server('TRANSITcounty',
                      df = commute_data,
                      v = "Transit",
                      ch = acs_yrs,
                      s = "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties",
                      me = "commute-modes",
                      gr = "All",
                      gt = "County",
                      val = "share",
                      p = "yes",
                      dp = 1)
  
  output$transit_mode_race <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITRace", page_info = "description"))})
  
  mepeople_chart_server('TRANSITrace',
                        df = commute_data,
                        ch = pums_yrs,
                        s = "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties",
                        me = "Commute Mode",
                        v = "Transit",
                        gt = "Race",
                        val = "share",
                        grp = "grouping",
                        icon_pth = "www/bus-solid-full.svg",
                        icon_clr = "#4C4C4C",
                        data_max = 20,
                        per_icons = 1)

  output$transit_mode_metro <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITMetro", page_info = "description"))})
  
  bar_chart_server('TRANSITmetro',
                   df = commute_data |> filter(geography_type == "Metro Areas" & variable == "Transit"),
                   x = "geography",
                   y = "share",
                   f = "plot_id",
                   color = c("#8CC63E", "#91268F"),
                   h = "600px",
                   ch = acs_yrs,
                   p = "yes",
                   d = 0,
                   s = "Source: ACS 5yr Data Table B08301")

  output$transit_mode_city <- renderUI({HTML(page_information(tbl=page_text, page_name="Transit", page_section = "TRANSITCity", page_info = "description"))})
  
  bar_chart_server('TRANSITcity',
                   df = commute_data |> filter(geography_type == "City" & variable == "Transit"),
                   x = "geography",
                   y = "share",
                   f = "plot_id",
                   color = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"),
                   h = "1400px",
                   ch = acs_yrs,
                   p = "yes",
                   d = 0,
                   s = "Source: ACS 5yr Data Table B08301")
  
  
})  


  