# New bslib version
shinyUI(
  
  tags$html(
    
    lang = "en",
    
    tags$head(tags$title("PSRC Regional Transportation Plan Performance Dashboard")),
    
    page_navbar(
      
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
      
                hr(style = "border-top: 1px solid #000000;"),
                
                card_body(
                  h1("Zero Emission Vehicles"),
                  class = "selection_panel"
                  ),
                
                br(),
                
                withSpinner(value_box_registrations_ui('REGIONregistrationvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("New Vehicle Registrations in the PSRC Region"),
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(3,9),
                       htmlOutput("climate_registrations_region"),
                       line_chart_ui('REGISTRATIONSlinechart')
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("New Registrations by Census Tract"),
                
                card(full_screen = FALSE,
                  
                  layout_columns(
                  
                  col_widths = c(6,6),
                  leafletOutput("ev_tract_map"),
                  htmlOutput("climate_registrations_tract")
                  
                )),

                hr(style = "border-top: 1px solid #000000;"),
                
                card_body(
                  h1("Vehicle Miles Traveled"),
                  class = "selection_panel"
                ),
                
                br(),

                value_box_ui('VMTvaluebox'),
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Daily Vehicle Miles Traveled in the PSRC Region"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(3,9),
                       htmlOutput("climate_vmt_region"),
                       line_chart_ui('VMTlinechart')
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Daily Vehicle Miles Traveled by County"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("climate_vmt_county"),
                     column_chart_counties_ui('VMTcounty'),
                     
                     ),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Vehicle Kilometers Traveled Comparison"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(3,9),
                       htmlOutput("climate_vkt_compare"),
                       bar_chart_ui('VKTcompare')
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                card_body(
                  h1("Work from Home"),
                  class = "selection_panel"
                ),
                
                br(),
                
                value_box_ui('WFHvaluebox'),
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Work from Home shares by County"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(8,4),
                       column_chart_ui('WFHcounty'),
                       htmlOutput("climate_wfh_region")
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Work from Home shares by Race & Ethnicity"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("climate_wfh_race"),
                     mepeople_chart_ui('WFHrace'),
                     
                ),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Work from Home shares by Metropolitan Region"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(4,8),
                       htmlOutput("climate_wfh_metro"),
                       bar_chart_ui('WFHmetro')
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Work from Home shares by City"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("climate_wfh_city"),
                     bar_chart_ui('WFHcity')
                     
                ),

                hr(style = "border-top: 1px solid #000000;")
              
      ), # end of navpanel for climate
      
      nav_panel("Transit", 
                
                tags$div(class="page_goals", "Plan Outcome: Triple transit trips by 2050"),
                htmlOutput("transit_overview"),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                card_body(
                  h1("Public Transportation Performance Metrics"),
                  class = "selection_panel"
                ),
                
                br(),
                
                value_box_ui('TRANSITMETRICvaluebox'),
                hr(style = "border-top: 1px solid #000000;"),
              
                h2("Public Transportation metrics in the PSRC Region"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(12),
                       line_chart_metric_ui('TRANSITlinechart'),
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation metrics by Transit Mode"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("transit_metric_mode"),
                     column_chart_transit_modes_ui('TRANSITMETRICmode'),
                     
                ),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation metrics by Metropolitan Region"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(4,8),
                       htmlOutput("transit_metric_metro"),
                       bar_chart_metric_ui('TRANSITMETRICmetro')
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                card_body(
                  h1("Public Transportation Mode Share"),
                  class = "selection_panel"
                ),
                
                br(),
                
                value_box_ui('TRANSITMODEvaluebox'),
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation shares by County"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(8,4),
                       column_chart_ui('TRANSITcounty'),
                       htmlOutput("transit_mode_region")
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation shares by Race & Ethnicity"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("transit_mode_race"),
                     mepeople_chart_ui('TRANSITrace'),
                     
                ),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation shares by Metropolitan Region"),
                
                card(full_screen = FALSE,
                     
                     layout_columns(
                       
                       col_widths = c(4,8),
                       htmlOutput("transit_mode_metro"),
                       bar_chart_ui('TRANSITmetro')
                       
                     )),
                
                hr(style = "border-top: 1px solid #000000;"),
                
                h2("Public Transportation shares by City"),
                
                card(full_screen = FALSE,
                     
                     htmlOutput("transit_mode_city"),
                     bar_chart_ui('TRANSITcity')
                     
                ),
                
                hr(style = "border-top: 1px solid #000000;")
                
      ), # end of navpanel for Transit
      
      br(), br(),
      
      footer = (footer_ui('psrcfooter'))
      
    ) # end of page_navbar
  ) # end of HTML tag for UI
) # end of Shiny App


