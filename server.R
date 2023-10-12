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
                banner_title = "Addressing Safety: Target Zero", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftSafety', page_nm = "Safety")
  safety_overview_server('safetyOverview')
  fatal_server('Fatalsafety')
  serious_server('Serioussafety')
  
  # Modes
  banner_server('modeBanner', 
                banner_title = "Alternative Modes of Transportation", 
                banner_subtitle = "Regional Transportation Plan",
                banner_url = "https://www.psrc.org/planning-2050/regional-transportation-plan")
  
  left_panel_server('leftMode', page_nm = "Modes")
  mode_overview_server('modeOverview')
  walk_server('Walkmode')
  bike_server('Bikemode')
  telework_server('WFHmode')
  

  


  output$transit_text_1 <- renderText({transit_overview_1})
  
  output$transit_text_2 <- renderText({transit_overview_2})
  
  output$transit_text_3 <- renderText({transit_overview_3})
  

  # Charts
  

    output$chart_transit_boardings <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Annual Transit Boardings" & geography=="Region" & variable =="All Transit Modes") %>% mutate(grouping=gsub("PSRC Region", "Observed",grouping)), 
                                                                                                    x='data_year', y='estimate', fill='grouping', est="number", 
                                                                                                    lwidth = 2,
                                                                                                    breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                                    color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,800000000), labels=scales::label_comma()))})
    
    output$chart_boardings_mode <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="YTD Transit Boardings" & geography=="Region" & variable!="All Transit Modes" & data_year>as.character(as.integer(current_population_year)-5)), 
                                                                        x="data_year", y="estimate", 
                                                                        fill="data_year", facet="variable", 
                                                                        est = "number",
                                                                        color = "pgnobgy_10",
                                                                        ncol=2, scales="free")})
    
    
    output$mpo_boardings_precovid_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_boardings_precovid,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=0, color='pgnobgy_5')})
    
    output$mpo_boardings_today_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_boardings_today,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=0, color='pgnobgy_5')})

    output$chart_transit_hours <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Annual Transit Revenue-Hours" & geography=="Region" & variable =="All Transit Modes") %>% mutate(grouping=gsub("PSRC Region", "Observed",grouping)), 
                                                                                                x='data_year', y='estimate', fill='grouping', est="number", 
                                                                                                lwidth = 2,
                                                                                                breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                                color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,14000000), labels=scales::label_comma()))})
    
    output$chart_hours_mode <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="YTD Transit Revenue-Hours" & geography=="Region" & variable!="All Transit Modes" & data_year>as.character(as.integer(current_population_year)-5)), 
                                                                      x="data_year", y="estimate", 
                                                                      fill="data_year", facet="variable", 
                                                                      est = "number",
                                                                      color = "pgnobgy_10",
                                                                      ncol=2, scales="free")})
    
    
    output$mpo_hours_precovid_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_hours_precovid,
                                                                               y='geography', x='estimate', fill='plot_id',
                                                                               est="number", dec=0, color='pgnobgy_5')})
    
    output$mpo_hours_today_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_hours_today,
                                                                        y='geography', x='estimate', fill='plot_id',
                                                                        est="number", dec=0, color='pgnobgy_5')})
    
    output$transit_ms_region_chart <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Mode to Work" & geography=="Region" & variable=="Public transportation") %>% mutate(date=as.character(date)), 
                                                                                                    x='data_year', y='share', fill='variable', est="percent", 
                                                                                                    lwidth = 2,
                                                                                                    breaks = c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021"),
                                                                                                    color='obgnpgy_10') + ggplot2::scale_y_continuous(limits=c(0,0.25), labels=scales::label_percent()))})
    
    output$transit_ms_king_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Mode to Work" & geography=="King County" & variable=="Public transportation") %>% mutate(date=as.character(date)),
                                                                             y='share', x='data_year', fill='data_year',
                                                                             est="percent", dec=0, color='obgnpgy_10')})
    
    output$transit_ms_kitsap_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Mode to Work" & geography=="Kitsap County" & variable=="Public transportation") %>% mutate(date=as.character(date)),
                                                                           y='share', x='data_year', fill='data_year',
                                                                           est="percent", dec=0, color='obgnpgy_10')})
    
    output$transit_ms_pierce_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Mode to Work" & geography=="Pierce County" & variable=="Public transportation") %>% mutate(date=as.character(date)),
                                                                           y='share', x='data_year', fill='data_year',
                                                                           est="percent", dec=0, color='obgnpgy_10')})
    
    output$transit_ms_snohomish_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Mode to Work" & geography=="Snohomish County" & variable=="Public transportation") %>% mutate(date=as.character(date)),
                                                                           y='share', x='data_year', fill='data_year',
                                                                           est="percent", dec=0, color='obgnpgy_10')})
    
    
    output$transit_ms_city_chart <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="City" & variable=="Public transportation" & data_year==input$Transit_MS_Year) %>% 
                                                                          mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                        x='share', y='low_high', fill='variable',
                                                                        est="percent", dec=0, color='pognbgy_5')})
    
    output$transit_ms_mpo_pre_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(input$Transit_MPO_MS_Year)-5))})
    
    output$transit_ms_mpo_today_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(input$Transit_MPO_MS_Year)))})
    
    output$transit_ms_mpo_chart_today <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="Metro Regions" & variable=="Public transportation" & data_year==input$Transit_MPO_MS_Year) %>% 
                                                                            mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                        x='share', y='low_high', fill='variable',
                                                                        est="percent", dec=0, color='gnbopgy_5')})
    
    output$transit_ms_mpo_chart_pre <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="Metro Regions" & variable=="Public transportation" & data_year==as.character(as.integer(input$Transit_MPO_MS_Year)-5)) %>% 
                                                                               mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                             x='share', y='low_high', fill='variable',
                                                                             est="percent", dec=0, color='obgnpgy_5')})
    
    output$transit_ms_race_pre_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(input$Transit_Race_MS_Year)-5))})
    
    output$transit_ms_race_today_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(input$Transit_Race_MS_Year)))})
    
    
    output$transit_ms_race_chart_today <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & variable=="Transit" & geography_type=="PSRC Region Race & Ethnicity" & data_year==input$Transit_Race_MS_Year) %>% 
                                                                                                      mutate(grouping = gsub(" alone","", grouping)) %>%
                                                                                                      mutate(low_high=forcats::fct_reorder(grouping, -share)),
                                                                                                    y='share', x='low_high', fill='variable', moe='share_moe',
                                                                                                    est="percent", dec=0, color='blues_dec')})
    
    output$transit_ms_race_chart_pre <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Simplified Commute Mode" & variable=="Transit" & geography_type=="PSRC Region Race & Ethnicity" & data_year==as.character(as.integer(input$Transit_Race_MS_Year)-5)) %>% 
                                                                                                      mutate(low_high=forcats::fct_reorder(grouping, -share)),
                                                                                                    x='share', y='low_high', fill='variable',
                                                                                                    est="percent", dec=0, color='gnbopgy_5')})
    
   
})    

