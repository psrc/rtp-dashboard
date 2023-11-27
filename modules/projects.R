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


