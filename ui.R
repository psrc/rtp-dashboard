shinyUI(
  navbarPage(title = tags$a(div(tags$img(src='psrc-logo.png',
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
             #title=tags$a("Puget Sound Regional Council", href="https://www.psrc.org", class = "source_url", target="_blank"),
             windowTitle = "Alpha Testing of PSRC RTP Dashboard", 
             theme = "styles.css",
             position = "fixed-top",
             
             tabPanel("Overview",
                      fluidRow(column(4, style='padding-left:50px; padding-right:0px;',
                                      div(img(src="street-intersection.jpeg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:0 0 30px 0;", alt = "Street Intersection with housing building in the background"))),
                               column(8, style='padding-left:0px; padding-right:50px;',
                                      bs4Jumbotron(
                                        title = strong(tags$div(class="mainpage_title","RTP Performance Dashboard")),
                                        status = "success",
                                        btnName = strong(tags$div(class="mainpage_subtitle","Planning for 2050")),
                                        href = "https://www.psrc.org/planning-2050"))
                               ), # end of first row for main overview page
                      fluidRow(column(4, style='padding-left:75px; padding-right:0px;',
                                      hr(),
                                      strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                      br(),
                                      tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                      br(),br(),
                                      tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                      br(),br(),
                                      tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                      br(),br(),
                                      tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                      hr(),
                                      strong(tags$div(class="sidebar_heading","Connect With Us")),
                                      hr(),
                                      tags$div(class="sidebar_notes","Craig Helmann:"),
                                      tags$div(class="sidebar_notes","Director of Data"),
                                      br(),
                                      icon("envelope"), 
                                      tags$a(class = "source_url", href="mailto:chelmann@psrc.org?", "Email"),
                                      br(), br(),
                                      icon("phone-volume"), "206-389-2889",
                                      hr()),
                               column(8, style='padding-left:0px; padding-right:50px;',
                                      hr(),
                                      div(img(src="img-rtp-logo-trim.jpg", width = "50%", height = "50%", style = "padding-top: 0px")),
                                      "The Regional Transportation Plan (RTP) is the long-range transportation plan for the central Puget Sound region. 
                        The RTP is adopted every four years, and is designed to implement the region’s growth plan, ",
                                      tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050", "VISION 2050", target="_blank"), 
                                      ".The RTP meets all state and federal requirements and is based on the latest data, adopted land use assumptions, and technical tools. ",
                                      br(),br(),
                                      "The plan was developed over the last two years with extensive engagement with board members, technical committees, member jurisdictions, and the public. 
                        The plan implements the polices and goals in VISION 2050, outlining investments the region is making in transit, rail, ferry, streets and highways, freight, bicycle and pedestrian facilities, and other systems to ensure the safe and efficient movement of people and goods.",
                                      br(),br(),
                                      "On April 28, 2022, the PSRC Executive Board unanimously recommended adoption of the Regional Transportation Plan for action by the General Assembly. 
                        The General Assembly adopted the plan on May 26, 2022.",
                                      hr(),
                                      h2("RTP Performance Dashboard"),
                                      "The RTP Performance Dashboard is a resource to help the region understand how well it is meeting it's long range goals. At a minimum, the dashboard will be updated 
                        each fall as various Census and Transportation related metrics are released.
                        Metrics on the dashboard are focused on topic areas that were identified by the Transporation Policy Board as high priorities for the region and include:",br(),br(),
                               fluidRow(column(1, style='padding-left:0px; padding-right:5px;',
                                               icon("tree"), br(),br(),
                                               icon("users"), br(),br(),
                                               icon("child"), br(),br(), 
                                               icon("bicycle"), br(),br(), 
                                               icon("bus"), br(),br(), 
                                               icon("car"), br(),br(), 
                                               icon("wrench")),
                                      column(11, style='padding-left:5px; padding-right:50px;',
                                             "Climate",br(),br(),
                                             "People, Housing & Jobs",br(),br(),br(),
                                             "Safety",br(),br(),
                                             "Alternative Modes of Transportation", br(),br(),
                                             "Transit Performance and Access",br(),br(),
                                             "Travel Time and Congestion",br(),br(),br(),
                                             "Transportation Projects",
                                             hr())
                                      ) # end of second fluid row for main overview page
                               ), # end of second fluid row for main overview page
                      ) # end of second fluid row for main overview page
                      ), # end of tabpanel for Overview
             
             navbarMenu(icon("tree"), 
                        tabPanel("Overview",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Addressing Climate Change")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row for Fatal Collisions Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
                                                 div(img(src="climate-image.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Kelly McGourty:"),
                                                 tags$div(class="sidebar_notes","Director of Transportation Planning"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:kmcgourty@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3601",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","Goal: 80% below 1990 GHG Emissions by 2050"),
                                                 br(),
                                                 textOutput("climate_text_1"),
                                                 br(),
                                                 textOutput("climate_text_2"),
                                                 br(),
                                                 textOutput("climate_text_3"),
                                                 br(), 
                                                 textOutput("climate_text_4"),
                                                 br(), 
                                                 div(img(src="ghg-2050-emissions.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:0px 0 0px 0;", alt = "Bar chart of Greenhouse Gas Emissions in 2050")),
                                                 br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Climate Tab
                        ), # End of Tab Panel for Climate Overview
                        
                        tabPanel("Zero Emission Vehicles",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Zero Emission Vehicle Registrations")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row for Fatal Collisions Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
                                                 div(img(src="climate-image.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Kelly McGourty:"),
                                                 tags$div(class="sidebar_notes","Director of Transportation Planning"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:kmcgourty@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3601",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 h1("New Vehicle Registrations in the PSRC Region"),
                                                 textOutput("regional_ev_text"),
                                                 fluidRow(column(12,plotlyOutput("ev_share_new_registrations_chart"))),
                                                 hr(),
                                                 h1("New Vehicle Registrations by Zipcode"),
                                                 textOutput("zipcode_ev_text"),
                                                 fluidRow(column(12,leafletOutput("ev_zipcode_map"))),
                                                 br(), br(),
                                                 br(), br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Climate Tab
                        ), # End of Tab Panel for Climate ZEV
                        
                        tabPanel("Vehicle Miles Traveled",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Vehicle Miles Traveled")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row for Fatal Collisions Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
                                                 div(img(src="climate-image.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Kris Overby:"),
                                                 tags$div(class="sidebar_notes","Senior Modeler"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:koverby@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-464-6661",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","RTP Outcome: 25% Reduction in VMT per Capita by 2050"),
                                                 br(),
                                                 h1("Regional Vehicle Miles Traveled"),
                                                 textOutput("regional_vmt_text"),
                                                 fluidRow(column(6,plotlyOutput("chart_total_vmt")),
                                                          column(6,plotlyOutput("chart_per_capita_vmt"))),
                                                 br(), 
                                                 h1("Vehicle Miles Traveled by County"),
                                                 textOutput("county_vmt_text"),
                                                 br(),
                                                 fluidRow(column(12,plotOutput("chart_total_vmt_county"))),
                                                 br(), 
                                                 h1("Vehicle Kilometers Traveled Comparison"),
                                                 textOutput("vkt_text"),
                                                 br(),
                                                 fluidRow(column(12,plotlyOutput("chart_vkt_per_capita"))),
                                                 br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Climate Tab
                        ), # End of Tab Panel for Climate VMT
                        
             ),# End of Nav Bar Menu for Climate
             
             navbarMenu(icon("users"), 
                        tabPanel("Population",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Population Growth")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","VISION 2050")),
                                                   href = "https://www.psrc.org/planning-2050/vision-2050"))
                                 ), # End of First Fluid Row for Population Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","VISION 2050")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050/data-and-research", "Data and Research", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050/environmental-review", "Environmental Review", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision/vision-2050-planning-resources", "Planning Resources", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision/vision-2050-awards", "VISION 2050 Awards", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050/youth-engagement-psrc", "Youth Engagement at PSRC", target="_blank"),
                                                 hr(),
                                                 div(img(src="img-v2050-building.jpg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Paul Inghram, FAICP:"),
                                                 tags$div(class="sidebar_notes","Director of Growth Management Planning"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:pinghram@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-464-7549",
                                                 hr()
                                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 "Over the next 30 years, the central Puget Sound region will add another million and a half people, reaching a population of 5.8 million. 
                                                 How can we ensure that all residents benefit from the region’s thriving communities, strong economy and healthy environment as population grows? 
                                                 Local counties, cities, Tribes and other partners have worked together with PSRC to develop",
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050", " VISION 2050.", target="_blank"),
                                                 h1("Regional Population Growth"),
                                                 textOutput("population_vision_text"),
                                                 hr(),
                                                 fluidRow(column(12,plotlyOutput("chart_population_growth"))),
                                                 hr(),
                                                 h1("Growth Near High Capacity Transit"),
                                                 "The Regional Growth Strategy defines roles for different types of places in accommodating the region's population and employment growth, 
                                                 which inform countywide growth targets, local plans and regional plans. 
                                                 The Regional Growth Strategy assumes 65% of the region's population growth and 75% of the region's job growth will locate in regional growth centers and near high-capacity transit. 
                                                 The VISION 2050 Supplemental EIS studies the environmental outcomes of the Regional Growth Strategy. 
                                                 Learn more about ",
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/5102", "guidance to implement the Regional Growth Strategy (PDF).", target="_blank"),
                                                 br(), br(),
                                                 br(), br(),
                                                 fluidRow(column(12,plotlyOutput("chart_population_growth_hct"))),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Population Tab
                                 ), # End of Tab Panel for Population
                        tabPanel("Employment",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Employment Growth")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Economic Strategy")),
                                                   href = "https://www.psrc.org/planning-2050/regional-economic-strategy"))
                                 ), # End of First Fluid Row for Employment Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Employment Growth")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-economic-strategy", "Regional Economic Strategy", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/our-work/covered-employment-estimates", "Covered Employment Estimates", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/our-work/regional-macroeconomic-forecast", "Regional Macroeconomic Forecast", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/our-work/industrial-lands", "Industrial Lands", target="_blank"),
                                                 br(),br(),
                                                 hr(),
                                                 div(img(src="res.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Equity Strategy Document")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Grant Gibson:"),
                                                 tags$div(class="sidebar_notes","Associate Planner, Data"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:ggibson@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3272",
                                                 hr()
                                 ),
                                 column(8, style='padding-left:0px; padding-right:50px;',
                                        textOutput("employment_overview_text"),
                                        tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050", " VISION 2050.", target="_blank"),
                                        h1("Regional Employment Growth"),
                                        textOutput("jobs_vision_text"),
                                        hr(),
                                        fluidRow(column(12,plotlyOutput("chart_employment_growth"))),
                                        hr(),
                                        h1("Growth Near High Capacity Transit"),
                                        "The Regional Growth Strategy defines roles for different types of places in accommodating the region's population and employment growth, 
                                                 which inform countywide growth targets, local plans and regional plans. 
                                                 The Regional Growth Strategy assumes 65% of the region's population growth and 75% of the region's job growth will locate in regional growth centers and near high-capacity transit. 
                                                 The VISION 2050 Supplemental EIS studies the environmental outcomes of the Regional Growth Strategy. 
                                                 Learn more about ",
                                        tags$a(class = "source_url", href="https://www.psrc.org/media/5102", "guidance to implement the Regional Growth Strategy (PDF).", target="_blank"),
                                        br(), br(),
                                        br(), br(),
                                        fluidRow(column(12,plotlyOutput("chart_employment_growth_hct"))),
                                        hr()
                                        
                                        
                                 )) # End of Main Panel Fluid Row for Employment Tab
                        ), # End of Tab Panel for Employment
                        ),# End of Nav Bar Menu for People, Housing and Jobs
             
             navbarMenu(icon("child"), 
                        
                        tabPanel("Overview",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Addressing Safety: Target Zero")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row for Fatal Collisions Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
                                                 div(img(src="climate-image.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gary Simonson:"),
                                                 tags$div(class="sidebar_notes","Senior Planner"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gsimonson@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3276",
                                                 hr()                                 ),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","Goal: Zero Fatal and Serious Injuries by 2030"),
                                                 br(),
                                                 textOutput("safety_text_1"),
                                                 br(),
                                                 textOutput("safety_text_2"),
                                                 br(),
                                                 textOutput("safety_text_3"),
                                                 br(), 
                                                 textOutput("safety_text_4"),
                                                 br(), 
                                                 textOutput("safety_text_5"),
                                                 br(), 
                                                 div(img(src="04_PR-Winter2022_Feature_SSA-Overview2.jpg", width = "50%", height = "50%", style = "padding-top: 0px; border-radius:0px 0 0px 0;", alt = "Bar chart of Greenhouse Gas Emissions in 2050")),
                                                 br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Safety Tab
                        ), # End of Tab Panel for Safety Overview
                        
                        tabPanel("Fatal Collisions",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Fatal Collisions")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row for Fatal Collisions Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
                                                 div(img(src="canyon_road.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Gary Simonson:"),
                                                 tags$div(class="sidebar_notes","Senior Planner"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:gsimonson@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-971-3276",
                                                 hr()                                 ),
                                 column(8, style='padding-left:0px; padding-right:50px;',
                                        tags$div(class="page_goals","Goal: Zero Fatal Injuries by 2030"),
                                        br(),
                                        h1("Fatal Collisions in the PSRC Region"),
                                        textOutput("safety_text"),
                                        br(),
                                        textOutput("region_fatal_text"),
                                        hr(),
                                        fluidRow(column(12,plotlyOutput("fatal_collisions_chart"))),
                                        hr(),
                                        h1("Fatal Collisions by County in the PSRC Region"),
                                        textOutput("fatal_county_text"),
                                        br(),
                                        fluidRow(column(12,plotOutput("county_fatal_collisions_chart"))),
                                        hr(),
                                        h1("Fatal Collisions by Metropolitan Region"),
                                        textOutput("fatal_mpo_text"),
                                        br(),
                                        fluidRow(column(6,plotlyOutput("mpo_fatal_rate_min_yr_chart")),
                                                 column(6,plotlyOutput("mpo_fatal_rate_max_yr_chart"))),
                                        br(), br(),
                                        br(), br(),
                                        hr()
                                        
                                        
                                 )) # End of Main Panel Fluid Row for Fatal Collisions Tab
                        ), # End of Tab Panel for Safety
             ),# End of Nav Bar Menu for Safety
             
             navbarMenu(icon("bus"), 
                        
                        tabPanel("Overview",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Transit Performance")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
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
                        
                        tabPanel("Transit Boardings",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Annual Transit Boardings")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
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
                                                 br(),
                                                 h1("Annual Transit Boardings in the PSRC Region"),
                                                 hr(),
                                                 fluidRow(column(12,plotlyOutput("chart_transit_boardings"))),
                                                 hr(),
                                                 h1("Transit Boardings by Mode"),
                                                 br(),
                                                 fluidRow(column(12,plotOutput("chart_boardings_mode"))),
                                                 hr(),
                                                 h1("Transit Boardings by Metropolitan Region"),
                                                 br(),
                                                 fluidRow(column(6,plotlyOutput("mpo_boardings_precovid_chart")),
                                                          column(6,plotlyOutput("mpo_boardings_today_chart"))),
                                                 br(), br(),
                                                 br(), br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Boardings
                        
                        tabPanel("Transit Revenue-Hours",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Annual Transit Revenue-Hours")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","Regional Transportation Plan")),
                                                   href = "https://www.psrc.org/planning-2050/regional-transportation-plan"))
                                 ), # End of First Fluid Row Transit Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Regional Transportation Plan")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/projects-and-approval", "Projects and Approval", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/coordinated-mobility-plan", "Coordinated Mobility Plan", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/data-research-and-policy-briefs", "Data, Research and Policy Briefs", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/regional-transportation-plan/transportation-system-visualization-tool", "Transportation System Visualization Tool", target="_blank"),
                                                 hr(),
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
                                                 tags$div(class="page_goals","RTP Input: 66% More Revenue-Hours by 2050"),
                                                 br(),
                                                 h1("Annual Transit Revenue-Hours in the PSRC Region"),
                                                 hr(),
                                                 fluidRow(column(12,plotlyOutput("chart_transit_hours"))),
                                                 hr(),
                                                 h1("Transit Revenue-Hours by Mode"),
                                                 br(),
                                                 fluidRow(column(12,plotOutput("chart_hours_mode"))),
                                                 hr(),
                                                 h1("Transit Revenue-Hours by Metropolitan Region"),
                                                 br(),
                                                 fluidRow(column(6,plotlyOutput("mpo_hours_precovid_chart")),
                                                          column(6,plotlyOutput("mpo_hours_today_chart"))),
                                                 br(), br(),
                                                 br(), br(),
                                                 hr()
                                                 
                                          )) # End of Main Panel Fluid Row for Transit Tab
                        ), # End of Tab Panel for Transit Revenue-Hours
                        
             ),# End of Nav Bar Menu for Transit
             
             ) # End of NavBar Page
  ) # End of Shiny App
