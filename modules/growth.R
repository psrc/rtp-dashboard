# People, Housing, & Jobs Overview ------------------------------------------------------------
growth_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("growthoverview"))
  )
}

growth_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$growth_text_1 <- renderText({growth_overview_1})
    
    output$growth_text_2 <- renderText({growth_overview_2})
    
    output$growth_text_3 <- renderText({growth_overview_3})
    
    # Overview UI
    output$growthoverview <- renderUI({
      tagList(
        # Growth Overview
        tags$div(class="page_goals","Goal: 65% Population / 75% Job Growth near HCT"),
        br(),
        textOutput(ns("growth_text_1")),
        br(),
        h1("What is VISION 2050?"),
        textOutput(ns("growth_text_2")),
        br(),
        h1("Why is VISION 2050 important?"),
        textOutput(ns("growth_text_3")),
        br(), 
        h1("Regional Growth Strategy"),
        "The Regional Growth Strategy defines roles for different types of places in accommodating the region's population 
         and employment growth, which inform countywide growth targets, local plans and regional plans. The Regional Growth 
         Strategy assumes 65% of the region's population growth and 75% of the region's job growth will locate in regional 
         growth centers and near high-capacity transit. The VISION 2050 Supplemental EIS studies the environmental outcomes 
         of the Regional Growth Strategy. Learn more about ",
        tags$a(class = "source_url", href="https://www.psrc.org/media/5102", "guidance to implement the Regional Growth Strategy (PDF).", target="_blank"),
        br()
      )
    })
  })  # end moduleServer
}


# People, Housing, & Jobs Tabs ----------------------------------------------------------------------------------
population_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("populationtab"))
  )
}

population_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$population_vision_text <- renderText({pop_vision_caption})
    
    output$population_hct_text <- renderText({pop_hct_caption})
    
    output$chart_population_growth <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Population" & variable=="Total" & geography=="Region" & data_year>=base_year), 
                                                                           x='data_year', y='estimate', fill='metric', est="number",
                                                                           lwidth = 2,
                                                                           breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                           color = "pgnobgy_5")})
    
    
    output$chart_population_growth_hct <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Population"), 
                                                                                                      x='data_year', y='share', fill='geography', est="percent",
                                                                                                      lwidth = 2,
                                                                                                      breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                                                                                                      color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
    
    # Tab layout
    output$populationtab <- renderUI({
      tagList(
        tags$div(class="page_goals","Goal: 65% of Population Growth Near HCT"),
        br(),
        
        # Region
        h1("Regional Population Growth"),
        textOutput(ns("population_vision_text")),
        hr(),
        strong(tags$div(class="chart_title","Regional Population")),
        fluidRow(column(12,plotlyOutput(ns("chart_population_growth")))),
        tags$div(class="chart_source","Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # HCT
        h1("Growth Near High Capacity Transit"),
        textOutput(ns("population_hct_text")),
        hr(),
        strong(tags$div(class="chart_title","Population Growth Near High Capacity Transit")),
        fluidRow(column(12,plotlyOutput(ns("chart_population_growth_hct")))),
        tags$div(class="chart_source","Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

housing_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("housingtab"))
  )
}

housing_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$housing_text_1 <- renderText({housing_overview_1})
    
    output$housing_text_2 <- renderText({housing_overview_2})
    
    output$housing_vision_text <- renderText({housing_vision_caption})
    
    output$housing_hct_text <- renderText({housing_hct_caption})
    
    output$chart_housing_growth <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Total" & variable=="Total Housing Units" & geography=="Region" & data_year>=base_year), 
                                                                                               x='data_year', y='estimate', fill='metric', est="number",
                                                                                               lwidth = 2,
                                                                                               breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                               color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(1000000,3000000), labels=scales::label_comma()))})
    
    output$chart_housing_growth_hct <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Growth Near High Capacity Transit" & geography=="Inside HCT Area" & variable=="Change" & metric=="Housing Units"), 
                                                                                                   x='data_year', y='share', fill='geography', est="percent",
                                                                                                   lwidth = 2,
                                                                                                   breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"),
                                                                                                   color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
    
    # Tab layout
    output$housingtab <- renderUI({
      tagList(
        tags$div(class="page_goals","VISION 2050 Outcome: 830,000 new Households by 2050"),
        br(),
        textOutput(ns("housing_text_1")),
        br(),
        textOutput(ns("housing_text_2")),
        
        # Region
        h1("Regional Housing Units"),
        textOutput(ns("housing_vision_text")),
        hr(),
        strong(tags$div(class="chart_title","Regional Housing Units")),
        fluidRow(column(12,plotlyOutput(ns("chart_housing_growth")))),
        tags$div(class="chart_source","Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # HCT
        h1("Growth Near High Capacity Transit"),
        textOutput(ns("housing_hct_text")),
        hr(),
        strong(tags$div(class="chart_title","Housing Unit Growth near High Capacity Transit")),
        fluidRow(column(12,plotlyOutput(ns("chart_housing_growth_hct")))),
        tags$div(class="chart_source","Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

jobs_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("jobstab"))
  )
}

jobs_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$employment_overview_text <- renderText({employment_overview})
    
    output$employment_hct_text <- renderText({employment_hct_caption})
    
    output$jobs_vision_text <- renderText({jobs_vision_caption})
    
    output$chart_employment_growth <- renderPlotly({interactive_line_chart(t=data %>% filter(grouping=="Total Employment" & variable=="Total" & geography=="Region" & data_year>=base_year), 
                                                                           x='data_year', y='estimate', fill='metric', est="number",
                                                                           lwidth = 2,
                                                                           breaks = c("2010","2020","2030","2040","2050"),
                                                                           color = "pgnobgy_5")})  
    
    output$chart_employment_growth_hct <- renderPlotly({psrcplot:::make_interactive(p=static_line_chart(t=data %>% filter(metric=="Employment Growth Inside HCT Area" & variable=="Inside HCT Area"), 
                                                                                                        x='data_year', y='share', fill='metric', est="percent", 
                                                                                                        lwidth = 2,
                                                                                                        breaks = c("2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021"),
                                                                                                        color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(0,1), labels=scales::label_percent()))})
    
    # Tab layout
    output$jobstab <- renderUI({
      tagList(
        tags$div(class="page_goals","Goal: 75% of Employment Growth Near HCT"),
        br(),
        textOutput(ns("employment_overview_text")),
        tags$a(class = "source_url", href="https://www.psrc.org/planning-2050/vision-2050", " VISION 2050.", target="_blank"),
        
        # Region
        h1("Regional Employment Growth"),
        textOutput(ns("jobs_vision_text")),
        hr(),
        strong(tags$div(class="chart_title","Regional Employment")),
        fluidRow(column(12,plotlyOutput(ns("chart_employment_growth")))),
        tags$div(class="chart_source","Source: WA ESD for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # HCT
        h1("Growth Near High Capacity Transit"),
        textOutput(ns("employment_hct_text")),
        hr(),
        strong(tags$div(class="chart_title","Employment Growth near High Capacity Transit")),
        fluidRow(column(12,plotlyOutput(ns("chart_employment_growth_hct")))),
        tags$div(class="chart_source","Source: WA ESD for King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}
