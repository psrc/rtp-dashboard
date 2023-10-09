# Create the left panel

left_panel_ui <- function(id) {
  ns <- NS(id)
  
  tagList( 
    uiOutput(ns('aleftpanel'))
  )
  
}

left_panel_server <- function(id, page_nm) {
  
  moduleServer(id, function(input, output, session) { 
    ns <- session$ns
    
    # Text, Tables and Charts
    contact_name <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "contact_name")
    contact_title <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "contact_title")
    contact_phone <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "contact_phone")
    contact_email <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "contact_email")
    panel_photo <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "image")
    link1_html <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link1_html")
    link1_text <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link1_title")
    link2_html <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link2_html")
    link2_text <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link2_title")
    link3_html <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link3_html")
    link3_text <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link3_title")
    link4_html <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link4_html")
    link4_text <- page_information(tbl=left_panel_info, page_name=page_nm, page_info = "link4_title")

    # Tab layout
    output$aleftpanel <- renderUI({
      
      tagList(
        
        hr(),
        strong(tags$div(class="source_url","Regional Transportation Plan")),
        hr(style = "border-top: 1px solid #000000;"),
        tags$a(class = "source_url", href=link1_html, link1_text, target="_blank"),
        hr(style = "border-top: 1px solid #000000;"),
        tags$a(class = "source_url", href=link2_html, link2_text, target="_blank"),
        hr(style = "border-top: 1px solid #000000;"),
        tags$a(class = "source_url", href=link3_html, link3_text, target="_blank"),
        hr(style = "border-top: 1px solid #000000;"),
        tags$a(class = "source_url", href=link4_html, link4_text, target="_blank"),
        
        hr(style = "border-top: 1px solid #000000;"),
        div(img(src=panel_photo, width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Misc Picture")),
        hr(style = "border-top: 1px solid #000000;"),
        
        strong(tags$div(class="sidebar_heading","Connect With Us")),
        hr(style = "border-top: 1px solid #000000;"),
        tags$div(class="sidebar_notes", contact_name),
        tags$div(class="sidebar_notes", contact_title),
        br(),
        icon("envelope"), 
        tags$a(class = "source_url", href=paste0("mailto:",contact_email,"?"), "Email"),
        br(), br(),
        tags$div(icon("phone-volume"), class="sidebar_phone", contact_phone),
        hr(style = "border-top: 1px solid #000000;")
      
      )
      
    })
    
  }) # end moduleServer
  
}
