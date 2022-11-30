shinyUI(
  navbarPage(title=tags$a("Puget Sound Regional Council", href="https://www.psrc.org", class = "source_url", target="_blank"),
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
                                      tags$div(class="sidebar_notes","Kelly McGourty:"),
                                      tags$div(class="sidebar_notes","Director of Transportation Planning"),
                                      br(),
                                      icon("envelope"), 
                                      tags$a(class = "source_url", href="mailto:kmcgourty@psrc.org?", "Email"),
                                      br(), br(),
                                      icon("phone-volume"), "206-971-3601",
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
                                                 fluidRow(column(12,plotOutput("chart_population_growth"))),
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
                                                 hr()
                                                 
                                                 
                                          )) # End of Main Panel Fluid Row for Population Tab
                                 ), # End of Tab Panel for Population
                        ),# End of Nav Bar Menu for People, Housing and Jobs
             ) # End of NavBar Page
  ) # End of Shiny App
