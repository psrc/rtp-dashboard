congestion_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Managing Travel Time & Congestion"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: Limit Growth in Annual Delay per Household"),
    htmlOutput(ns("tt_overview")),
    br(), br(),
    
    h2("Roadway Congestion"),
    
    value_box_ui(ns("CONGESTIONregistrationvaluebox")),
    
    h3("Percentage of the NHS System with Heavy or Severe Congestion in the PSRC Region"),
    uiOutput(ns("tt_congestion_region")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("CongestionChoice"), label = NULL, choices = c("AM Peak", "Midday", "PM Peak"), inline = TRUE)
      ),

      layout_columns(
        col_widths = c(6,6),
        strong("Weekdays"),
        strong("Weekends")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("congestionWEEKDAY")),
        plotlyOutput(ns("congestionWEEKEND"))
      ),
      
      
      tags$div(class = "chart_source", "Source: National Performance Management Research Data Set (NPMRDS)")
    ),

    h3("Roadway Congestion by Facility"),

    uiOutput(ns("tt_congestion_facility")),
    br(),

    card(
      
      layout_columns(
        col_widths = c(6,6),
        strong("AM Peak Period (6am to 9am)"),
        strong("PM Peak Period (3pm to 6pm)")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        leafletOutput(ns("congestionAM")),
        leafletOutput(ns("congestionPM"))
      ),

    )
  )
}

congestion_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$tt_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="TravelTime", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    
    # Region
    output$tt_congestion_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="TravelTime", 
                            page_section = "CONGRegion", 
                            page_info = "description"))
    })
    
    value_box_server('CONGESTIONregistrationvaluebox', df = congestion_box_values)
    
    filtered_weekday <- reactive({
      req(input$CongestionChoice)

      congestion_region_weekday |>
        filter(c == input$CongestionChoice)
    })

    output$congestionWEEKDAY <- renderPlotly({
      psrc_column_chart_share_plotly_auto(filtered_weekday(), pos = "stack", colors = c("#91268F", "#F05A28"))})
    
    filtered_weekend <- reactive({
      req(input$CongestionChoice)
      
      congestion_region_weekend |>
        filter(c == input$CongestionChoice)
    })
    
    output$congestionWEEKEND <- renderPlotly({
      psrc_column_chart_share_plotly_auto(filtered_weekend(), pos = "stack", colors = c("#91268F", "#F05A28"))})
    
    # Congestion by Facility
    output$tt_congestion_facility <- renderUI({
      HTML(page_information(tbl=page_text,
                            page_name="TravelTime",
                            page_section = "CONGFacility",
                            page_info = "description"))
    })

    output$congestionAM <- renderLeaflet({create_roadway_map(congestion_lyr=congestion_am_map)})
    output$congestionPM <- renderLeaflet({create_roadway_map(congestion_lyr=congestion_pm_map)})
    
  })
}
