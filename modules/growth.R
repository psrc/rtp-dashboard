# People, Housing, & Jobs Overview ------------------------------------------------------------
growth_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("growthoverview"))
  )
}

growth_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$growth_overview_text <- renderText({page_information(tbl=page_text, page_name="Growth", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$growthoverview <- renderUI({
      tagList(
        # Growth Overview
        tags$div(class="page_goals", "Goal: 65% Population / 75% Job Growth near HCT"),
        textOutput(ns("growth_overview_text")) |> withSpinner(color=load_clr),
        br()
      )
    })
  })  # end moduleServer
}


# People, Housing, & Jobs Tabs ----------------------------------------------------------------------------------
growth_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("growthtab"))
  )
}

growth_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$growth_region_text <- renderText({page_information(tbl=page_text, page_name="Growth", page_section = "Population-Regional", page_info = "description")})
    output$growth_hct_text <- renderText({page_information(tbl=page_text, page_name="Growth", page_section = "Population-HCT", page_info = "description")})

    # Charts
    output$chart_region_growth <- renderEcharts4r({echart_line_chart(df=pop_hsg_jobs |> filter(grouping=="Total" & data_year>=base_year),
                                                                     x='data_year', y='estimate', fill='variable', tog = 'metric',
                                                                     esttype="number", color = "jewel", dec = 0)})
    
    
    output$chart_hct_growth <- renderEcharts4r({echart_line_chart(df=hct_growth |> filter(grouping=="Change" & data_year>=base_year),
                                                                  x='data_year', y='share', fill='geography', tog = 'metric',
                                                                  esttype="percent", color = "jewel", dec = 0)})
    
    # Tab layout
    output$growthtab <- renderUI({
      tagList(
        # Region
        h1("Region"),
        textOutput(ns("growth_region_text")) |> withSpinner(color=load_clr),
        br(),
        strong(tags$div(class="chart_title","Regional Population, Housing and Job Growth")),
        fluidRow(column(12,echarts4rOutput(ns("chart_region_growth")))),
        tags$div(class="chart_source","Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # HCT
        h1("Near High Capacity Transit"),
        textOutput(ns("growth_hct_text")),
        hr(),
        strong(tags$div(class="chart_title","Growth Near High Capacity Transit")),
        fluidRow(column(12,echarts4rOutput(ns("chart_hct_growth")))),
        tags$div(class="chart_source","Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

