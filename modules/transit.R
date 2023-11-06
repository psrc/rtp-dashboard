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
    
    # Text 
    output$transit_share_county_text <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Mode-County", page_info = "description")})
    output$transit_share_race_text <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Mode-Race", page_info = "description")})
    output$transit_share_metro_text <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Mode-Metro", page_info = "description")})
    output$transit_share_city_text <- renderText({page_information(tbl=page_text, page_name="Transit", page_section = "Mode-City", page_info = "description")})
    
    # charts
    output$transit_ms_county_chart <- renderEcharts4r({echart_column_chart_timeline(df = commute_data |> 
                                                                                      filter(variable == "Transit" & geography_type == "County" & metric == "commute-modes") |>
                                                                                      mutate(year = factor(x=year, levels = yr_ord)) |>
                                                                                      mutate(geography = factor(x=geography, levels = county_ord)) |>
                                                                                      arrange(year, geography),
                                                                                    x = "geography", y = "share", fill = "geography", tog = "year", 
                                                                                    dec = 1, title = "", esttype = "percent", color = "jewel")})
  
    output$transit_ms_race_chart <- renderEcharts4r({echart_pictorial(df= commute_data |> 
                                                                        filter(geography_type=="Race" & year == current_census_year & variable == "Transit") |>
                                                                        mutate(grouping = str_wrap(grouping, 15)),
                                                                      x="grouping", y="share", tog="variable", 
                                                                      icon=fa_bus, 
                                                                      color=psrc_colors$gnbopgy_5[[2]],
                                                                      title="Race & Hispanic Origin", dec = 2, esttype = "percent")})
    
    output$transit_ms_metro_chart <- renderEcharts4r({echart_bar_chart(df=commute_data |>
                                                                         filter(geography_type == "Metro Areas" & variable == "Transit") |>
                                                                         mutate(year = factor(x=year, levels=yr_ord)) |>
                                                                         arrange(year, share), 
                                                                       title = "Mode Share", tog = 'year',
                                                                       y='share', x='geography', esttype="percent", dec=1, color = 'jewel')})
    
    output$transit_ms_city_chart <- renderEcharts4r({echart_multi_series_bar_chart(df=commute_data |>
                                                                                     filter(geography_type == "City" & variable == "Transit" & year == current_census_year) |>
                                                                                     arrange(share) |>
                                                                                     mutate(estimate = share) |>
                                                                                     mutate(metric = "Transit Share to Work"), 
                                                                                   x = "geography", y='estimate', fill='metric', 
                                                                                   esttype="percent", title="", dec=1, color = psrc_colors$pognbgy_5[[1]])})
    # Tab layout
    output$modesharetab <- renderUI({
      tagList(
        
        h1("Transit to Work: County"),
        textOutput(ns("transit_share_county_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("transit_ms_county_chart")))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Transit to Work: Race & Ethnicity"),
        textOutput(ns("transit_share_race_text")),
        fluidRow(column(12,echarts4rOutput(ns("transit_ms_race_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties"),
        hr(),

        h1("Transit to Work: Metropolitan Region"),
        textOutput(ns("transit_share_metro_text")),
        fluidRow(column(12,echarts4rOutput(ns("transit_ms_metro_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr(),
        
        h1("Transit to Work: City"),
        textOutput(ns("transit_share_city_text")),
        fluidRow(column(12,echarts4rOutput(ns("transit_ms_city_chart"), height = "1000px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr()
      
      )
    })
  })  # end moduleServer
}
