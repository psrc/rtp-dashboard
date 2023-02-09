# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
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
                                                                   title="Fatal Collisions by Year in the PSRC Region: 2010 to 2020",
                                                                   lwidth = 2,
                                                                   breaks = c("2010","2015","2020"),
                                                                   color = "pgnobgy_5")})

    output$county_fatal_collisions_chart <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography_type=="PSRC Region" & variable%in%c("Fatal Collisions") & data_year >= 2015), 
                                                                        x="data_year", y="estimate", 
                                                                        fill="data_year", facet="geography", 
                                                                        est = "number",
                                                                        color = "pgnobgy_10",
                                                                        title="Fatal Collisions by County: 2015 to 2020",
                                                                        ncol=2, scales="fixed")})
    
    output$mpo_fatal_rate_min_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_min,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5',
                                                                       title=paste0('Annual Fatalities per 100,000 people: ',safety_min_year))})
    
    output$mpo_fatal_rate_max_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_max,
                                                                       y='geography', x='estimate', fill='plot_id',
                                                                       est="number", dec=1, color='pgnobgy_5',
                                                                       title=paste0('Annual Fatalities per 100,000 people: ',safety_max_year))})
    
    
    
   
    
    
    output$chart_transit_boardings <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Annual Transit Boardings" & geography=="Region" & variable =="All Transit Modes") %>% mutate(grouping=gsub("PSRC Region", "Observed",grouping)), 
                                                                                                    x='data_year', y='estimate', fill='grouping', est="number", 
                                                                                                    lwidth = 2,
                                                                                                    breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                                    color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,800000000), labels=scales::label_comma()), title="Annual Regional Transit Boardings: 2002 to 2050")})
    
    output$chart_boardings_mode <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="YTD Transit Boardings" & geography=="Region" & variable!="All Transit Modes" & data_year>=2015 & data_year<=current_population_year), 
                                                                        x="data_year", y="estimate", 
                                                                        fill="data_year", facet="variable", 
                                                                        est = "number",
                                                                        color = "pgnobgy_10",
                                                                        title=paste0("YTD Transit Boardings by Mode: 2015 to ",current_population_year),
                                                                        ncol=3, scales="free")})
    
    
    output$mpo_boardings_precovid_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_boardings_precovid,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=0, color='pgnobgy_5',
                                                                              title=paste0('Year to Date Transit Boardings: ',pre_covid))})
    
    output$mpo_boardings_today_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_boardings_today,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=0, color='pgnobgy_5',
                                                                              title=paste0('Year to Date Transit Boardings: ',current_population_year))})

    output$chart_transit_hours <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Annual Transit Revenue-Hours" & geography=="Region" & variable =="All Transit Modes") %>% mutate(grouping=gsub("PSRC Region", "Observed",grouping)), 
                                                                                                x='data_year', y='estimate', fill='grouping', est="number", 
                                                                                                lwidth = 2,
                                                                                                breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                                color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,14000000), labels=scales::label_comma()), title="Annual Regional Transit Revenue-Hours: 2002 to 2050")})
    
    output$chart_hours_mode <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="YTD Transit Revenue-Hours" & geography=="Region" & variable!="All Transit Modes" & data_year>=2015 & data_year<=current_population_year), 
                                                                      x="data_year", y="estimate", 
                                                                      fill="data_year", facet="variable", 
                                                                      est = "number",
                                                                      color = "pgnobgy_10",
                                                                      title=paste0("YTD Transit Revenue-Hours by Mode: 2015 to ",current_population_year),
                                                                      ncol=3, scales="free")})
    
    
    output$mpo_hours_precovid_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_hours_precovid,
                                                                               y='geography', x='estimate', fill='plot_id',
                                                                               est="number", dec=0, color='pgnobgy_5',
                                                                               title=paste0('Year to Date Transit Revenue-Hours: ',pre_covid))})
    
    output$mpo_hours_today_chart <- renderPlotly({interactive_bar_chart(t=mpo_transit_hours_today,
                                                                            y='geography', x='estimate', fill='plot_id',
                                                                            est="number", dec=0, color='pgnobgy_5',
                                                                            title=paste0('Year to Date Transit Revenue-Hours: ',current_population_year))})
    
    
})    

