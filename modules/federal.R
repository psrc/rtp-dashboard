federal_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Federal Transportation Performance Management"),
    
    #tags$div(class="page_goals", "Goal: 95% below 1990 GHG Emissions by 2050"),
    htmlOutput(ns("federal_overview")),
    br(), br(),
    
    h2("Congestion and Freight"),
    uiOutput(ns("phed_region")),

    h3("Peak Hours of Excessive Delay (PHED)"),
    br(),
    value_box_ui(ns("PHEDvaluebox")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("PHEDChoice"), label = NULL, choices = c("Annual Hours of Peak Hour Excessive Delay per Capita"), inline = TRUE)
      ),

      plotlyOutput(ns("PHEDchart")),
      tags$div(class = "chart_source", "Source: NPMRDS")
    ),
    
    h3("Interstate Level of Travel Time Reliability (LOTTR)"),
    br(),
    value_box_ui(ns("INTERSTATEvaluebox")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("INTERSTATEChoice"), label = NULL, choices = c("Interstate Level of Travel Time Reliability"), inline = TRUE)
      ),
      
      plotlyOutput(ns("INTERSTATEchart")),
      tags$div(class = "chart_source", "Source: NPMRDS")
    ),
    
    h3("Non-Interstate NHS Level of Travel Time Reliability (LOTTR)"),
    br(),
    value_box_ui(ns("NONINTERSTATEvaluebox")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("NONINTERSTATEChoice"), label = NULL, choices = c("Non-Interstate NHS Level of Travel Time Reliability"), inline = TRUE)
      ),
      
      plotlyOutput(ns("NONINTERSTATEchart")),
      tags$div(class = "chart_source", "Source: NPMRDS")
    ),

    h3("Truck Travel Time Reliability (TTTR)"),
    br(),
    value_box_ui(ns("TRUCKvaluebox")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRUCKChoice"), label = NULL, choices = c("Truck Travel Time Reliability"), inline = TRUE)
      ),
      
      plotlyOutput(ns("TRUCKchart")),
      tags$div(class = "chart_source", "Source: NPMRDS")
    ),
    
  )
}

federal_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$federal_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Federal", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # PHED
    output$phed_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Federal", 
                            page_section = "PHED", 
                            page_info = "description"))
    })
    
    value_box_server('PHEDvaluebox', df = phed_box_values)
    
    filtered_phed <- reactive({
      req(input$PHEDChoice)
      
      phed_region_data |>
        filter(c == input$PHEDChoice)
    })
    
    output$PHEDchart <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_phed(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "dodge",
                                     nt = 1)})
    
    value_box_server('INTERSTATEvaluebox', df = interstate_box_values)
    
    filtered_interstate <- reactive({
      req(input$INTERSTATEChoice)
      
      interstate_region_data |>
        filter(c == input$INTERSTATEChoice)
    })
    
    output$INTERSTATEchart <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_interstate(),
                                     colors = c("#8CC63E"),
                                     pos = "dodge",
                                     nt = 1)})
    
    value_box_server('NONINTERSTATEvaluebox', df = non_interstate_box_values)
    
    filtered_non_interstate <- reactive({
      req(input$NONINTERSTATEChoice)
      
      non_interstate_region_data |>
        filter(c == input$NONINTERSTATEChoice)
    })
    
    output$NONINTERSTATEchart <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_non_interstate(),
                                     colors = c("#00A7A0"),
                                     pos = "dodge",
                                     nt = 1)})
    
    value_box_server('TRUCKvaluebox', df = truck_box_values)
    
    filtered_truck <- reactive({
      req(input$TRUCKChoice)
      
      truck_region_data |>
        filter(c == input$TRUCKChoice)
    })
    
    output$TRUCKchart <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_truck(),
                                     colors = c("#F05A28"),
                                     pos = "dodge",
                                     nt = 1)})
    
    
    

  })
}
