# Walk, Bike, & Roll Overview -----------------------------------------------------------------
mode_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("modeoverview"))
  )
}

mode_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$modes_overview_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$modeoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Plan Output: 21% More Walking & Biking by 2050"),
        textOutput(ns("modes_overview_text")),
        br()
      )
    })
  }) # end moduleServer
}

# Mode Tabs -----------------------------------------------------------------------------------
walk_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("walktab"))
  )
}

walk_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$walk_share_county_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Walk-County", page_info = "description")})
    output$walk_share_race_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Walk-Race", page_info = "description")})
    output$walk_share_metro_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Walk-Metro", page_info = "description")})
    output$walk_share_city_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Walk-City", page_info = "description")})
    
    # Charts
    output$walk_ms_county_chart <- renderEcharts4r({echart_column_chart_timeline(df = commute_data |> 
                                                                                   filter(variable == "Walk" & geography_type == "County" & metric == "commute-modes") |>
                                                                                   mutate(geography = str_wrap(geography, 10)) |>
                                                                                   mutate(year = factor(x=year, levels = yr_ord)) |>
                                                                                   mutate(geography = factor(x=geography, levels = county_ord)) |>
                                                                                   arrange(year, geography),
                                                                                 x = "geography", y = "share", fill = "geography", tog = "year", 
                                                                                 dec = 1, title = "Walk to Work", esttype = "percent", color = "jewel")})
    
    output$walk_ms_race_chart <- renderEcharts4r({echart_pictorial(df= commute_data |> 
                                                                     filter(geography_type=="Race" & year == current_census_year & variable == "Walked") |>
                                                                     mutate(grouping = str_wrap(grouping, 15)),
                                                                   x="grouping", y="share", tog="variable", 
                                                                   icon=fa_walking, 
                                                                   color=psrc_colors$gnbopgy_5[[3]],
                                                                   title="Race & Hispanic Origin", dec = 2, esttype = "percent")})
    
    output$walk_ms_metro_chart <- renderEcharts4r({echart_bar_chart(df=commute_data |>
                                                                      filter(geography_type == "Metro Areas" & variable == "Walk") |>
                                                                      mutate(year = factor(x=year, levels=yr_ord)) |>
                                                                      arrange(year, share), 
                                                                    title = "Walk to Work", tog = 'year',
                                                                    y='share', x='geography', esttype="percent", dec=1, color = 'jewel')})
    
    output$walk_ms_city_chart <- renderEcharts4r({echart_multi_series_bar_chart(df=commute_data |>
                                                                                  filter(geography_type == "City" & variable == "Walk" & year == current_census_year) |>
                                                                                  arrange(share) |>
                                                                                  mutate(estimate = share) |>
                                                                                  mutate(metric = "Walk Share to Work"), 
                                                                                x = "geography", y='estimate', fill='metric', 
                                                                                esttype="percent", title="Walk to Work", dec=1, color = psrc_colors$pognbgy_5[[3]])})
    
    # Tab layout
    output$walktab <- renderUI({
      tagList(
        
        h1("Walk to Work: County"),
        textOutput(ns("walk_share_county_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("walk_ms_county_chart")))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Walk to Work: Race & Ethnicity"),
        textOutput(ns("walk_share_race_text")),
        fluidRow(column(12,echarts4rOutput(ns("walk_ms_race_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Walk to Work: Metropolitan Region"),
        textOutput(ns("walk_share_metro_text")),
        fluidRow(column(12,echarts4rOutput(ns("walk_ms_metro_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr(),
        
        h1("Walk to Work: City"),
        textOutput(ns("walk_share_city_text")),
        fluidRow(column(12,echarts4rOutput(ns("walk_ms_city_chart"), height = "1000px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr()
        
      )
    })
  }) # end moduleServer
}

bike_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("biketab"))
  )
}

bike_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$bike_share_county_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Bike-County", page_info = "description")})
    output$bike_share_race_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Bike-Race", page_info = "description")})
    output$bike_share_metro_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Bike-Metro", page_info = "description")})
    output$bike_share_city_text <- renderText({page_information(tbl=page_text, page_name="Modes", page_section = "Bike-City", page_info = "description")})
    
    # Charts
    output$bike_ms_county_chart <- renderEcharts4r({echart_column_chart_timeline(df = commute_data |> 
                                                                                   filter(variable == "Bike" & geography_type == "County" & metric == "commute-modes") |>
                                                                                   mutate(geography = str_wrap(geography, 10)) |>
                                                                                   mutate(year = factor(x=year, levels = yr_ord)) |>
                                                                                   mutate(geography = factor(x=geography, levels = county_ord)) |>
                                                                                   arrange(year, geography),
                                                                                 x = "geography", y = "share", fill = "geography", tog = "year", 
                                                                                 dec = 1, title = "Bike to Work", esttype = "percent", color = "jewel")})
    
    output$bike_ms_race_chart <- renderEcharts4r({echart_pictorial(df= commute_data |> 
                                                                     filter(geography_type=="Race" & year == current_census_year & variable == "Bicycle") |>
                                                                     mutate(grouping = str_wrap(grouping, 15)),
                                                                   x="grouping", y="share", tog="variable", 
                                                                   icon=fa_biking, 
                                                                   color=psrc_colors$gnbopgy_5[[4]],
                                                                   title="Race & Hispanic Origin", dec = 2, esttype = "percent")})
    
    output$bike_ms_metro_chart <- renderEcharts4r({echart_bar_chart(df=commute_data |>
                                                                      filter(geography_type == "Metro Areas" & variable == "Bike") |>
                                                                      mutate(year = factor(x=year, levels=yr_ord)) |>
                                                                      arrange(year, share), 
                                                                    title = "Bike to Work", tog = 'year',
                                                                    y='share', x='geography', esttype="percent", dec=1, color = 'jewel')})
    
    output$bike_ms_city_chart <- renderEcharts4r({echart_multi_series_bar_chart(df=commute_data |>
                                                                                  filter(geography_type == "City" & variable == "Bike" & year == current_census_year) |>
                                                                                  arrange(share) |>
                                                                                  mutate(estimate = share) |>
                                                                                  mutate(metric = "Bike Share to Work"), 
                                                                                x = "geography", y='estimate', fill='metric', 
                                                                                esttype="percent", title="Bike to Work", dec=1, color = psrc_colors$pognbgy_5[[4]])})
    
    # Tab layout
    output$biketab <- renderUI({
      tagList(
        h1("Bike to Work: County"),
        textOutput(ns("bike_share_county_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("bike_ms_county_chart")))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Bike to Work: Race & Ethnicity"),
        textOutput(ns("bike_share_race_text")),
        fluidRow(column(12,echarts4rOutput(ns("bike_ms_race_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Bike to Work: Metropolitan Region"),
        textOutput(ns("bike_share_metro_text")),
        fluidRow(column(12,echarts4rOutput(ns("bike_ms_metro_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr(),
        
        h1("Bike to Work: City"),
        textOutput(ns("bike_share_city_text")),
        fluidRow(column(12,echarts4rOutput(ns("bike_ms_city_chart"), height = "1000px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr()
      )
    })
  }) # end moduleServer
}
