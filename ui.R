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
    
    windowTitle = "RTP Dashboard", 
    theme = "styles.css",
    position = "fixed-top",
             
    tabPanel(title="Overview",
             value="Overview-Page",
             banner_ui('overviewBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftOverview')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             hr(),
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
                             tabsetPanel(type = "tabs",
                                         tabPanel("Zero Emission Vehicles", climate_zev_ui('ZEVclimate')),
                                         tabPanel("Vehicle Miles Traveled", climate_vmt_ui('VMTclimate')))
                             ), # End of Main Panel for Climate
                      ) # End of Main Panel Fluid Row for Climate Tab
             ), # End of Tab Panel for Climate
    
    tabPanel(title=HTML("Growth"), 
             value="Growth-Page",
             banner_ui('growthBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftGrowth')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             growth_overview_ui('growthOverview'),
                             tabsetPanel(type = "tabs",
                                         tabPanel("Population", population_ui('Populationgrowth')),
                                         tabPanel("Housing", housing_ui('Housinggrowth')),
                                         tabPanel("Jobs", jobs_ui('Jobsgrowth')))
                             ), # End of Main Panel for Growth
                      ), # End of Main Panel Fluid Row for Growth Tab
             ),# End of Tab Panel for Growth
    
    tabPanel(title="Safety", 
             value = "Safety-Page",
             banner_ui('safetyBanner'),
             fluidRow(column(4, style='padding-left:25px; padding-right:0px;', left_panel_ui('leftSafety')),
                      column(8, style='padding-left:25px; padding-right:50px;',
                             safety_overview_ui('safetyOverview'),
                             tabsetPanel(type = "tabs",
                                         tabPanel("Traffic Deaths", fatal_ui('Fatalsafety')),
                                         tabPanel("Serious Injuries", serious_ui('Serioussafety')))
                             ), # End of Main Panel for Safety
                      ), # End of Main Panel Fluid Row for Safety Tab
             ),# End of Tab Panel for Safety
    
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
             
             navbarMenu(HTML("Transit<br/>Performance"), 
                        
                        tabPanel(title="Overview",
                                 value="Transit-Overview",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Transit Performance")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Transit Planning Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/278", "Transit Access", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/2158", "Transit Integration", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/10200", "Transit-Oriented Development (TOD)", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/4958", "Transit-Supportive Densities and Land Uses", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 div(img(src="transitorienteddevelopment.jpeg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gil Cerise:"),
                                                 tags$div(class="sidebar_notes","Program Manager"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gcerise@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3053",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","RTP Outcome: Triple Transit Boardings by 2050"),
                                                 br(),
                                                 textOutput("transit_text_1"),
                                                 br(),
                                                 textOutput("transit_text_2"),
                                                 br(),
                                                 textOutput("transit_text_3"),
                                                 br(), 
                                                 div(img(src="st_northgate_trim.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:0px 0 0px 0;", alt = "Bar chart of Greenhouse Gas Emissions in 2050")),
                                                 br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Overview
                        
                        tabPanel(title="Transit Boardings",
                                 value="Transit-UPT",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Annual Transit Boardings")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Transit Planning Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/278", "Transit Access", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/2158", "Transit Integration", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/10200", "Transit-Oriented Development (TOD)", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/4958", "Transit-Supportive Densities and Land Uses", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 div(img(src="bellevuetransitcenter.jpg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gil Cerise:"),
                                                 tags$div(class="sidebar_notes","Program Manager"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gcerise@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3053",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","RTP Outcome: Triple Transit Boardings by 2050"),
                                                 h1("Annual Transit Boardings in the PSRC Region"),
                                                 hr(),
                                                 strong(tags$div(class="chart_title","Annual Regional Transit Boardings")),
                                                 fluidRow(column(12,plotlyOutput("chart_transit_boardings"))),
                                                 tags$div(class="chart_source","Source: FTA National Transit Database"),
                                                 hr(),
                                                 h1("Transit Boardings by Mode"),
                                                 br(),
                                                 strong(tags$div(class="chart_title","YTD Regional Transit Boardings by Mode")),
                                                 fluidRow(column(12,plotOutput("chart_boardings_mode"))),
                                                 tags$div(class="chart_source","Source: FTA National Transit Database"),
                                                 hr(),
                                                 h1("Transit Boardings by Metropolitan Region"),
                                                 br(),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Boardings: ",pre_covid)))),
                                                          column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Boardings: ",current_population_year))))),
                                                 fluidRow(column(6,plotlyOutput("mpo_boardings_precovid_chart")),
                                                          column(6,plotlyOutput("mpo_boardings_today_chart"))),
                                                 fluidRow(column(6,tags$div(class="chart_source","Source: FTA National Transit Database")),
                                                          column(6,tags$div(class="chart_source","Source: FTA National Transit Database"))),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Boardings
                        
                        tabPanel(title="Transit Revenue-Hours",
                                 value="Transit-VRH",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Annual Transit Revenue-Hours")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Transit Planning Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/278", "Transit Access", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/2158", "Transit Integration", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/10200", "Transit-Oriented Development (TOD)", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/4958", "Transit-Supportive Densities and Land Uses", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 div(img(src="linkbeaconhillstn.jpg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gil Cerise:"),
                                                 tags$div(class="sidebar_notes","Program Manager"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gcerise@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3053",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","RTP Input: 66% More Revenue-Hours by 2050"),
                                                h1("Annual Transit Revenue-Hours in the PSRC Region"),
                                                 hr(),
                                                 strong(tags$div(class="chart_title","Annual Regional Transit Revenue-Hours")),
                                                 fluidRow(column(12,plotlyOutput("chart_transit_hours"))),
                                                 tags$div(class="chart_source","Source: FTA National Transit Database"),
                                                 hr(),
                                                 h1("Transit Revenue-Hours by Mode"),
                                                 br(),
                                                 strong(tags$div(class="chart_title","YTD Regional Transit Revenue-Hours by Mode")),
                                                 fluidRow(column(12,plotOutput("chart_hours_mode"))),
                                                 tags$div(class="chart_source","Source: FTA National Transit Database"),
                                                 hr(),
                                                 h1("Transit Revenue-Hours by Metropolitan Region"),
                                                 br(),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title",paste0("YTD Transit Revenue-Hours: ",pre_covid)))),
                                                          column(6,strong(tags$div(class="chart_title",paste0("YTD Transit  Revenue-Hours: ",current_population_year))))),
                                                 fluidRow(column(6,plotlyOutput("mpo_hours_precovid_chart")),
                                                          column(6,plotlyOutput("mpo_hours_today_chart"))),
                                                 fluidRow(column(6,tags$div(class="chart_source","Source: FTA National Transit Database")),
                                                          column(6,tags$div(class="chart_source","Source: FTA National Transit Database"))),
                                                 hr()
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Revenue-Hours
                        
                        tabPanel(title="Transit Mode Share",
                                 value="Transit-Mode",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Transit Mode Share to Work")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Transit Planning Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/278", "Transit Access", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/2158", "Transit Integration", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/10200", "Transit-Oriented Development (TOD)", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/4958", "Transit-Supportive Densities and Land Uses", target="_blank"),
                                                 hr(style = "border-top: 1px solid #000000;"),
                                                 div(img(src="linkbeaconhillstn.jpg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gil Cerise:"),
                                                 tags$div(class="sidebar_notes","Program Manager"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gcerise@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3053",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","Plan Outcome: 13% Transit Share by 2050"),
                                                 br(),
                                                 h1("Transit Mode Share to Work in the PSRC Region"),
                                                 hr(),
                                                 strong(tags$div(class="chart_title","Transit Mode Share to Work")),
                                                 fluidRow(column(12,plotlyOutput("transit_ms_region_chart"))),
                                                 tags$div(class="chart_source","Source: ACS 1yr Data Table B08006 for King, Kitsap, Pierce and Snohomish counties"),
                                                 hr(),
                                                 
                                                 h1("Transit Mode Share to Work by County"),
                                                 br(),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title","Transit to Work: King County"))),
                                                          column(6,strong(tags$div(class="chart_title","Transit to Work: Kitsap County")))),
                                                 fluidRow(column(6,plotlyOutput("transit_ms_king_chart")),
                                                          column(6,plotlyOutput("transit_ms_kitsap_chart"))),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title","Transit to Work: Pierce County"))),
                                                          column(6,strong(tags$div(class="chart_title","Transit to Work: Snohomish County")))),
                                                 fluidRow(column(6,plotlyOutput("transit_ms_pierce_chart")),
                                                          column(6,plotlyOutput("transit_ms_snohomish_chart"))),
                                                 tags$div(class="chart_source","Source: ACS 1yr Data Table B08006 for King, Kitsap, Pierce and Snohomish counties"),
                                                 hr(),
                                                 
                                                 h1("Transit Mode Share to Work by Race/Ethnicity"),
                                                 br(),
                                                 selectInput("Transit_Race_MS_Year","Select Latest Year:",list("Year" = transit_years), selected = "2021"),
                                                 br(),
                                                 strong(tags$div(class="chart_title",textOutput("transit_ms_race_today_text"))),
                                                 fluidRow(column(12,plotlyOutput("transit_ms_race_chart_today"))),
                                                 tags$div(class="chart_source","Source: PUMS 5yr Data for King, Kitsap, Pierce and Snohomish counties"),
                                                 hr(),
                                                 
                                                 h1("Transit Mode Share to Work by City"),
                                                 br(),
                                                 selectInput("Transit_MS_Year","Select Year:",list("Year" = transit_years), selected = "2021"),
                                                 br(),
                                                 strong(tags$div(class="chart_title","Transit Mode Share to Work by City")),
                                                 fluidRow(column(12,plotlyOutput("transit_ms_city_chart", height = "800px"))),
                                                 tags$div(class="chart_source","Source: ACS 5yr Data Table B08006 by Place in King, Kitsap, Pierce and Snohomish counties"),
                                                 hr(),
                                                 
                                                 h1("Transit Mode Share to Work by Metropolitan Region"),
                                                 br(),
                                                 selectInput("Transit_MPO_MS_Year","Select Latest Year:",list("Year" = transit_years), selected = "2021"),
                                                 br(),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title",textOutput("transit_ms_mpo_pre_text")))),
                                                          column(6,strong(tags$div(class="chart_title",textOutput("transit_ms_mpo_today_text"))))),
                                                 fluidRow(column(6,plotlyOutput("transit_ms_mpo_chart_pre")),
                                                          column(6,plotlyOutput("transit_ms_mpo_chart_today"))),
                                                 tags$div(class="chart_source","Source: ACS 5yr Data Table B08006 by Counties in Metro Regions"),
                                                 hr(),
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Revenue-Hours
                        
             ),# End of Nav Bar Menu for Transit
    
    tags$footer(footer_ui('psrcfooter'))
    
             ) # End of NavBar Page
  ) # End of Shiny App
