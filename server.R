# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$population_vision_text <- renderText({pop_vision_caption})

    # Charts
    output$chart_population_growth <- renderPlot({create.line.chart(t=data %>% filter(metric=="Population" & data_year>=2000), 
                                                                      w.x='data_year', w.y='estimate', w.g='variable', est.type="number", 
                                                                      w.title="Regional Population: 2000 to 2050",
                                                                      x.type= "Continuous",
                                                                      w.lwidth = 3,
                                                                      w.breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      w.color = "pgnobgy_5",
                                                                      w.interactive = 'no') +
        scale_y_continuous(labels = scales::comma, limits = c(2000000,6000000)) +
        ggplot2::theme(axis.title = ggplot2::element_blank())})
    
   
    output$fatal_collisions_chart <- renderPlot({create.line.chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography=="Seattle" & variable%in%c("Fatal Collisions","Fatalities")),
                                                                   w.x='data_year', w.y='estimate', w.g='variable', est.type="number", 
                                                                   w.title="Fatal Collisions by Year in the PSRC Region: 2010 to 2020",
                                                                   x.type= "Continuous",
                                                                   w.lwidth = 3,
                                                                   w.breaks = c("2010","2015","2020"),
                                                                   w.color = "pgnobgy_5",
                                                                   w.interactive = 'no') +
        scale_y_continuous(labels = scales::comma, limits = c(100,300)) +
        ggplot2::theme(axis.title = ggplot2::element_blank())})

    output$county_fatal_collisions_chart <- renderPlot({create_facet_bar_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography_type=="PSRC Region" & variable%in%c("Fatal Collisions") & data_year >= 2015), 
                                                                        w.x="data_year", w.y="estimate", 
                                                                        f="data_year", g="geography", 
                                                                        est.type = "number",
                                                                        w.title="Fatal Collisions by County: 2015 to 2020",
                                                                        w.facet=2, w.scales="fixed") +
        ggplot2::theme(axis.title = ggplot2::element_blank(), 
                       legend.position = "none")})
    
    
})    

