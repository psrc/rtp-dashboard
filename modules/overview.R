
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
        
        card(
          layout_columns(
            
            col_widths = c(4, 8),
            card_body(br(), tags$img(src = "RTP-2026-System-Logo.jpg", class = "d-block w-100", alt = "RTP Logo")),
            card_body(dataTableOutput(ns("summary_table"))),
            #card_body(htmlOutput(ns("foundations_text")),),
            
            
          ), # end of layout_columns
        ), # end of card
        
        # card(
        # layout_columns(
        #   
        #   col_widths = c(3, 4, 5),
        #   
        #   card_body(
        #     div("Transit Resources", class = "m-menu__title"),
        #     div(a(class = "source_url left-panel-url", href = "https://www.transit.dot.gov/ntd/ntd-data", "National Transit Database", target="_blank"), class = "focus", tabindex="0"),
        #     div(a(class = "source_url left-panel-url", "Transit Planning at PSRC", href = "https://www.psrc.org/our-work/transit", target = "_blank"), class = "focus", tabindex="0"),
        #     accordion(id = "transit-collapse", open = FALSE, accordion_panel("Transit Agency Websites", links_withtags))
        #   ),
        #   
        #   card_body(htmlOutput(ns("agency_text")),),
        #   
        #   card_body(
        #     
        #     # Carousel component with HTML structure
        #     tags$div(id = "carouselExampleControls", class = "carousel slide", 
        #              `data-bs-ride` = "carousel",
        #              `data-bs-interval` = "5000",
        #              tags$div(class = "carousel-inner",
        #                       tags$div(class = "carousel-item active",
        #                                tags$img(src = "ct_adj.jpg", class = "d-block w-100", alt = "Community Transit bus leaving a station")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "kc-fast-ferry_adj.jpg", class = "d-block w-100", alt = "King County Water Taxi at a dock")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "et_adj.jpg", class = "d-block w-100", alt = "Everett Transit bus at a bus stop")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "wsf_adj.jpg", class = "d-block w-100", alt = "Washington State Ferry on the waters of Puget Sound")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "slu_adj.jpg", class = "d-block w-100", alt = "Streetcar in South Lake Union neighborhood of Seattle Wa")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "kcm_adj.jpg", class = "d-block w-100", alt = "King County Metro bus at a stop in Kirkland Wa")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "pt_adj.jpg", class = "d-block w-100", alt = "Pierce Transit bus")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "line2_adj.jpg", class = "d-block w-100", alt = "Sound Transit 2 Line Light rail trains at a station")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "kt-fast-ferry_adj.jpg", class = "d-block w-100", alt = "Kitsap County Fast ferry on the water")
        #                       ),
        #                       tags$div(class = "carousel-item",
        #                                tags$img(src = "sounder_adj.jpg", class = "d-block w-100", alt = "Sound Transit Commuter Rail train leaving a station")
        #                       )
        #              ),
        #              # Controls
        #              tags$button(class = "carousel-control-prev", type = "button", `data-bs-target` = "#carouselExampleControls", `data-bs-slide` = "prev",
        #                          tags$span(class = "carousel-control-prev-icon", `aria-hidden` = "true"),
        #                          tags$span(class = "visually-hidden", "Previous")
        #              ),
        #              tags$button(class = "carousel-control-next", type = "button", `data-bs-target` = "#carouselExampleControls", `data-bs-slide` = "next",
        #                          tags$span(class = "carousel-control-next-icon", `aria-hidden` = "true"),
        #                          tags$span(class = "visually-hidden", "Next")
        #              )
        #     ) # end of carousel body
        #     
        #   ), # end of carosuel card body
        #   
        # ), # end of layout_columns
        # 
        # ), # end of card

      )
    })
  })  # end moduleServer
}
