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
    output$project_selection_stp_chart <- renderEcharts4r({echart_bar_chart_simple(df=stp, fill=stp_plot_buckets, x="project_id", color=stp_colors)})
    
    output$project_selection_cmaq_chart <- renderEcharts4r({echart_bar_chart_simple(df=cmaq, fill=cmaq_plot_buckets, x="project_id", color=cmaq_colors)})
    
    # Tables
    output$project_selection_cmaq_table <- renderDataTable({create_project_table(df=cmaq, data_cols = fhwa_cols, currency_cols = "funding_request")})
    output$project_selection_stp_table <- renderDataTable({create_project_table(df=stp, data_cols = fhwa_cols, currency_cols = "funding_request")}) 
    
    # Maps
    output$project_selection_cmaq_map <- renderLeaflet({create_project_selection_map(project_lyr=cmaq_lyr)})
    output$project_selection_stp_map <- renderLeaflet({create_project_selection_map(project_lyr=stp_lyr)})
    
    # Tab layout
    output$project_selectiontab <- renderUI({
      tagList(
        
        h1("Congestion Mitigation and Air Quality (CMAQ)"),
        textOutput(ns("project_selection_cmaq_text")) |> withSpinner(color=load_clr),
        fluidRow(column(6,echarts4rOutput(ns("project_selection_cmaq_chart"), height = "600px")),
                 column(6,leafletOutput(ns("project_selection_cmaq_map"), height = "600px"))),
        br(),
        fluidRow(column(12,dataTableOutput(ns("project_selection_cmaq_table")))),
        tags$div(class="chart_source","Source: 2022 PSRC Project Selection Process"),
        hr(style = "border-top: 1px solid #000000;"),
        
        h1("Surface Transportation Program (STP)"),
        textOutput(ns("project_selection_stp_text")),
        fluidRow(column(6,echarts4rOutput(ns("project_selection_stp_chart"), height = "600px")),
                 column(6,leafletOutput(ns("project_selection_stp_map"), height = "600px"))),
        br(),
        fluidRow(column(12,dataTableOutput(ns("project_selection_stp_table")))),
        tags$div(class="chart_source","Source: 2022 PSRC Project Selection Process"),
        hr(style = "border-top: 1px solid #000000;")
        
      )
    })
  }) # end moduleServer
}

tip_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("tiptab"))
  )
}

tip_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$tip_text <- renderText({page_information(tbl=page_text, page_name="Projects", page_section = "TIP-Region", page_info = "description")})
    
    # Charts
    output$tip_chart <- renderEcharts4r({echart_column_chart_timeline(df = tip_projects |>
                                                                        select("Projects", Cost="Total Cost", `# of Projects`="Total Projects") |>
                                                                        pivot_longer(cols = !Projects),
                                                                      x = "Projects", y = "value", fill = "Projects", tog = "name", 
                                                                      dec = 0, title = "TIP Projects", esttype = "number", color = "jewel")})
    
    # Tables
    output$tip_table <- renderDataTable({create_tip_table(df=tip_lyr |> st_drop_geometry())})
    
    # Maps
    output$tip_map <- renderLeaflet({create_tip_map(project_lyr = tip_lyr)})
    
    # Tab layout
    output$tiptab <- renderUI({
      tagList(
        
        h1("Transportation Improvement Program (TIP)"),
        textOutput(ns("tip_text")) |> withSpinner(color=load_clr),
        br(),
        fluidRow(column(12,echarts4rOutput(ns("tip_chart")))),
        br(),
        fluidRow(column(12,leafletOutput(ns("tip_map"), height = "600px"))),
        br(),
        fluidRow(column(12,dataTableOutput(ns("tip_table")))),
        br(),
        tags$div(class="chart_source","Source: 2023-2026 Regional TIP"),
        hr(style = "border-top: 1px solid #000000;")
        
      )
    })
  }) # end moduleServer
}
