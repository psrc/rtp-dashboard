growth_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Regional Growth Strategy"),
    
    tags$div(class="page_goals", "Goal: 65% Population / 75% Job Growth near HCT"),
    htmlOutput(ns("growth_overview")),
    br(), br(),
    
    h2("Regional Growth"),

    value_box_ui(ns("REGIONgrowthvaluebox")),
    
    h3("Population, Housing and Job Growth in the PSRC Region"),
    uiOutput(ns("growth_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("GROWTHRegion"), label = NULL, choices = c("Population", "Housing Units", "Jobs"), inline = TRUE)
      ),
      
      plotlyOutput(ns("GROWTHREGIONlinechart")),
      tags$div(class = "chart_source", "Source: OFM April 1 Official Estimates for King, Kitsap, Pierce & Snohomish counties and PSRC QCEW Employment Data")
    ),
    
    h3("Population, Housing and Job Growth near High-Capacity Transit"),
    
    uiOutput(ns("growth_hct")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("GROWTHHct"), label = NULL, choices = c("Population near HCT", "Housing Units near HCT", "Jobs near HCT"), inline = TRUE)
      ),
      
      plotlyOutput(ns("GROWTHHCTlinechart")),
      tags$div(class = "chart_source", "Source: OFM Small Area Estimate Program for King, Kitsap, Pierce & Snohomish counties and PSRC QCEW Employment Data")
    )
    
  )
}

growth_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$growth_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Growth", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    value_box_server('REGIONgrowthvaluebox', df = growth_box_values)
    
    output$growth_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Growth", 
                            page_section = "GROWTHRegion", 
                            page_info = "description"))
    })
    
    filtered_region_growth <- reactive({
      req(input$GROWTHRegion)
      
      growth_region_data |>
        filter(c == input$GROWTHRegion)
    })
    
    output$GROWTHREGIONlinechart <- renderPlotly({
      psrc_line_chart_total_plotly(filtered_region_growth())})
    
    output$growth_hct <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Growth", 
                            page_section = "GROWTHHighCapacityTransit", 
                            page_info = "description"))
    })
    
    filtered_hct_growth <- reactive({
      req(input$GROWTHHct)
      
      growth_hct_data |>
        filter(c == input$GROWTHHct)
    })
    
    output$GROWTHHCTlinechart <- renderPlotly({
      psrc_line_chart_share_plotly(filtered_hct_growth())})
    

  })
}
