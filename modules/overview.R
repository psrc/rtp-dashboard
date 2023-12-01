# Climate Overview ----------------------------------------------------------------------------
dashboard_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("dashboardoverview"))
  )
}

dashboard_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$main_overview_text <- renderText({page_information(tbl=page_text, page_name="Overview", page_section = "Overview", page_info = "description")})
    
    # Tables
    output$summary_table <- DT::renderDataTable(create_summary_table(d=summary_info))
    
    # Overview UI
    output$dashboardoverview <- renderUI({
      tagList(
        textOutput(ns("main_overview_text")) |> withSpinner(color=load_clr),
        br(),
        strong(tags$div(class="chart_title","Summary of Data Trends")),
        br(),
        fluidRow(column(12, dataTableOutput(ns("summary_table")))),
        br()
      )
    })
  })  # end moduleServer
}
