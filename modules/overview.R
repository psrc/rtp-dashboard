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
    
    # Overview UI
    output$dashboardoverview <- renderUI({
      tagList(
        textOutput(ns("main_overview_text")) |> withSpinner(color=load_clr),
        br()
      )
    })
  })  # end moduleServer
}
