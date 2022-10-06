# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$population_vision_text <- renderText({pop_vision_caption})

    # Charts
    output$chart_population_growth <- renderPlot({create.line.chart(t=data %>% filter(concept=="Population" & year>=2000), 
                                                                      w.x='year', w.y='estimate', w.g='label', est.type="number", 
                                                                      w.title="Regional Population: 2000 to 2050",
                                                                      x.type= "Continuous",
                                                                      w.lwidth = 3,
                                                                      w.breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      w.color = "DkPrLtPr",
                                                                      w.interactive = 'no') +
        scale_y_continuous(labels = scales::comma, limits = c(2000000,6000000))})
    
    output$chart_employment_growth <- renderPlot({create.line.chart(t=data %>% filter(concept=="Employment" & year>=2000), 
                                                                      w.x='year', w.y='estimate', w.g='label', est.type="number", 
                                                                      w.title="Regional Employment: 2000 to 2050",
                                                                      x.type= "Continuous",
                                                                      w.lwidth = 3,
                                                                      w.breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                      w.color = "DkOrLtOr",
                                                                      w.interactive = 'no') +
        scale_y_continuous(labels = scales::comma, limits = c(1000000,3500000))})
    
    output$chart_housing_growth <- renderPlot({create.line.chart(t=data %>% filter(concept=="Housing" & year>=2000), 
                                                                   w.x='year', w.y='estimate', w.g='label', est.type="number", 
                                                                   w.title="Annual Housing Forecast: 2010 to 2050",
                                                                   x.type= "Continuous",
                                                                   w.lwidth = 3,
                                                                   w.breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                   w.color = "psrc_light",
                                                                   w.interactive = 'no') +
        scale_y_continuous(labels = scales::comma, limits = c(1000000,3000000))})
    
    #output$table_region_homeownership <- renderDataTable({create.clean.tbl(yr=latest.yr, g.type=c("Region"), c.name="Owner-occupied housing units", t.container=create.custom.container("Region","Home Ownership"), t.cols=region.tot.cols, s.cols=region.shr.cols, e.type=input$OwnershipType)})
    


})    

