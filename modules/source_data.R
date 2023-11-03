# Display Source Data

source_ui <- function(id) {
  ns <- NS(id)
  
  tagList( 
    uiOutput(ns('asourcetab'))
  )
  
}

source_server <- function(id) {
  
  moduleServer(id, function(input, output, session) { 
    ns <- session$ns
    
    # Text
    output$source_overview_text <- renderText({page_information(tbl=page_text, page_name="Source", page_section = "Overview", page_info = "description")})
    
    # Tables
    output$source_table <- DT::renderDataTable(create_source_table(d=source_info))
    
    # Tab layout
    output$asourcetab <- renderUI({
      
      tagList(
        
        # Source Data
        tags$div(class="page_goals", "RTP Dashboard Data Sources"),
        textOutput(ns("source_overview_text")) |> withSpinner(color=load_clr),
        br(),
        strong(tags$div(class="chart_title","Data Sources")),
        br(),
        fluidRow(column(12, dataTableOutput(ns("source_table")))),
        br()
      )
      
    })
    
  }) # end moduleServer
  
}
