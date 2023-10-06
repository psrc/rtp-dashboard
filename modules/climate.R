# Climate Overview ----------------------------------------------------------------------------
climate_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climateoverview"))
  )
}

climate_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$climate_text_1 <- renderText({climate_overview_1})
    
    output$climate_text_2 <- renderText({climate_overview_2})
    
    output$climate_text_3 <- renderText({climate_overview_3})
    
    output$climate_text_4 <- renderText({climate_overview_4})
    
    output$climateoverview <- renderUI({
      tagList(
        # Climate Overview
        tags$div(class="page_goals","Goal: 80% below 1990 GHG Emissions by 2050"),
        br(),
        textOutput(ns("climate_text_1")),
        br(),
        textOutput(ns("climate_text_2")),
        br(),
        textOutput(ns("climate_text_3")),
        br(), 
        textOutput(ns("climate_text_4")),
        br(), 
        div(img(src="ghg-2050-emissions.png", width = "100%", height = "100%", style = "padding-top: 0px; border-radius:0px 0 0px 0;", alt = "Bar chart of Greenhouse Gas Emissions in 2050")),
        br()
      )
    })
  })  # end moduleServer
}

# Climate Tabs --------------------------------------------------------------------------------
climate_zev_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climatezev"))
  )
}

climate_zev_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$regional_ev_text <- renderText({ev_registration_caption})
    
    output$zipcode_ev_text <- renderText({ev_zipcode_caption})
    
    output$ev_share_new_registrations_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="New Vehicle Registrations" & geography=="Region") %>% mutate(date=as.character(date)),
                                                                                      y='share', x='date', fill='variable', pos = "stack",
                                                                                      est="percent", dec=0, color='pgnobgy_5') %>% plotly::layout(showlegend=FALSE)})
    
    output$ev_zipcode_map <- renderLeaflet({create_share_map(lyr=ev_zipcodes, title="ZEV Share")})
    
    # Tab layout
    output$climatezev <- renderUI({
      tagList(
        # Zero Emission Vehicles
        h1("New Vehicle Registrations in the PSRC Region"),
        textOutput(ns("regional_ev_text")),
        br(),
        strong(tags$div(class="chart_title","Share of New Vehicle Registrations")),
        fluidRow(column(12,plotlyOutput(ns("ev_share_new_registrations_chart")))),
        tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        h1("New Vehicle Registrations by Zipcode"),
        textOutput(ns("zipcode_ev_text")),
        fluidRow(column(12,leafletOutput(ns("ev_zipcode_map")))),
        br(), br(),
        br(), br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

climate_vmt_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climatevmt"))
  )
}

climate_vmt_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$regional_vmt_text <- renderText({vmt_caption})
    
    output$county_vmt_text <- renderText({vmt_county_caption})
    
    output$vkt_text <- renderText({vkt_caption})
    
    output$chart_total_vmt <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & geography=="Region" & data_year>=2000), 
                                                                                          x='data_year', y='estimate', fill='metric', est="number",
                                                                                          lwidth = 2,
                                                                                          breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                          color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(40000000,120000000), labels=scales::label_comma()))})
    
    output$chart_per_capita_vmt <- renderPlotly({psrcplot:::make_interactive(static_line_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="per Capita" & geography=="Region" & data_year>=2000), 
                                                                                               x='data_year', y='estimate', fill='metric', est="number",
                                                                                               lwidth = 2, dec=1,
                                                                                               breaks = c("2000","2010","2020","2030","2040","2050"),
                                                                                               color = "pgnobgy_5") + ggplot2::scale_y_continuous(limits=c(10,30), labels=scales::label_comma()))})
    
    output$chart_total_vmt_county <- renderPlot({static_facet_column_chart(t=data %>% filter(grouping=="Vehicle Miles Traveled" & variable=="Total" & metric=="Observed VMT" & geography!="Region" & data_year>as.character(current_vmt_year-5)), 
                                                                           x="data_year", y="estimate", 
                                                                           fill="data_year", facet="geography", 
                                                                           est = "number",
                                                                           color = "pgnobgy_10",
                                                                           ncol=2, scales="free")})
    
    output$chart_vkt_per_capita <- renderPlotly({interactive_bar_chart(t=vkt_data,
                                                                       y='geography', x='vkt', fill='plot_id',
                                                                       est="number", dec=0, color='pgnobgy_10') %>% layout(showlegend = FALSE)})
    
    # Tab layout
    output$climatezev <- renderUI({
      tagList(
        # Vehicle Miles Traveled
        tags$div(class="page_goals","RTP Outcome: 25% Reduction in VMT per Capita by 2050"),
        br(),
        h1("Regional Vehicle Miles Traveled"),
        textOutput(ns("regional_vmt_text")),
        br(),
        fluidRow(column(6,strong(tags$div(class="chart_title","Daily Regional Vehicle Miles Traveled"))),
                 column(6,strong(tags$div(class="chart_title","Daily Regional VMT per Capita")))),
        fluidRow(column(6,plotlyOutput(ns("chart_total_vmt"))),
                 column(6,plotlyOutput(ns("chart_per_capita_vmt")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: WSDOT HPMS, SoundCast Model")),
                 column(6,tags$div(class="chart_source","Source: WSDOT HPMS, OFM and SoundCast Model"))),
        br(),
        hr(style = "border-top: 1px solid #000000;"),
        h1("Vehicle Miles Traveled by County"),
        textOutput(ns("county_vmt_text")),
        br(),
        strong(tags$div(class="chart_title","Daily Vehicle Miles Traveled by County")),
        fluidRow(column(12,plotOutput(ns("chart_total_vmt_county")))),
        tags$div(class="chart_source","Source: WSDOT HPMS"),
        br(),
        hr(style = "border-top: 1px solid #000000;"),
        h1("Vehicle Kilometers Traveled Comparison"),
        textOutput(ns("vkt_text")),
        br(),
        strong(tags$div(class="chart_title","Annual Vehicle Kilometers Traveled per Capita")),
        fluidRow(column(12,plotlyOutput(ns("chart_vkt_per_capita")))),
        tags$div(class="chart_source","Source: WSDOT HPMS, SoundCast, "),
        br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}
