# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$population_vision_text <- renderText({pop_vision_caption})
  
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

    # Charts
    output$chart_population_growth <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Population" & variable=="Total" & geography=="Region" & data_year>=2000), 
                                                                      x='data_year', y='estimate', fill='metric', est="number", 
                                                                      title="Regional Population: 2000 to 2050",
                                                                      xtype= "Continuous",
                                                                      lwidth = 2,
                                                                      breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      color = "pgnobgy_5")})
    
    output$chart_population_growth_hct <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Population"), 
                                                                           x='data_year', y='share', fill='geography', est="percent", 
                                                                           title="Share of Regional Population Growth near HCT: 2010 to 2022",
                                                                           xtype= "Continuous",
                                                                           lwidth = 2,
                                                                           breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                                                                           color = "pgnobgy_5") %>% layout(yaxis = list(range = c(0,1)))})
    
    output$fatal_collisions_chart <- renderPlotly({interactive_line_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography=="Seattle" & variable%in%c("Fatal Collisions","Fatalities")),
                                                                   x='data_year', y='estimate', fill='variable', est="number", 
                                                                   title="Fatal Collisions by Year in the PSRC Region: 2010 to 2020",
                                                                   xtype= "Continuous",
                                                                   lwidth = 2,
                                                                   breaks = c("2010","2015","2020"),
                                                                   color = "pgnobgy_5")})

    output$county_fatal_collisions_chart <- renderPlot({create_facet_bar_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography_type=="PSRC Region" & variable%in%c("Fatal Collisions") & data_year >= 2015), 
                                                                        w.x="data_year", w.y="estimate", 
                                                                        f="data_year", g="geography", 
                                                                        est.type = "number",
                                                                        w.title="Fatal Collisions by County: 2015 to 2020",
                                                                        w.facet=2, w.scales="fixed") +
        ggplot2::theme(axis.title = ggplot2::element_blank(), 
                       legend.position = "none")})
    
    output$mpo_fatal_rate_min_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_min,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5',
                                                                       title=paste0('Annual Fatalities per 100,000 people: ',safety_min_year))})
    
    output$mpo_fatal_rate_max_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_max,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5',
                                                                       title=paste0('Annual Fatalities per 100,000 people: ',safety_max_year))})
    
    output$ev_share_new_registrations_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="New Vehicle Registrations" & geography=="Region"),
                                                                                      y='share', x='date', fill='variable', pos = "stack",
                                                                                      est="percent", dec=0, color='pgnobgy_5',
                                                                                      title=(paste0('Share of New Vehicle Registrations')))})
    
    output$ev_zipcode_map <- renderLeaflet({create_share_map(lyr=ev_zipcodes, title="ZEV Share")})
    
    
    output$chart_total_vmt <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & geography=="Region" & data_year>=2000), 
                                                                           x='data_year', y='estimate', fill='metric', est="number", 
                                                                           title="Regional Vehicle Miles Traveled: 2000 to 2050",
                                                                           xtype= "Continuous",
                                                                           lwidth = 2,
                                                                           breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                           color = "pgnobgy_5")})
    
    output$chart_per_capita_vmt <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="per Capita" & geography=="Region" & data_year>=2000), 
                                                                   x='data_year', y='estimate', fill='metric', est="number", 
                                                                   title="Regional VMT per Capita: 2000 to 2050",
                                                                   xtype= "Continuous",
                                                                   lwidth = 2, dec=1,
                                                                   breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                   color = "pgnobgy_5")})
    
    output$chart_total_vmt_county <- renderPlot({create_facet_bar_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & metric=="Observed VMT" & geography!="Region" & data_year>=2015 & data_year<=2021), 
                                                                        w.x="data_year", w.y="estimate", 
                                                                        f="data_year", g="geography", 
                                                                        est.type = "number",
                                                                        w.title="Daily Vehicle Miles Traveled by County: 2015 to 2021",
                                                                        w.facet=2, w.scales="fixed") +
        ggplot2::theme(axis.title = ggplot2::element_blank(), 
                       legend.position = "none")})
    
    output$chart_vkt_per_capita <- renderPlotly({interactive_bar_chart(t=vkt_data,
                                                                       y='geography', x='vkt', fill='plot_id',
                                                                       est="number", dec=0, color='pgnobgy_10',
                                                                       title=(paste0('Annual Vehicle Kilometers Traveled per Capita'))) %>% layout(showlegend = FALSE)})
    
    
    
})    

