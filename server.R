# Define server logic
shinyServer(function(input, output) {
  
  # Modules
  footer_server('psrcfooter')
  
  banner_server('overviewBanner', 
                banner_title = "RTP Performance Dashboard", 
                banner_subtitle = "Planning for 2050",
                banner_url = "https://www.psrc.org/planning-2050")
  
  left_panel_server('leftOverview', page_nm = "Overview")
  
  
  output$growth_text_1 <- renderText({growth_overview_1})
  
  output$growth_text_2 <- renderText({growth_overview_2})
  
  output$growth_text_3 <- renderText({growth_overview_3})
  
  output$population_vision_text <- renderText({pop_vision_caption})
  
  output$population_hct_text <- renderText({pop_hct_caption})
  
  output$housing_text_1 <- renderText({housing_overview_1})
  
  output$housing_text_2 <- renderText({housing_overview_2})
  
  output$housing_vision_text <- renderText({housing_vision_caption})
  
  output$housing_hct_text <- renderText({housing_hct_caption})
  
  output$employment_overview_text <- renderText({employment_overview})
  
  output$employment_hct_text <- renderText({employment_hct_caption})
  
  output$jobs_vision_text <- renderText({jobs_vision_caption})
  
  output$safety_text <- renderText({safety_caption})
  
  output$region_fatal_text <- renderText({fatal_trends_caption})
  
  output$climate_text_1 <- renderText({climate_overview_1})
  
  output$climate_text_2 <- renderText({climate_overview_2})
  
  output$climate_text_3 <- renderText({climate_overview_3})
  
  output$climate_text_4 <- renderText({climate_overview_4})
  
  output$regional_ev_text <- renderText({ev_registration_caption})
  
  output$zipcode_ev_text <- renderText({ev_zipcode_caption})
  
  output$regional_vmt_text <- renderText({vmt_caption})
  
  output$county_vmt_text <- renderText({vmt_county_caption})
  
  output$vkt_text <- renderText({vkt_caption})
  
  output$safety_text_1 <- renderText({safety_overview_1})
  
  output$safety_text_2 <- renderText({safety_overview_2})
  
  output$safety_text_3 <- renderText({safety_overview_3})
  
  output$safety_text_4 <- renderText({safety_overview_4})
  
  output$safety_text_5 <- renderText({safety_overview_5})
  
  output$fatal_county_text <- renderText({fatal_county_caption})
  
  output$fatal_mpo_text <- renderText({fatal_mpo_caption})
  
  output$transit_text_1 <- renderText({transit_overview_1})
  
  output$transit_text_2 <- renderText({transit_overview_2})
  
  output$transit_text_3 <- renderText({transit_overview_3})
  

  # Charts
  
  # Climate
  output$ev_share_new_registrations_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="New Vehicle Registrations" & geography=="Region") %>% mutate(date=as.character(date)),
                                                                                    y='share', x='date', fill='variable', pos = "stack",
                                                                                    est="percent", dec=0, color='pgnobgy_5') %>% plotly::layout(showlegend=FALSE)})
  
  output$ev_zipcode_map <- renderLeaflet({create_share_map(lyr=ev_zipcodes, title="ZEV Share")})
  
  output$chart_total_vmt <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & geography=="Region" & data_year>=2000), 
                                                                 x='data_year', y='estimate', fill='metric', est="number",
                                                                 lwidth = 2,
                                                                 breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                 color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(40000000,120000000), labels=scales::label_comma()))})
  
  output$chart_per_capita_vmt <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="per Capita" & geography=="Region" & data_year>=2000), 
                                                                      x='data_year', y='estimate', fill='metric', est="number",
                                                                      lwidth = 2, dec=1,
                                                                      breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(10,30), labels=scales::label_comma()))})
  
  output$chart_total_vmt_county <- renderPlot({static_facet_column_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & metric=="Observed VMT" & geography!="Region" & data_year>as.character(current_vmt_year-5)), 
                                                                         x="data_year", y="estimate", 
                                                                         fill="data_year", facet="geography", 
                                                                         est = "number",
                                                                         color = "pgnobgy_10",
                                                                         ncol=2, scales="free")})
  
  output$chart_vkt_per_capita <- renderPlotly({interactive_bar_chart(t=vkt_data,
                                                                     y='geography', x='vkt', fill='plot_id',
                                                                     est="number", dec=0, color='pgnobgy_10') %>% layout(showlegend = FALSE)})
  
  
    
  output$chart_population_growth <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Population" & variable=="Total" & geography=="Region" & data_year>=base_year), 
                                                                      x='data_year', y='estimate', fill='metric', est="number",
                                                                      lwidth = 2,
                                                                      breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      color = "pgnobgy_5")})
    
    
  output$chart_population_growth_hct <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Population"), 
                                                                                                        x='data_year', y='share', fill='geography', est="percent",
                                                                                                        lwidth = 2,
                                                                                                        breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                                                                                                        color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
 
  output$chart_housing_growth <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Total" & variable=="Total Housing Units" & geography=="Region" & data_year>=base_year), 
                                                                           x='data_year', y='estimate', fill='metric', est="number",
                                                                           lwidth = 2,
                                                                           breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                           color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(1000000,3000000), labels=scales::label_comma()))})
    
  output$chart_housing_growth_hct <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Housing Units"), 
                                                                                                        x='data_year', y='share', fill='geography', est="percent",
                                                                                                        lwidth = 2,
                                                                                                        breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                                                                                                        color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
    
  output$chart_employment_growth <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Total Employment" & variable=="Total" & geography=="Region" & data_year>=base_year), 
                                                                         x='data_year', y='estimate', fill='metric', est="number",
                                                                         lwidth = 2,
                                                                         breaks = c("2010","2020","2030","2040","2050"),
                                                                         color = "pgnobgy_5")})  
  
  output$chart_employment_growth_hct <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Employment Growth Inside HCT Area" & variable=="Inside HCT Area"), 
                                                                                                      x='data_year', y='share', fill='metric', est="percent", 
                                                                                                      lwidth = 2,
                                                                                                      breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021"),
                                                                                                      color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
  
    
    output$fatal_collisions_chart <- renderPlotly({interactive_line_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography=="Seattle" & variable%in%c("Fatal Collisions","Fatalities")),
                                                                   x='data_year', y='estimate', fill='variable', est="number",
                                                                   lwidth = 2,
                                                                   breaks = c("2010","2015","2020"),
                                                                   color = "pgnobgy_5")})

    output$county_fatal_collisions_chart <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography_type=="PSRC Region" & variable%in%c("Fatal Collisions") & data_year>as.character(safety_max_year-5)), 
                                                                        x="data_year", y="estimate", 
                                                                        fill="data_year", facet="geography", 
                                                                        est = "number",
                                                                        color = "pgnobgy_10",
                                                                        ncol=2, scales="fixed")})
    
    output$mpo_fatal_rate_min_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_min,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5')})
    
    output$mpo_fatal_rate_max_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_max,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5')})
    
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
    
    output$commute_mode_walk_est_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Walked"),
                                                                                 y='estimate', x='geography', moe="estimate_moe", fill='data_year', pos = "dodge",
                                                                                 est="number", color='pgnobgy_10')})
    
    output$commute_mode_walk_share_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Walked"),
                                                                                   y='share', x='geography', moe="share_moe", fill='data_year', pos = "dodge",
                                                                                   est="percent", dec=1, color='pgnobgy_10')})
    
    output$commute_mode_bike_est_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Bicycle"),
                                                                                 y='estimate', x='geography', moe="estimate_moe", fill='data_year', pos = "dodge",
                                                                                 est="number", color='pgnobgy_10')})
    
    output$commute_mode_bike_share_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Bicycle"),
                                                                                   y='share', x='geography', moe="share_moe", fill='data_year', pos = "dodge",
                                                                                   est="percent", dec=1, color='pgnobgy_10')})
    
})    

