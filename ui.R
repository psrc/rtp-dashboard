shinyUI(
  
  navbarPage(
    
    id = "RTP-Dashboard",
    tags$style("@import url(https://use.fontawesome.com/releases/v6.3.0/css/all.css);"),
    title = tags$a(div(tags$img(src='psrc-logo.png',
                             style="margin-top: -30px; padding-left: 40px;",
                             height = "80")
                             ), href="https://www.psrc.org", target="_blank"),
             tags$head(
               tags$style(HTML('.navbar-nav > li > a, .navbar-brand {
                            padding-top:25px !important; 
                            padding-bottom:0 !important;
                            height: 75px;
                            }
                           .navbar {min-height:25px !important;}'))
             ),
    
    windowTitle = "RTP Dashboard - Development Version", 
    theme = "styles.css",
    position = "fixed-top",
             
    tabPanel(title="Overview",
             value="Overview-Page",
             banner_ui('overviewBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftOverview')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             hr(),
                             tags$div(class="page_goals", "This is the Development Version of the APP"),
                             br(), br(),
                             "The RTP Performance Dashboard is a resource to help the region understand how well it is meeting it's long range goals. At a minimum, the dashboard will be updated 
                             each fall as various Census and Transportation related metrics are released. 
                             Metrics on the dashboard are focused on topic areas that were identified by the Transporation Policy Board as high priorities for the region",
                             hr(),
                             ), # end of second fluid row for main overview page
                      ) # end of second fluid row for main overview page
             ), # end of tabpanel for Overview
             
    tabPanel(title="Climate", 
             value="Climate-Page",
             banner_ui('climateBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftClimate')),
                      column(8, style='padding-left:25px; padding-right:50px;', 
                             climate_overview_ui('climateOverview'),
                             tabsetPanel(type = "pills",
                                         tabPanel("Zero Emission Vehicles", climate_zev_ui('ZEVclimate')),
                                         tabPanel("Vehicle Miles Traveled", climate_vmt_ui('VMTclimate')))
                             ), # End of Main Panel for Climate
                      ) # End of Main Panel Fluid Row for Climate Tab
             ), # End of Tab Panel for Climate
    
    tabPanel(title="Safety", 
             value = "Safety-Page",
             banner_ui('safetyBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftSafety')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             safety_overview_ui('safetyOverview'),
                             tabsetPanel(type = "pills",
                                         tabPanel("Geography", safety_geography_ui('Geographysafety')),
                                         tabPanel("Demographics", safety_demographics_ui('Demographicsafety')),
                                         tabPanel("Other", safety_other_ui('Othersafety')))
                      ), # End of Main Panel for Safety
             ), # End of Main Panel Fluid Row for Safety Tab
    ),# End of Tab Panel for Safety
    
    tabPanel(title=HTML("Growth"), 
             value="Growth-Page",
             banner_ui('growthBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftGrowth')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             growth_overview_ui('growthOverview'),
                             tabsetPanel(type = "pills",
                                         tabPanel("Population", population_ui('Populationgrowth')),
                                         tabPanel("Housing", housing_ui('Housinggrowth')),
                                         tabPanel("Jobs", jobs_ui('Jobsgrowth')))
                             ), # End of Main Panel for Growth
                      ), # End of Main Panel Fluid Row for Growth Tab
             ),# End of Tab Panel for Growth
    
    tabPanel(title=HTML("Walk,<br/>Bike & Roll"),
             value="Mode-Page",
             banner_ui('modeBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftMode')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             mode_overview_ui('modeOverview'),
                             tabsetPanel(type = "tabs",
                                         tabPanel("Walking", walk_ui('Walkmode')),
                                         tabPanel("Biking", bike_ui('Bikemode')),
                                         tabPanel("Work from Home", telework_ui('WFHmode')))
                             ), # End of Main Panel Modes
                      ), # End of Main Panel Fluid Row for Modes Tab
             ),# End of Tab Panel for Modes
    
    tabPanel(title=HTML("Transit<br/>Performance"), 
             value="Transit-Page",
             banner_ui('transitBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftTransit')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             transit_overview_ui('transitOverview'),
                             tabsetPanel(type = "tabs",
                                         tabPanel("Boardings", boardings_ui('Boardingstransit')),
                                         tabPanel("Revenue-Hours", revhours_ui('Hourstransit')),
                                         tabPanel("Transit Share", modeshare_ui('Modetransit')))
                             ), # End of Main Panel Transit
                      ), # End of Main Panel Fluid Row for Transit Tab
             ),# End of Tab Panel for Transit
    
    tags$footer(footer_ui('psrcfooter'))
    
    ) # End of NavBar Page
  ) # End of Shiny App
