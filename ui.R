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
             
             navbarMenu("Climate", 
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
                                                 strong(tags$div(class="sidebar_heading","Climate Change Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundrev.org/", "Puget Sound Regional Electric Vehicle Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/sites/default/files/2022-03/electric-vehicle-guidance.pdf", "Electric Vehicle Infrastructure", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundclimate.org/", "Puget Sound Climate Preparedness Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://ecology.wa.gov/Air-Climate/Climate-Commitment-Act", "Climate Commitment Act", target="_blank"),
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
                                                 strong(tags$div(class="sidebar_heading","Climate Change Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundrev.org/", "Puget Sound Regional Electric Vehicle Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/sites/default/files/2022-03/electric-vehicle-guidance.pdf", "Electric Vehicle Infrastructure", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundclimate.org/", "Puget Sound Climate Preparedness Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://ecology.wa.gov/Air-Climate/Climate-Commitment-Act", "Climate Commitment Act", target="_blank"),
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
                                                 br(),
                                                 strong(tags$div(class="chart_title","Share of New Vehicle Registrations")),
                                                 fluidRow(column(12,plotlyOutput("ev_share_new_registrations_chart"))),
                                                 tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
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
                                                 strong(tags$div(class="sidebar_heading","Climate Change Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundrev.org/", "Puget Sound Regional Electric Vehicle Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/sites/default/files/2022-03/electric-vehicle-guidance.pdf", "Electric Vehicle Infrastructure", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://pugetsoundclimate.org/", "Puget Sound Climate Preparedness Collaborative", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://ecology.wa.gov/Air-Climate/Climate-Commitment-Act", "Climate Commitment Act", target="_blank"),
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
                                                 br(),
                                                 fluidRow(column(6,strong(tags$div(class="chart_title","Daily Regional Vehicle Miles Traveled"))),
                                                          column(6,strong(tags$div(class="chart_title","Daily Regional VMT per Capita")))),
                                                 fluidRow(column(6,plotlyOutput("chart_total_vmt")),
                                                          column(6,plotlyOutput("chart_per_capita_vmt"))),
                                                 fluidRow(column(6,tags$div(class="chart_source","WSDOT HPMS, SoundCast Model")),
                                                          column(6,tags$div(class="chart_source","WSDOT HPMS, OFM and SoundCast Model"))),
                                                 br(), 
                                                 h1("Vehicle Miles Traveled by County"),
                                                 textOutput("county_vmt_text"),
                                                 br(),
                                                 strong(tags$div(class="chart_title","Daily Vehicle Miles Traveled by County")),
                                                 fluidRow(column(12,plotOutput("chart_total_vmt_county"))),
                                                 tags$div(class="chart_source","Source: WSDOT HPMS"),
                                                 br(), 
                                                 h1("Vehicle Kilometers Traveled Comparison"),
                                                 textOutput("vkt_text"),
                                                 br(),
                                                 strong(tags$div(class="chart_title","Annual Vehicle Kilometers Traveled per Capita")),
                                                 fluidRow(column(12,plotlyOutput("chart_vkt_per_capita"))),
                                                 tags$div(class="chart_source","Source: WSDOT HPMS, SoundCast, "),
                                                 br(),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Climate Tab
                        ), # End of Tab Panel for Climate VMT
                        
             ),# End of Nav Bar Menu for Climate
             
             navbarMenu("Growth", 
                        
                        tabPanel("Overview",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Planning for Growth")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","VISION 2050")),
                                                   href = "https://www.psrc.org/planning-2050/vision-2050"))
                                 ), # End of First Fluid Row for Overview Tab
                                 
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
                                                 hr()),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","Goal: 65% Population / 75% Job Growth near HCT"),
                                                 br(),
                                                 textOutput("growth_text_1"),
                                                 br(),
                                                 h1("What is VISION 2050?"),
                                                 textOutput("growth_text_2"),
                                                 br(),
                                                 h1("Why is VISION 2050 important?"),
                                                 textOutput("growth_text_3"),
                                                 br(), 
                                                 h1("Regional Growth Strategy"),
                                                 "The Regional Growth Strategy defines roles for different types of places in accommodating the region's population and employment growth, 
                                                 which inform countywide growth targets, local plans and regional plans. 
                                                 The Regional Growth Strategy assumes 65% of the region's population growth and 75% of the region's job growth will locate in regional growth centers and near high-capacity transit. 
                                                 The VISION 2050 Supplemental EIS studies the environmental outcomes of the Regional Growth Strategy. 
                                                 Learn more about ",
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/5102", "guidance to implement the Regional Growth Strategy (PDF).", target="_blank"),
                                                 br(), 
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Overview Tab
                        ), # End of Tab Panel for Growth Overview
                        
                        
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
                                                 div(img(src="mtrainierparadisehikers.jpeg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Glass and steel building in the background")),
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
                                                 hr()),
                                          column(8, style='padding-left:0px; padding-right:50px;',
                                                 tags$div(class="page_goals","Goal: 65% of Population Growth Near HCT"),
                                                 br(),
                                                 h1("Regional Population Growth"),
                                                 textOutput("population_vision_text"),
                                                 hr(),
                                                 strong(tags$div(class="chart_title","Regional Population")),
                                                 fluidRow(column(12,plotlyOutput("chart_population_growth"))),
                                                 tags$div(class="chart_source","Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties"),
                                                 hr(),
                                                 h1("Growth Near High Capacity Transit"),
                                                 textOutput("population_hct_text"),
                                                 hr(),
                                                 strong(tags$div(class="chart_title","Population Growth Near High Capacity Transit")),
                                                 fluidRow(column(12,plotlyOutput("chart_population_growth_hct"))),
                                                 tags$div(class="chart_source","Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties"),
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Population Tab
                                 ), # End of Tab Panel for Population
                        
                        tabPanel("Housing",
                                 fluidRow(column(12, style='padding-left:50px; padding-right:50px;',
                                                 bs4Jumbotron(
                                                   title = strong(tags$div(class="mainpage_title","Housing Unit Growth")),
                                                   status = "success",
                                                   btnName = strong(tags$div(class="mainpage_subtitle","VISION 2050")),
                                                   href = "https://www.psrc.org/planning-2050/vision-2050"))
                                 ), # End of First Fluid Row for Housing Tab
                                 
                                 fluidRow(column(4, style='padding-left:50px; padding-right:50px;',
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Housing Resources")),
                                                 br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/3218", "Housing Affordability in the Central Puget Sound Region", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/media/2304", "Housing Element Guide", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/sites/default/files/2022-09/housing_incentives_and_tools_survey_report.pdf", "Housing Incentives and Tools Survey Report", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/267", "Housing Innovations Program (HIP)", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/node/2175", "Regional Housing Strategy", target="_blank"),
                                                 br(),br(),
                                                 tags$a(class = "source_url", href="https://www.psrc.org/sites/default/files/2022-03/v2050-paper-housing.pdf", "VISION 2050 Housing Background Paper", target="_blank"),
                                                 hr(),
                                                 div(img(src="redmond-housing_0.jpg", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:30px 0 30px 0;", alt = "Housing with Metro bus in foreground")),
                                                 hr(),
                                                 strong(tags$div(class="sidebar_heading","Connect With Us")),
                                                 hr(),
                                                 tags$div(class="sidebar_notes","Laura Benjamin, AICP:"),
                                                 tags$div(class="sidebar_notes","Principal Planner"),
                                                 br(),
                                                 icon("envelope"), 
                                                 tags$a(class = "source_url", href="mailto:lbenjamin@psrc.org?", "Email"),
                                                 br(), br(),
                                                 icon("phone-volume"), "206-464-7134",
                                                 hr()
                                 ),
                                 column(8, style='padding-left:0px; padding-right:50px;',
                                        tags$div(class="page_goals","VISION 2050 Outcome: 830,000 new Households by 2050"),
                                        br(),
                                        textOutput("housing_text_1"),
                                        br(),
                                        textOutput("housing_text_2"),
                                        h1("Regional Housing Units"),
                                        textOutput("housing_vision_text"),
                                        hr(),
                                        strong(tags$div(class="chart_title","Regional Housing Units")),
                                        fluidRow(column(12,plotlyOutput("chart_housing_growth"))),
                                        tags$div(class="chart_source","Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties"),
                                        hr(),
                                        h1("Growth Near High Capacity Transit"),
                                        textOutput("housing_hct_text"),
                                        hr(),
                                        strong(tags$div(class="chart_title","Housing Unit Growth near High Capacity Transit")),
                                        fluidRow(column(12,plotlyOutput("chart_housing_growth_hct"))),
                                        tags$div(class="chart_source","Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties"),
                                        hr()
                                        
                                        
                                 )) # End of Main Panel Fluid Row for Housing Units Tab
                        ), # End of Tab Panel for Housing Units
                        
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
                                        tags$div(class="page_goals","Goal: 75% of Employment Growth Near HCT"),
                                        br(),
                                        textOutput("employment_overview_text"),
                                        tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050", " VISION 2050.", target="_blank"),
                                        h1("Regional Employment Growth"),
                                        textOutput("jobs_vision_text"),
                                        hr(),
                                        strong(tags$div(class="chart_title","Regional Employment")),
                                        fluidRow(column(12,plotlyOutput("chart_employment_growth"))),
                                        tags$div(class="chart_source","Source: WA ESD for King, Kitsap, Pierce & Snohomish counties"),
                                        hr(),
                                        h1("Growth Near High Capacity Transit"),
                                        textOutput("employment_hct_text"),
                                        hr(),
                                        strong(tags$div(class="chart_title","Employment Growth near High Capacity Transit")),
                                        fluidRow(column(12,plotlyOutput("chart_employment_growth_hct"))),
                                        tags$div(class="chart_source","Source: WA ESD for King, Kitsap, Pierce & Snohomish counties"),
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
