# Transit Performance Overview ----------------------------------------------------------------
transit_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("transitoverview"))
  )
}

transit_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$transit_overview_text <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$transitoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Plan Input: 66% More Revenue-Hours by 2050"),
        tags$div(class="page_goals", "Plan Outcome: Triple Transit Boardings by 2050"),
        textOutput(ns("transit_overview_text")),
        br()
      )
    })
  })  # end moduleServer
}

# Transit Tabs --------------------------------------------------------------------------------
transit_metrics_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("metricstab"))
  )
}

transit_metrics_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$transit_metrics_region <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Metrics-Region", page_info = "description")})
    
    output$chart_transit_boardings <- renderEcharts4r({echart_line_chart(df=transit_data |> 
                                                                           filter(grouping %in% c("Annual", "Forecast") & year>=base_year & geography == "Region" & variable == "All Transit Modes" & metric != "Revenue-Miles"),
                                                                         x='year', y='estimate', fill='grouping', tog = 'metric',
                                                                         esttype="number", color = "jewel", dec = 0)})
    
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
    
    # Tab layout
    output$metricstab <- renderUI({
      tagList(
        
        h1("Regional Transit Performance"),
        textOutput(ns("transit_metrics_region")) |> withSpinner(color=load_clr),
        strong(tags$div(class="chart_title","Annual Regional Transit Boardings")),
        fluidRow(column(12,echarts4rOutput(ns("chart_transit_boardings")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        # Boardings by Mode
        h1("Transit Boardings by Mode"),
        br(),
        strong(tags$div(class="chart_title","YTD Regional Transit Boardings by Mode")),
        fluidRow(column(12,plotOutput(ns("chart_boardings_mode")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        # Boardings by Metro
        h1("Transit Boardings by Metropolitan Region"),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Boardings: ",pre_covid)))),
                 column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Boardings: ",current_population_year))))),
        fluidRow(column(6,plotlyOutput(ns("mpo_boardings_precovid_chart"))),
                 column(6,plotlyOutput(ns("mpo_boardings_today_chart")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: FTA National Transit Database")),
                 column(6,tags$div(class="chart_source","Source: FTA National Transit Database"))),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
    
  })  # end moduleServer
}

revhours_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("revhourstab"))
  )
}

revhours_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
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
    
    # Tab layout
    output$revhourstab <- renderUI({
      tagList(
        tags$div(class="page_goals","RTP Input: 66% More Revenue-Hours by 2050"),
        
        # Hours in Region
        h1("Annual Transit Revenue-Hours in the PSRC Region"),
        hr(),
        strong(tags$div(class="chart_title","Annual Regional Transit Revenue-Hours")),
        fluidRow(column(12,plotlyOutput(ns("chart_transit_hours")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        # Hours by Mode
        h1("Transit Revenue-Hours by Mode"),
        br(),
        strong(tags$div(class="chart_title","YTD Regional Transit Revenue-Hours by Mode")),
        fluidRow(column(12,plotOutput(ns("chart_hours_mode")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        # Hours by Metro
        h1("Transit Revenue-Hours by Metropolitan Region"),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Revenue-Hours: ",pre_covid)))),
                 column(6,strong(tags$div(class="chart_title",paste0("YTD Transit  Revenue-Hours: ",current_population_year))))),
        fluidRow(column(6,plotlyOutput(ns("mpo_hours_precovid_chart"))),
                 column(6,plotlyOutput(ns("mpo_hours_today_chart")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: FTA National Transit Database")),
                 column(6,tags$div(class="chart_source","Source: FTA National Transit Database"))),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

modeshare_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("modesharetab"))
  )
}

modeshare_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
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
    
    output$transit_ms_race_today_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(current_census_year)))})
    
    
    output$transit_ms_race_chart_today <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & variable=="Transit" & geography_type=="PSRC Region Race & Ethnicity" & data_year==current_census_year) %>% 
                                                                                   mutate(grouping = gsub(" alone","", grouping)) %>%
                                                                                   mutate(low_high=forcats::fct_reorder(grouping, -share)),
                                                                                 y='share', x='low_high', fill='variable', moe='share_moe',
                                                                                 est="percent", dec=0, color='blues_dec')})
    
    output$transit_ms_city_chart <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="City" & variable=="Public transportation" & data_year==current_census_year) %>% 
                                                                          mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                        x='share', y='low_high', fill='variable',
                                                                        est="percent", dec=0, color='pognbgy_5')})
    
    output$transit_ms_mpo_pre_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(current_census_year)-5))})
    
    output$transit_ms_mpo_today_text <- renderText({paste0("Transit to Work: ",as.character(as.integer(current_census_year)))})
    
    output$transit_ms_mpo_chart_today <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="Metro Regions" & variable=="Public transportation" & data_year==current_census_year) %>% 
                                                                               mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                             x='share', y='low_high', fill='variable',
                                                                             est="percent", dec=0, color='gnbopgy_5')})
    
    output$transit_ms_mpo_chart_pre <- renderPlotly({interactive_bar_chart(t=data %>% filter(metric=="Mode to Work" & geography_type=="Metro Regions" & variable=="Public transportation" & data_year==as.character(as.integer(current_census_year)-5)) %>% 
                                                                             mutate(low_high=forcats::fct_reorder(geography, -share)),
                                                                           x='share', y='low_high', fill='variable',
                                                                           est="percent", dec=0, color='obgnpgy_5')})
    
    # Tab layout
    output$modesharetab <- renderUI({
      tagList(
        tags$div(class="page_goals","Plan Outcome: 13% Transit Share by 2050"),
        br(),
        
        # Mode Share in Region
        h1("Transit Mode Share to Work in the PSRC Region"),
        hr(),
        strong(tags$div(class="chart_title","Transit Mode Share to Work")),
        fluidRow(column(12,plotlyOutput(ns("transit_ms_region_chart")))),
        tags$div(class="chart_source","Source: ACS 1yr Data Table B08006 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        # Mode Share by County
        h1("Transit Mode Share to Work by County"),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title","Transit to Work: King County"))),
                 column(6,strong(tags$div(class="chart_title","Transit to Work: Kitsap County")))),
        fluidRow(column(6,plotlyOutput(ns("transit_ms_king_chart"))),
                 column(6,plotlyOutput(ns("transit_ms_kitsap_chart")))),
        fluidRow(column(6,strong(tags$div(class="chart_title","Transit to Work: Pierce County"))),
                 column(6,strong(tags$div(class="chart_title","Transit to Work: Snohomish County")))),
        fluidRow(column(6,plotlyOutput(ns("transit_ms_pierce_chart"))),
                 column(6,plotlyOutput(ns("transit_ms_snohomish_chart")))),
        tags$div(class="chart_source","Source: ACS 1yr Data Table B08006 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        # Mode Share by Race
        h1("Transit Mode Share to Work by Race/Ethnicity"),
        br(),
        strong(tags$div(class="chart_title",textOutput(ns("transit_ms_race_today_text")))),
        fluidRow(column(12,plotlyOutput(ns("transit_ms_race_chart_today")))),
        tags$div(class="chart_source","Source: PUMS 5yr Data for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        # Mode Share by City
        h1("Transit Mode Share to Work by City"),
        br(),
        strong(tags$div(class="chart_title","Transit Mode Share to Work by City")),
        fluidRow(column(12,plotlyOutput(ns("transit_ms_city_chart"), height = "800px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08006 by Place in King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        # Mode Share by Metro
        h1("Transit Mode Share to Work by Metropolitan Region"),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title",textOutput(ns("transit_ms_mpo_pre_text"))))),
                 column(6,strong(tags$div(class="chart_title",textOutput(ns("transit_ms_mpo_today_text")))))),
        fluidRow(column(6,plotlyOutput(ns("transit_ms_mpo_chart_pre"))),
                 column(6,plotlyOutput(ns("transit_ms_mpo_chart_today")))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08006 by Counties in Metro Regions"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}
