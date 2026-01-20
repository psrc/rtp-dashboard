# Display footer

footer_ui <- function(id) {
  ns <- NS(id)

  tagList( 
    
    card(
      
      layout_columns(
        col_widths = c(2,7,3),
        
        card_body(tags$img(src='footer-logo.png', style="margin-top: 0x; padding-left: 0px; padding-right: 0px;", class = "responsive-image", alt = "PSRC logo"), class = "footer_panel"),
        
        card_body(
          tags$div(class = "footer_heading", HTML(paste0("About PSRC<br>", tags$div(class = "footer_about", psrc_mission)))),
        ),
        
        card_body(
          tags$div(class = "footer_heading", HTML(
            paste0(
              "Connect with PSRC<br>", 
              tags$div(
                class = "psrc-location", 
                style = "display: flex; align-items: top;",
                icon("location-dot", class = "m-connect-loc"), 
                div(
                  div("1201 Third Avenue, Suite 500"), 
                  "Seattle, WA 98101-3055")
                ),
              tags$div(class = "psrc-phone", 
                       style = "display: flex; align-items: center;", 
                       icon("phone-volume", class = "m-connect"), 
                       "206-464-7090"
                       ),
              tags$a(class = "psrc_email",
                     icon("envelope", class = "m-connect"), 
                     href = paste0("mailto:","info@psrc.org","?"), 
                     "info@psrc.org")
              ))),
        ),
      ),
      
      card_footer(
        layout_columns(
          col_widths = c(9,3),
          card_body(div(
            a(class = "footer_url", 
              href="https://www.facebook.com/PugetSoundRegionalCouncil", 
              icon("facebook", class = "soc-connect"),
              span("Link to PSRC's Facebook page", class = "sr-only"), 
              target="_blank"),
            a(class = "footer_url", 
              href="https://twitter.com/SoundRegion", 
              icon("x-twitter", class = "soc-connect"),
              span("Link to PSRC's Twitter feed", class = "sr-only"),
              target="_blank"),
            a(class = "footer_url", 
              href="https://www.instagram.com/soundregion/", 
              icon("instagram", class = "soc-connect"), 
              span("Link to PSRC's Instagram feed", class = "sr-only"),
              target="_blank"),
            a(class = "footer_url", 
              href="https://www.linkedin.com/company/soundregion", 
              icon("linkedin", class = "soc-connect"), 
              span("Link to PSRC's LinkedIn feed", class = "sr-only"),
              target="_blank")
          )),
          
          tags$div(class = "footer_about", "Dashboard by", tags$div(class = "footer_url", "PSRC Data Science")),
        ),
        class = "footer_footer"),
      class = "footer_panel"
    )
  )
  
}

footer_server <- function(id) {
  
  moduleServer(id, function(input, output, session) { 
    ns <- session$ns
    
  }) # end moduleServer
  
}