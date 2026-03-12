
overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("overview"))
  )
}

overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$overview_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview", page_info = "description"))})
    output$overview_cmp <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "OverviewCMP", page_info = "description"))})
    output$foundations_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview-Foundations", page_info = "description"))})
    output$agency_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview-Agency", page_info = "description"))})
    
    output$summary_table <- renderDataTable(create_summary_table(d=summary_info))

    # Overview UI
    output$overview <- renderUI({
      tagList(
        
        div(
          class = "d-flex flex-column flex-lg-row align-items-start gap-4",
          
          tags$img(
            src = "RTP-2026-System-Logo.jpg",
            style = "width:260px; height:auto; flex-shrink:0;",
            alt = "RTP Logo"
          ),
          
          div(
            style = "flex:1;",
            
            htmlOutput(ns("overview_text")),
            div(class = "mt-3", htmlOutput(ns("overview_cmp")))
          )
        ),
        
        br(),
        h2("Draft 2026-2050 RTP Performance Summary Results"),
        dataTableOutput(ns("summary_table")),
        br()

      )
    })
  })  # end moduleServer
}
