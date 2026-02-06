# bslib version

shinyUI(
  
  tags$html(
    
    lang = "en",
    
    tags$head(tags$title("PSRC Regional Transportation Plan Performance Dashboard")),
    
    page_navbar(
      
      id = "main_nav",
      
      # JavaScript to modify tabindex values to 0 so you can tab to them as well as using a mouse
      tags$script(HTML("
      $(document).ready(function() {
        function setTabindex() {
          $('.nav-link').attr('tabindex', '0');
        }
        // Set tabindex initially
        setTabindex();
  
        // Listen for tab changes and reset tabindex
        $('.nav-link').on('shown.bs.tab', function() {
          setTabindex();
        });
      });
    ")),
      
      navbar_options = navbar_options(position = c("static-top")),
      
      title = tags$a(div(tags$img(src='psrc-logo.png', style="margin-top: 10px; padding-left: 20px; padding-right: 30px;", height = "65", alt = "Link to PSRC Homepage")), href="https://www.psrc.org", target="_blank"),
      fillable = FALSE,
      theme = psrc_theme,
      
      nav_panel("Overview", 
                h1("RTP Performance Dashboard and Congestion Management Process"),
                overview_ui('OVERVIEW'),
                h2("What is in this dashboard?"),
                htmlOutput("howto_text")),
      
      nav_panel("Climate", 
                
                tags$div(class="page_goals", "Goal: 80% below 1990 GHG Emissions by 2050"),
                
                htmlOutput("climate_overview"),
                br(), br(),
                
                card_body(
                  selectizeInput(
                    inputId = "climate_section",
                    label = "Select a climate topic",
                    choices = c(
                      "Zero Emission Vehicles" = "zev",
                      "Vehicle Miles Traveled" = "vmt",
                      "Work from Home" = "wfh"
                    ),
                    selected = "zev",
                    options = list(dropdownParent = 'body')
                  ),
                  class = "selection_panel"
                ),

                br(),
                
                uiOutput("climate_section_ui")

      ), # end of navpanel for climate
      
      nav_panel("Transit", 
                
                tags$div(class="page_goals", "Plan Outcome: Triple transit trips by 2050"),
                
                htmlOutput("transit_overview"),
                br(), br(),
                
                card_body(
                  selectizeInput(
                    inputId = "transit_section",
                    label = "Select a transit topic",
                    choices = c(
                      "Boardings & Hours" = "trnmet",
                      "Commute to Work" = "trnmod"
                    ),
                    selected = "trnmet",
                    options = list(dropdownParent = 'body')
                  ),
                  class = "selection_panel"
                ),
                
                br(),
                
                uiOutput("transit_section_ui")
                
      ), # end of navpanel for Transit
      
      nav_panel("Walk & Bike", 
                
                tags$div(class="page_goals", "Plan Outcome: 21% More Walking & Biking by 2050"),
                
                htmlOutput("walk_bike_overview"),
                br(), br(),
                
                card_body(
                  selectizeInput(
                    inputId = "walk_bike_section",
                    label = "Select walk or bike",
                    choices = c(
                      "Walking" = "wlkmod",
                      "Biking" = "bikmod"
                    ),
                    selected = "wlkmod",
                    options = list(dropdownParent = 'body')
                  ),
                  class = "selection_panel"
                ),
                
                br(),
                
                uiOutput("walk_bike_section_ui")
                
      ), # end of navpanel for Walking & Biking
      
      br(), br(),
      
      footer = (footer_ui('psrcfooter'))
      
    ) # end of page_navbar
  ) # end of HTML tag for UI
) # end of Shiny App


