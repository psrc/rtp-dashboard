# shinyUI(
#   
#   navbarPage(
#     
#     tags$style(HTML("
#     .tabbable > .nav > li > a {background-color: #005753;  color:white}
#     .tabbable > .nav > li.active > a {background-color: #91268F; color:white}
#   ")),
#     
#     id = "RTP-Dashboard",
#     tags$style("@import url(https://use.fontawesome.com/releases/v6.3.0/css/all.css);"),
#     title = tags$a(div(tags$img(src='footer-logo.png',
#                              style="margin-top: -30px; padding-left: 40px;",
#                              height = "80")
#                              ), href="https://www.psrc.org", target="_blank"),
#              tags$head(
#                tags$style(HTML('.navbar-nav > li > a, .navbar-brand {
#                             padding-top:25px !important; 
#                             padding-bottom:0 !important;
#                             height: 75px;
#                             }
#                            .navbar {min-height:25px !important;}'))
#              ),
#     
#     windowTitle = "PSRC Regional Transportation Plan Dashboard", 
#     theme = "styles.css",
#     position = "fixed-top",
#              
#     tabPanel(title="Overview",
#              value="Overview-Page",
#              banner_ui('overviewBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftOverview')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              dashboard_overview_ui('Mainoverview'),
#                              ), # end of second fluid row for main overview page
#                       ) # end of second fluid row for main overview page
#              ), # end of tabpanel for Overview
#              
#     tabPanel(title="Climate", 
#              value="Climate-Page",
#              banner_ui('climateBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftClimate')),
#                       column(8, style='padding-left:25px; padding-right:50px;', 
#                              climate_overview_ui('climateOverview'),
#                              tabsetPanel(type = "pills",
#                                          tabPanel("Zero Emission Vehicles", climate_zev_ui('ZEVclimate')),
#                                          tabPanel("Vehicle Miles Traveled", climate_vmt_ui('VMTclimate')),
#                                          tabPanel("Work from Home", telework_ui('WFHmode')))
#                              ), # End of Main Panel for Climate
#                       ) # End of Main Panel Fluid Row for Climate Tab
#              ), # End of Tab Panel for Climate
#     
#     tabPanel(title="Safety", 
#              value = "Safety-Page",
#              banner_ui('safetyBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftSafety')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              safety_overview_ui('safetyOverview'),
#                              tabsetPanel(type = "pills",
#                                          tabPanel("Geography", safety_geography_ui('Geographysafety')),
#                                          tabPanel("Demographics", safety_demographics_ui('Demographicsafety')),
#                                          tabPanel("Other", safety_other_ui('Othersafety')))
#                       ), # End of Main Panel for Safety
#              ), # End of Main Panel Fluid Row for Safety Tab
#     ),# End of Tab Panel for Safety
#     
#     tabPanel(title=HTML("Growth"), 
#              value="Growth-Page",
#              banner_ui('growthBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftGrowth')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              growth_overview_ui('growthOverview'),
#                              growth_ui('PopHsgJobgrowth')
#                              ), # End of Main Panel for Growth
#                       ), # End of Main Panel Fluid Row for Growth Tab
#              ),# End of Tab Panel for Growth
#     
#     tabPanel(title=HTML("Transit"), 
#              value="Transit-Page",
#              banner_ui('transitBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftTransit')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              transit_overview_ui('transitOverview'),
#                              tabsetPanel(type = "pills",
#                                          tabPanel("Boardings & Revenue-Hours", transit_metrics_ui('Metricstransit')),
#                                          tabPanel("Transit to Work", modeshare_ui('Modetransit')))
#                       ), # End of Main Panel Transit
#              ), # End of Main Panel Fluid Row for Transit Tab
#     ),# End of Tab Panel for Transit
#     
#     tabPanel(title=HTML("Walk &<br/>Bike"),
#              value="Mode-Page",
#              banner_ui('modeBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftMode')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              mode_overview_ui('modeOverview'),
#                              tabsetPanel(type = "pills",
#                                          tabPanel("Walking", walk_ui('Walkmode')),
#                                          tabPanel("Biking", bike_ui('Bikemode')))
#                              ), # End of Main Panel Modes
#                       ), # End of Main Panel Fluid Row for Modes Tab
#              ),# End of Tab Panel for Modes
#     
#     tabPanel(title=HTML("Travel<br/>Time"),
#              value="Time-Page",
#              banner_ui('timeBanner'),
#              fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftTime')),
#                       column(8, style='padding-left:25px; padding-right:50px;',
#                              time_overview_ui('timeOverview'),
#                              tabsetPanel(type = "pills",
#                                          tabPanel("Travel Time", tt_ui('TTtime')),
#                                          tabPanel("Departure Time", dt_ui('DTtime')),
#                                          tabPanel("Congestion", congestion_ui('Congestiontime')))
#                       ), # End of Main Panel Time and Congestion
#              ), # End of Main Panel Fluid Row for Time Tab
#     ),# End of Tab Panel for Travel Time and Congestion
#     
#     # tabPanel(title=HTML("Projects"), 
#     #          value="Projects-Page",
#     #          banner_ui('projectsBanner'),
#     #          fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftProjects')),
#     #                   column(8, style='padding-left:25px; padding-right:50px;',
#     #                          projects_overview_ui('projectsOverview'),
#     #                          tabsetPanel(type = "pills",
#     #                                      tabPanel(HTML("2022 FHWA<br/>Project Selection"), project_selection_ui('Projectsselection')),
#     #                                      tabPanel(HTML("2023-2026 <br/>Regional TIP"), tip_ui('Projectstip')))
#     #                   ), # End of Main Panel for Projects
#     #          ), # End of Main Panel Fluid Row for Projects Tab
#     # ),# End of Tab Panel for Projects
#     
#     tabPanel(title=icon("info-circle"),
#              value="Data-Source-Page",
#              hr(style = "border-top: 1px solid #000000;"),
#              source_ui('dataSource')),
#              hr(style = "border-top: 1px solid #000000;"),
#     
#     tags$footer(footer_ui('psrcfooter'))
#     
#     ) # End of NavBar Page
#   ) # End of Shiny App

# New bslib version

shinyUI(
  
  tags$html(
    
    lang = "en",
    
    tags$head(tags$title("PSRC Regional Transportation Plan Dashboard")),
    
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
      
      position = c("static-top"),
      
      title = tags$a(div(tags$img(src='psrc-logo.png', style="margin-top: 10px; padding-left: 20px; padding-right: 30px;", height = "65", alt = "Link to PSRC Homepage")), href="https://www.psrc.org", target="_blank"),
      fillable = FALSE,
      theme = psrc_theme,
      
      nav_panel("Overview", 
                h1("RTP Performance Dashboard"),
                overview_ui('OVERVIEW'),
                h2("What is in this dashboard?"),
                htmlOutput("howto_text")),
      
      # nav_panel("Region", 
      #           card_body(
      #             selectizeInput(
      #               "RegionMetric",
      #               label = "Select a Transit Metric:",
      #               choices = ntd_metric_list,
      #               selected = "Boardings",
      #               options = list(dropdownParent = 'body')
      #             ),
      #             class = "selection_panel"
      #           ),
      #           
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h1("Regionwide Transit Summary"),
      #           withSpinner(value_box_ntd_ui('REGIONvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Regionwide Transit Trends"),
      #           bar_chart_ui('REGIONbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("region_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel("Mode", 
      #           card_body(
      #             selectizeInput(
      #               "NTDModes",
      #               label = "Select a Transit Mode:",
      #               choices = ntd_mode_list,
      #               selected = "Bus",
      #               options = list(dropdownParent = 'body')
      #             ),
      #             class = "selection_panel"
      #           ),
      #           
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Boardings Section
      #           h1("Boarding Summary"),
      #           withSpinner(value_box_ntd_ui('MODEBoardingsvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Boarding Trends"),
      #           bar_chart_ui('MODEBoardingsbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("mode_boardings_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Revenue Hours Section
      #           h1("Revenue Hour Summary"),
      #           value_box_ntd_ui('MODEHoursvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Revenue Hour Trends"),
      #           bar_chart_ui('MODEHoursbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("mode_hours_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Revenue Miles Section
      #           h1("Revenue Mile Summary"),
      #           value_box_ntd_ui('MODEMilesvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Revenue Mile Trends"),
      #           bar_chart_ui('MODEMilesbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("mode_miles_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Boardings per Hour Section
      #           h1("Boardings per Hour Summary"),
      #           value_box_ntd_ui('MODEBPHvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Boardings per Hour Trends"),
      #           bar_chart_ui('MODEBPHbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("mode_bph_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel("Operator", 
      #           
      #           card_body(
      #             selectizeInput(
      #               "NTDoperators",
      #               label = "Select a Transit Operator:",
      #               choices = ntd_operator_list,
      #               selected = "Community Transit",
      #               options = list(dropdownParent = 'body')
      #             ),
      #             class = "selection_panel"
      #           ),
      #           
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Boardings Section
      #           h1("Boarding Summary"),
      #           withSpinner(value_box_ntd_ui('OPERATORBoardingsvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Boarding Trends"),
      #           bar_chart_ui('OPERATORBoardingsbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("operator_boardings_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Revenue Hours Section
      #           h1("Revenue Hour Summary"),
      #           value_box_ntd_ui('OPERATORHoursvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Revenue Hour Trends"),
      #           bar_chart_ui('OPERATORHoursbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("operator_hours_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Revenue Miles Section
      #           h1("Revenue Mile Summary"),
      #           value_box_ntd_ui('OPERATORMilesvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Revenue Mile Trends"),
      #           bar_chart_ui('OPERATORMilesbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("operator_miles_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           
      #           # Boardings per Hour Section
      #           h1("Boardings per Hour Summary"),
      #           value_box_ntd_ui('OPERATORBPHvaluebox'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Boardings per Hour Trends"),
      #           bar_chart_ui('OPERATORBPHbarchart'),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("operator_bph_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel("Type", 
      #           card_body(
      #             layout_column_wrap(
      #               width = 1/3,
      #               selectizeInput("TYPEbuffer", label = "Select a Transit Type:", choices = stop_buffer_list, selected = "High-Capacity Transit", options = list(dropdownParent = 'body')),
      #               selectizeInput("TYPErace", label = "Select a Population of Interest", choices = efa_list, selected = "People of Color", options = list(dropdownParent = 'body')),
      #               radioButtons("TYPEdist", label = "Select a Buffer Distance:", choiceNames = c("1/4 mile", "1/2 mile"), choiceValues = c(0.25, 0.50), inline = TRUE)
      #             ),
      #             class = "selection_panel"
      #           ),
      #           
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h1("People living Near a Transit Stop"),
      #           withSpinner(value_box_access_ui('TYPEvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Transit Access Trends"),
      #           card(
      #             full_screen = TRUE,
      #             card_body(
      #               layout_columns(
      #                 col_widths = c(7,5),
      #                 plotlyOutput("transit_type_chart"),
      #                 tags$div(
      #                   role = "img",
      #                   `aria-label` = "Map showing transit stops matching the selected transit type and buffer distance from the selectors on the page",
      #                   leafletOutput("transit_type_map"),
      #                 )
      #               )
      #             )
      #           ),
      #           br(),
      #           tags$div(class="chart_source","Source: US Census Bureau ACS Data, OFM Small Area Estimate & General Transit Feed Specification (GTFS) service data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("type_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel("Frequency", 
      #           card_body(
      #             layout_column_wrap(
      #               width = 1/3,
      #               selectizeInput("TRIPbuffer", label = "Select a Trip Frequency:", stop_trips_list, selected = "4 trips per hour", options = list(dropdownParent = 'body')),
      #               selectizeInput("TRIPrace", label = "Select a Population of Interest", choices = efa_list, selected = "People of Color", options = list(dropdownParent = 'body')),
      #               radioButtons("TRIPdist", label = "Select a Buffer Distance:", choiceNames = c("1/4 mile", "1/2 mile"), choiceValues = c(0.25, 0.50), inline = TRUE)
      #             ),
      #             class = "selection_panel"
      #           ),
      #           
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h1("People living Near a Transit Stop"),
      #           withSpinner(value_box_access_ui('TRIPvaluebox'), color=load_clr, size = 1.5, caption = "Please wait, updating data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           h2("Transit Access Trends"),
      #           card(
      #             full_screen = TRUE,
      #             card_body(
      #               layout_columns(
      #                 col_widths = c(7,5),
      #                 plotlyOutput("transit_trip_chart"),
      #                 tags$div(
      #                   role = "img",
      #                   `aria-label` = "Map showing transit stops matching the selected transit frequency and buffer distance from the selectors on the page",
      #                   leafletOutput("transit_trip_map"),
      #                 )
      #               )
      #             )
      #           ),
      #           br(),
      #           tags$div(class="chart_source","Source: US Census Bureau ACS Data, OFM Small Area Estimate & General Transit Feed Specification (GTFS) service data"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card_body(h3("Insights & Analysis"), htmlOutput("trip_insights_text"), class = "insights_panel"),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel("Routes", 
      #           h1("Transit Routes in the Central Puget Sound Region"),
      #           card(
      #             full_screen = TRUE,
      #             tags$div(
      #               role = "img",
      #               `aria-label` = "Map showing transit routes in the Central Puget Sound Region in 2024 color coded by type of transit route",
      #               withSpinner(leafletOutput("transit_route_map"), color=load_clr, size = 1.5, caption = "Please wait, loading map"),
      #             )
      #           ),
      #           tags$div(class="chart_source", textOutput("route_map_source")),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      # nav_panel(icon("info-circle"), 
      #           h1("Data Sources"),
      #           htmlOutput("source_overview_text"),
      #           hr(style = "border-top: 1px solid #000000;"),
      #           card(
      #             full_screen = TRUE,
      #             withSpinner(dataTableOutput("source_table"), color=load_clr, size = 1.5, caption = "Please wait, loading table")
      #           ),
      #           hr(style = "border-top: 1px solid #000000;")
      # ),
      # 
      br(), br(),
      
      footer = (footer_ui('psrcfooter'))
      
    ) # end of page_navbar
  ) # end of HTML tag for UI
) # end of Shiny App


