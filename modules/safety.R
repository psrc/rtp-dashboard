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
        br(),
        textOutput(ns("safety_overview_text")),
        br()
      )
    })
  })  # end moduleServer
}

# Safety Tabs ---------------------------------------------------------------------------------
fatal_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("fataltab"))
  )
}

fatal_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$safety_text <- renderText({safety_caption})
    
    output$region_fatal_text <- renderText({fatal_trends_caption})
    
    output$fatal_county_text <- renderText({fatal_county_caption})
    
    output$fatal_mpo_text <- renderText({fatal_mpo_caption})
    
    output$fatal_collisions_chart <- renderPlotly({interactive_line_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography=="Seattle" & variable%in%c("Fatal Collisions","Fatalities")),
                                                                          x='data_year', y='estimate', fill='variable', est="number",
                                                                          lwidth = 2,
                                                                          breaks = c("2010","2015","2020"),
                                                                          color = "pgnobgy_5")})
    
    output$county_fatal_collisions_chart <- renderPlot({static_facet_column_chart(t=data %>% filter(metric=="1yr Fatality Rate" & geography_type=="PSRC Region" & variable%in%c("Fatal Collisions") & data_year>as.character(safety_max_year-5)), 
                                                                                  x="data_year", y="estimate", 
                                                                                  fill="data_year", facet="geography", 
                                                                                  est = "number",
                                                                                  color = "pgnobgy_10",
                                                                                  ncol=2, scales="fixed")})
    
    output$mpo_fatal_rate_min_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_min,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=1, color='pgnobgy_5')})
    
    output$mpo_fatal_rate_max_yr_chart <- renderPlotly({interactive_bar_chart(t=mpo_safety_tbl_max,
                                                                              y='geography', x='estimate', fill='plot_id',
                                                                              est="number", dec=1, color='pgnobgy_5')})
    
    # Tab layout
    output$fataltab <- renderUI({
      tagList(
        tags$div(class="page_goals","Goal: Zero Fatal Injuries by 2030"),
        br(),
        
        # Fatal - Region
        h1("Fatal Collisions in the PSRC Region"),
        textOutput(ns("safety_text")),
        br(),
        textOutput(ns("region_fatal_text")),
        hr(),
        strong(tags$div(class="chart_title","Fatal Collisions in the PSRC Region")),
        fluidRow(column(12,plotlyOutput(ns("fatal_collisions_chart")))),
        tags$div(class="chart_source","Source: USDOT FARS Data"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # Fatal - County
        h1("Fatal Collisions by County in the PSRC Region"),
        textOutput(ns("fatal_county_text")),
        br(),
        strong(tags$div(class="chart_title","Fatal Collisions by County")),
        fluidRow(column(12,plotOutput(ns("county_fatal_collisions_chart")))),
        tags$div(class="chart_source","Source: USDOT FARS Data"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # Fatal - MPO
        h1("Fatal Collisions by Metropolitan Region"),
        textOutput(ns("fatal_mpo_text")),
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
