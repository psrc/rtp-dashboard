# Travel Time Overview -----------------------------------------------------------------
time_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("timeoverview"))
  )
}

time_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$time_overview_text <- renderText({page_information(tbl=page_text, page_name="Travel-Times", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$timeoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Plan Output: 7% reduction in Annual Delay per Household"),
        textOutput(ns("time_overview_text")),
        br()
      )
    })
  }) # end moduleServer
}

# Mode Tabs -----------------------------------------------------------------------------------
tt_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("tttab"))
  )
}

tt_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$tt_county_text <- renderText({page_information(tbl=page_text, page_name="Travel-Times", page_section = "TT-County", page_info = "description")})
    output$tt_race_text <- renderText({page_information(tbl=page_text, page_name="Travel-Times", page_section = "TT-Race", page_info = "description")})
    output$tt_metro_text <- renderText({page_information(tbl=page_text, page_name="Travel-Times", page_section = "TT-Metro", page_info = "description")})

    # Charts
    output$tt_county_chart <- renderEcharts4r({echart_column_chart_timeline(df = commute_data |> 
                                                                              filter(grouping == "Workers over 16yrs of age" & metric == "Mean Commute Time") |>
                                                                              mutate(year = factor(x=year, levels = yr_ord)) |>
                                                                              mutate(geography = factor(x=geography, levels = county_short_ord)) |>
                                                                              arrange(year, geography),
                                                                            x = "geography", y = "estimate", fill = "geography", tog = "year", 
                                                                            dec = 1, title = "Travel Time to Work", esttype = "number", color = "jewel")})
    
    output$tt_race_chart <- renderEcharts4r({echart_pictorial(df= commute_data |> 
                                                                filter(metric == "Mean Commute Time" & geography_type == "Race" & year == current_census_year) |>
                                                                mutate(grouping = str_wrap(grouping, 15)),
                                                              x="grouping", y="estimate", tog="variable", 
                                                              icon=fa_car, 
                                                              color=psrc_colors$gnbopgy_5[[3]],
                                                              title="Race & Hispanic Origin", dec = 1, esttype = "decimal")})
    
    output$tt_metro_chart <- renderEcharts4r({echart_bar_chart(df=commute_data |>
                                                                 filter(geography_type == "Metro Areas" & metric == "commute-times" & variable == "more than 60 minutes") |>
                                                                 mutate(year = factor(x=year, levels=yr_ord)) |>
                                                                 arrange(year, share), 
                                                               title = "Workers with hour or more commute", tog = 'year',
                                                               y='share', x='geography', esttype="percent", dec=1, color = 'jewel')})
    
    # Tab layout
    output$tttab <- renderUI({
      tagList(
        
        h1("Mean Travel Time to Work: County"),
        textOutput(ns("tt_county_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("tt_county_chart")))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWMNP for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Mean Travel Time to Work: Race & Ethnicity"),
        textOutput(ns("tt_race_text")),
        fluidRow(column(12,echarts4rOutput(ns("tt_race_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWMNP for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Hour or more Commute: Metropolitan Region"),
        textOutput(ns("tt_metro_text")),
        fluidRow(column(12,echarts4rOutput(ns("tt_metro_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08303"),
        hr()
        
      )
    })
  }) # end moduleServer
}
