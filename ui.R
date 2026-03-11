# bslib version

shinyUI(
  
  tags$html(
    
    lang = "en",
    
    tags$head(tags$title("PSRC Regional Transportation Plan Performance Dashboard")),
    
    page_sidebar(
      
      id = "main_nav",
      
      title = tags$div(
        style = "display: flex; align-items: center; gap: 20px;",
        tags$a(div(tags$img(
          src='psrc-logo.png', 
          style="margin-top: 10px; 
          padding-left: 20px; 
          padding-right: 30px;", 
          height = "65", 
          alt = "Link to PSRC Homepage")), 
          href="https://www.psrc.org", target="_blank"),
        tags$span(class="dashboard_title", "Draft 2026-2050 RTP Performance Dashboard")
      ),
      
      fillable = FALSE,
      theme = psrc_theme,
      
      sidebar = sidebar(
        title = NULL,
        width = 300,
        open = "desktop",
        
        tags$nav(
          `aria-label` = "Dashboard sections",
          
          radioButtons(
            inputId = "section_selection",
            label = "Select a topic area",
            choiceNames = list(
              "Overview",
              "Climate: Registrations",
              "Climate: VMT",
              "Climate: Work from Home",
              "Safety: Geography",
              "Safety: Demographics",
              "Safety: Other",
              "Growth: People & Jobs",
              "Transit: Boardings & Hours",
              "Transit: Commute to Work",
              "Walk & Bike: Walk to Work",
              "Walk & Bike: Bike to Work",
              "Travel Time: Commute",
              "Travel Time: Departure",
              "Travel Time: Congestion",
              "Resources"
            ),
            
            choiceValues = c(
              "overview",
              "registrations",
              "vmt",
              "wfh",
              "safety_geo",
              "safety_dem",
              "safety_oth",
              "growth",
              "boardings",
              "transit",
              "walking",
              "biking",
              "commute",
              "departure",
              "congestion",
              "resources"
            ),
            
            selected = "overview"
          )

        ) # end of tag for aria label
      
      ), # end of sidebar
      
      tags$main(
        uiOutput("main_content")
      ),

      
      tags$footer(footer_ui('psrcfooter'))
      
    ) # end of page_navbar
  ) # end of HTML tag for UI
) # end of Shiny App


