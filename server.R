# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$population_vision_text <- renderText({pop_vision_caption})
  
  output$safety_text <- renderText({safety_caption})
  
  output$region_fatal_text <- renderText({fatal_trends_caption})

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
    
    
})    

