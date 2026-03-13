safety_other_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Adressing Safety via the Safe System Approach"),
    
    tags$div(class="page_goals", "Goal: Zero Fatal and Serious Injuries by 2030"),
    htmlOutput(ns("safety_overview")),
    br(), br(),
    
    h2("Other Summarization of Safety Trends"),
    
    value_box_ui(ns('SAFETYvaluebox')),
    
    h3("Annual Deaths and Serious Injuries by Mode"),
    uiOutput(ns("safety_other_mode")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYMODEChoice"), label = NULL, choices = c("Total"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("modeDEATHS")),
        plotlyOutput(ns("modeSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by Time of Day"),
    uiOutput(ns("safety_other_tod")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYTODChoice"), label = NULL, choices = c("Total"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("todDEATHS")),
        plotlyOutput(ns("todSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by Day of Week"),
    uiOutput(ns("safety_other_dow")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYDOWChoice"), label = NULL, choices = c("Total"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("dowDEATHS")),
        plotlyOutput(ns("dowSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    )
  )
}

safety_other_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$safety_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Safety", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    value_box_server('SAFETYvaluebox', df = safety_mode_box_values)
    
    # By mode
    output$safety_other_mode <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="Safety", 
                                                                page_section = "SAFETYMode", 
                                                                page_info = "description"))})
    
    filtered_mode_deaths <- reactive({
      req(input$SAFETYMODEChoice)
      
      deaths_mode_data |>
        filter(c == input$SAFETYMODEChoice)
    })
    
    output$modeDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_mode_deaths(),
                                     colors = c("#8CC63E","#00A7A0", "#F05A28"),
                                     pos = "stack",
                                     nt = 2)})
    
    filtered_mode_serious <- reactive({
      req(input$SAFETYMODEChoice)
      
      serious_mode_data |>
        filter(c == input$SAFETYMODEChoice)
    })
    
    output$modeSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_mode_serious(),
                                     colors = c("#8CC63E","#00A7A0", "#F05A28"),
                                     pos = "stack",
                                     nt = 2)})
    
    #By Time of Day
    output$safety_other_tod <- renderUI({HTML(page_information(tbl=page_text,
                                                               page_name="Safety",
                                                               page_section = "SAFETYTod",
                                                               page_info = "description"))})
    
    filtered_tod_deaths <- reactive({
      req(input$SAFETYTODChoice)
      
      deaths_tod_data |>
        filter(c == input$SAFETYTODChoice)
    })
    
    output$todDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_tod_deaths(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
    filtered_tod_serious <- reactive({
      req(input$SAFETYTODChoice)
      
      serious_tod_data |>
        filter(c == input$SAFETYTODChoice)
    })
    
    output$todSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_tod_serious(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
    #By Day of Week
    output$safety_other_dow <- renderUI({HTML(page_information(tbl=page_text,
                                                               page_name="Safety",
                                                               page_section = "SAFETYDow",
                                                               page_info = "description"))})
    
    filtered_dow_deaths <- reactive({
      req(input$SAFETYDOWChoice)
      
      deaths_dow_data |>
        filter(c == input$SAFETYDOWChoice)
    })
    
    output$dowDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_dow_deaths(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
    filtered_dow_serious <- reactive({
      req(input$SAFETYDOWChoice)
      
      serious_dow_data |>
        filter(c == input$SAFETYDOWChoice)
    })
    
    output$dowSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_dow_serious(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
  })
}
