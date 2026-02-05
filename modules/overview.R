
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
    
    # links_withtags <- withTags(
    #   map2(transit_links[1:8], names(transit_links)[1:8], 
    #        ~div(class = "links-container", tags$a(class = "links", href = .x, .y, tabindex="0", target = "_blank")))
    # )
    
    # Overview UI
    output$overview <- renderUI({
      tagList(
        
        tags$head(
          tags$script(HTML("
        $(document).ready(function(){
          $('#carouselExampleControls').carousel('cycle');
        });
      "))
        ),
        
        htmlOutput(ns("overview_text")) |> withSpinner(color=load_clr),
        br(),
        htmlOutput(ns("overview_cmp")),
        br(),br(),
        
        card(
          layout_columns(
            
            col_widths = c(4, 8),
            card_body(br(), tags$img(src = "RTP-2026-System-Logo.jpg", class = "d-block w-100", alt = "RTP Logo")),
            card_body(dataTableOutput(ns("summary_table"))),
            #card_body(htmlOutput(ns("foundations_text")),),
            
            
          ), # end of layout_columns
        ), # end of card
        
      )
    })
  })  # end moduleServer
}
