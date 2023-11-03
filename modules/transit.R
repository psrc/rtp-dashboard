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
    
    # Text
    output$transit_metrics_region <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Metrics-Region", page_info = "description")})
    output$transit_metrics_mode <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Metrics-Mode", page_info = "description")})
    output$transit_metrics_mpo <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Metrics-MPO", page_info = "description")})
    
    # Charts
    output$chart_transit_boardings <- renderEcharts4r({echart_line_chart(df=transit_data |> 
                                                                           filter(grouping %in% c("Annual", "Forecast") & year>=base_year & geography == "Region" & variable == "All Transit Modes" & metric != "Revenue-Miles"),
                                                                         x='year', y='estimate', fill='grouping', tog = 'metric',
                                                                         esttype="number", color = "jewel", dec = 0)})
    
    output$chart_bus_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings" & variable =="Bus") |>
                                                                   mutate(metric = paste(grouping, variable, metric)),
                                                                 x='year', y='estimate', fill='metric', title='Bus', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[1])})
    
    output$chart_crt_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings"  & variable =="Commuter Rail") |>
                                                                   mutate(metric = paste(grouping, variable, metric)),
                                                                 x='year', y='estimate', fill='metric', title='Commuter Rail', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[2])})
    
    output$chart_drt_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings"  & variable =="Demand Response") |>
                                                                   mutate(metric = paste(grouping, variable, metric)), 
                                                                 x='year', y='estimate', fill='metric', title='Demand Response', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[3])})
    
    output$chart_fry_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings"  & variable =="Ferry") |>
                                                                   mutate(metric = paste(grouping, variable, metric)),
                                                                 x='year', y='estimate', fill='metric', title='Ferry', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[4])})
    
    output$chart_lrt_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings"  & variable =="Rail") |>
                                                                   mutate(metric = paste(grouping, variable, metric)),
                                                                 x='year', y='estimate', fill='metric', title='Rail', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[5])})
    
    output$chart_van_ytd <- renderEcharts4r({echart_column_chart(df = transit_data |> 
                                                                   filter(year >= pre_covid & geography == "Region" & grouping == "YTD" & metric == "Boardings"  & variable =="Vanpool") |>
                                                                   mutate(metric = paste(grouping, variable, metric)),
                                                                 x='year', y='estimate', fill='metric', title='Vanpool', dec = 0, esttype = 'number', color = psrc_colors$obgnpgy_10[6])})
    
    output$mpo_covid_chart <- renderEcharts4r({echart_bar_chart(df=transit_data |> filter(grouping == "COVID Recovery"), 
                                                                title = "% Pre-COVID", tog = 'metric',
                                                                y='estimate', x='geography', esttype="percent", dec=0, color = 'jewel')})
    
    # Tab layout
    output$metricstab <- renderUI({
      tagList(
        
        h1("Annual Regional Transit Performance"),
        textOutput(ns("transit_metrics_region")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("chart_transit_boardings")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        h1("Year to Date Transit Boardings by Mode"),
        textOutput(ns("transit_metrics_mode")),
        fluidRow(column(6,echarts4rOutput(ns("chart_bus_ytd"))),
                 column(6,echarts4rOutput(ns("chart_crt_ytd")))),
        fluidRow(column(6,echarts4rOutput(ns("chart_drt_ytd"))),
                 column(6,echarts4rOutput(ns("chart_fry_ytd")))),
        fluidRow(column(6,echarts4rOutput(ns("chart_lrt_ytd"))),
                 column(6,echarts4rOutput(ns("chart_van_ytd")))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        hr(),
        
        h1("Transit Boardings by Metropolitan Region"),
        textOutput(ns("transit_metrics_mpo")),
        br(),
        fluidRow(column(12,echarts4rOutput(ns("mpo_covid_chart"), height = "800px"))),
        tags$div(class="chart_source","Source: FTA National Transit Database"),
        br(),
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
