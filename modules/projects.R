# Proejcts Overview ------------------------------------------------------------
projects_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("projectsoverview"))
  )
}

projects_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$projects_overview_text <- renderText({page_information(tbl=page_text, page_name="Projects", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$projectsoverview <- renderUI({
      tagList(
        # Growth Overview
        #tags$div(class="page_goals", "Goal: 65% Population / 75% Job Growth near HCT"),
        textOutput(ns("projects_overview_text")) |> withSpinner(color=load_clr),
        br()
      )
    })
  })  # end moduleServer
}

project_selection_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("project_selectiontab"))
  )
}

project_selection_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$project_selection_stp_text <- renderText({page_information(tbl=page_text, page_name="Projects", page_section = "Project-Selection-STP", page_info = "description")})
    output$project_selection_cmaq_text <- renderText({page_information(tbl=page_text, page_name="Projects", page_section = "Project-Selection-CMAQ", page_info = "description")})
    
    # Charts
    output$project_selection_stp_chart <- renderEcharts4r({echart_bar_chart_simple(df=stp |> mutate(project_id = paste("Project #",project_id)), 
                                                                                   fill=stp_plot_buckets, x="project_id", color=stp_colors)})
    
    output$project_selection_cmaq_chart <- renderEcharts4r({echart_bar_chart_simple(df=cmaq |> mutate(project_id = paste("Project #",project_id)), 
                                                                                    fill=cmaq_plot_buckets, x="project_id", color=cmaq_colors)})
    
    # Tables
    output$project_selection_cmaq_table <- renderDataTable({create_project_table(df=cmaq, data_cols = fhwa_cols, currency_cols = "funding_request")})
    output$project_selection_stp_table <- renderDataTable({create_project_table(df=stp, data_cols = fhwa_cols, currency_cols = "funding_request")}) 
    
    # Maps
    #output$am_peak_map <- renderLeaflet({create_roadway_map(congestion_lyr = congestion_map_data, tod = "am_peak")})
    #output$pm_peak_map <- renderLeaflet({create_roadway_map(congestion_lyr = congestion_map_data, tod = "pm_peak")})
    
    # Tab layout
    output$project_selectiontab <- renderUI({
      tagList(
        
        h1("Congestion Mitigation and Air Quality (CMAQ)"),
        textOutput(ns("project_selection_cmaq_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("project_selection_cmaq_chart")))),
        fluidRow(column(12,dataTableOutput(ns("project_selection_cmaq_table")))),
        tags$div(class="chart_source","Source: 2022 PSRC Project Selection Process"),
        hr(style = "border-top: 1px solid #000000;"),
        
        h1("Surface Transportation Program (STP)"),
        textOutput(ns("project_selection_stp_text")),
        fluidRow(column(12,echarts4rOutput(ns("project_selection_stp_chart"), height = "600px"))),
        fluidRow(column(12,dataTableOutput(ns("project_selection_stp_table")))),
        tags$div(class="chart_source","Source: 2022 PSRC Project Selection Process"),
        hr(style = "border-top: 1px solid #000000;")
        
      )
    })
  }) # end moduleServer
}
