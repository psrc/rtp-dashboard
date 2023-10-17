# Safety Overview -----------------------------------------------------------------------------
safety_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("safetyoverview"))
  )
}

safety_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$safety_overview_text <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$safetyoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Goal: Zero Fatal and Serious Injuries by 2030"),
        textOutput(ns("safety_overview_text")),
        br()
      )
    })
  })  # end moduleServer
}

# Safety Tabs ---------------------------------------------------------------------------------
safety_geography_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("geographytab"))
  )
}

safety_geography_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$fatal_region <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Fatal-Regional", page_info = "description")})
    output$fatal_county <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Fatal-County", page_info = "description")})
    output$fatal_mpo <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Fatal-MPO", page_info = "description")})

    output$region_collisions_chart <- renderEcharts4r({echart_line_chart(df=safety_data |> filter(geography == "Region" & geography_type == "Region"),
                                                                        x='data_year', y='estimate', fill='metric', tog = 'variable',
                                                                        esttype="number", color = "jewel", dec = 1)})
    
    output$king_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "King" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                         x='data_year', y='estimate', fill='metric', title='King County',
                                                                         dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$kitsap_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Kitsap" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                           x='data_year', y='estimate', fill='metric', title='Kitsap County',
                                                                           dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$pierce_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Pierce" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                           x='data_year', y='estimate', fill='metric', title='Pierce County',
                                                                           dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$snohomish_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Snohomish" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                              x='data_year', y='estimate', fill='metric', title='Snohomish County',
                                                                              dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$mpo_fatal_rate_min_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_min,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=1, color='pgnobgy_5')})
    
    output$mpo_fatal_rate_max_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_max,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=1, color='pgnobgy_5')})
    
    # Tab layout
    output$geographytab <- renderUI({
      tagList(
        # Region
        h1("Region"),
        textOutput(ns("fatal_region")),
        hr(),
        #strong(tags$div(class="chart_title","Serious Injury and Traffic Related Deaths in the PSRC Region")),
        fluidRow(column(12,echarts4rOutput(ns("region_collisions_chart")))),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # FaCounty
        h1("County"),
        textOutput(ns("fatal_county")),
        br(),
        #strong(tags$div(class="chart_title","Fatal Collisions by County")),
        fluidRow(column(6,echarts4rOutput(ns("king_collisions_chart"))),
                 column(6,echarts4rOutput(ns("kitsap_collisions_chart")))),
        fluidRow(column(6,echarts4rOutput(ns("pierce_collisions_chart"))),
                 column(6,echarts4rOutput(ns("snohomish_collisions_chart")))),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # Fatal - MPO
        h1("Metropolitan Region"),
        textOutput(ns("fatal_mpo")),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title",paste0("Annual Fatalities per 100,000 people: ",safety_min_year)))),
                 column(6,strong(tags$div(class="chart_title",paste0("Annual Fatalities per 100,000 people: ",safety_max_year))))),
        fluidRow(column(6,plotlyOutput(ns("mpo_fatal_rate_min_yr_chart"))),
                 column(6,plotlyOutput(ns("mpo_fatal_rate_max_yr_chart")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: USDOT FARS Data")),
                 column(6,tags$div(class="chart_source","Source: USDOT FARS Data"))),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

serious_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("serioustab"))
  )
}

serious_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    
    # Tab layout
    output$serioustab <- renderUI({
      tagList(
        
      )
    })
  })  # end moduleServer
}
