safety_geography_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Adressing Safety via the Safe System Approach"),
    
    tags$div(class="page_goals", "Goal: Zero Fatal and Serious Injuries by 2030"),
    htmlOutput(ns("safety_overview")),
    br(), br(),
    
    h2("Geographic Summarization of Safety Trends"),
    
    value_box_ui(ns('SAFETYvaluebox')),
    
    h3("Annual Deaths and Serious Injuries in the PSRC Region"),
    uiOutput(ns("safety_geography_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYREGIONChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("regionDEATHS")),
        plotlyOutput(ns("regionSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by Urban & Rural Areas"),
    uiOutput(ns("safety_geography_rural")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYRURALChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), selected = "Rate per 100k people", inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("ruralDEATHS")),
        plotlyOutput(ns("ruralSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by Historically Disadvantaged Community"),
    uiOutput(ns("safety_geography_hdc")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYHDCChoice"), label = NULL, choices = c("Total"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("hdcDEATHS")),
        plotlyOutput(ns("hdcSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by County"),
    uiOutput(ns("safety_geography_county")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYCOUNTYChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("King County"),
        strong("Kitsap County")
      ),

      layout_columns(

        col_widths = c(6,6),
        plotlyOutput(ns("kingSAFETY")),
        plotlyOutput(ns("kitsapSAFETY"))

      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Pierce County"),
        strong("Snohomish County")
      ),
      
      layout_columns(
        
        col_widths = c(6,6),
        plotlyOutput(ns("pierceSAFETY")),
        plotlyOutput(ns("snohomishSAFETY"))
        
      ),

      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")

    ),

    h3("Annual Deaths by Metropolitan Region"),
    uiOutput(ns("safety_geography_metro")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYMETROChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), inline = TRUE)
      ),

      plotlyOutput(ns("metroDEATHS"), height = "900px"),
      tags$div(class = "chart_source", "Source: NHTSA Fatality Analysis Reporting System (FARS) Data")
    )
  )
}

safety_geography_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$safety_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Safety", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    value_box_server('SAFETYvaluebox', df = safety_geography_box_values)
    
    # By region
    output$safety_geography_region <- renderUI({HTML(page_information(tbl=page_text, 
                                                                      page_name="Safety", 
                                                                      page_section = "SAFETYRegion", 
                                                                      page_info = "description"))})
    
    
    
    filtered_region_deaths <- reactive({
      req(input$SAFETYREGIONChoice)
      
      deaths_region_data |>
        filter(c == input$SAFETYREGIONChoice)
    })
    
    output$regionDEATHS <- renderPlotly({
      psrc_line_chart_total_plotly(filtered_region_deaths())})
    
    filtered_region_serious <- reactive({
      req(input$SAFETYREGIONChoice)
      
      serious_region_data |>
        filter(c == input$SAFETYREGIONChoice)
    })
    
    output$regionSERIOUS <- renderPlotly({
      psrc_line_chart_total_plotly(filtered_region_serious())})
    
    #By Rural
    output$safety_geography_rural <- renderUI({HTML(page_information(tbl=page_text,
                                                                     page_name="Safety",
                                                                     page_section = "SAFETYRural",
                                                                     page_info = "description"))})
    
    filtered_rural_deaths <- reactive({
      req(input$SAFETYRURALChoice)
      
      deaths_rural_data  |>
        filter(c == input$SAFETYRURALChoice)
    })
    
    output$ruralDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_rural_deaths(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "dodge",
                                     nt = 2)})
    
    filtered_rural_serious <- reactive({
      req(input$SAFETYRURALChoice)
      
      serious_rural_data  |>
        filter(c == input$SAFETYRURALChoice)
    })
    
    output$ruralSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_rural_serious(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "dodge",
                                     nt = 2)})
    
    #By HDC
    output$safety_geography_hdc <- renderUI({HTML(page_information(tbl=page_text,
                                                                   page_name="Safety",
                                                                   page_section = "SAFETYHDC",
                                                                   page_info = "description"))})
    
    filtered_hdc_deaths <- reactive({
      req(input$SAFETYHDCChoice)
      
      deaths_hdc_data  |>
        filter(c == input$SAFETYHDCChoice)
    })
    
    output$hdcDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_hdc_deaths(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
    filtered_hdc_serious <- reactive({
      req(input$SAFETYHDCChoice)
      
      serious_hdc_data  |>
        filter(c == input$SAFETYHDCChoice)
    })

    output$hdcSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_hdc_serious(),
                                     colors = c("#8CC63E","#00A7A0"),
                                     pos = "stack",
                                     nt = 2)})
    
    #By County
    output$safety_geography_county <- renderUI({HTML(page_information(tbl=page_text,
                                                                      page_name="Safety",
                                                                      page_section = "SAFETYCounty",
                                                                      page_info = "description"))})

    king_df <- reactive({
      req(input$SAFETYCOUNTYChoice)

      safety_county_data[[1]]  |>
        filter(c == input$SAFETYCOUNTYChoice)
    })

    kitsap_df <- reactive({
      req(input$SAFETYCOUNTYChoice)

      safety_county_data[[2]]  |>
        filter(c == input$SAFETYCOUNTYChoice)
    })

    pierce_df <- reactive({
      req(input$SAFETYCOUNTYChoice)

      safety_county_data[[3]]  |>
        filter(c == input$SAFETYCOUNTYChoice)
    })

    snohomish_df <- reactive({
      req(input$SAFETYCOUNTYChoice)

      safety_county_data[[4]]  |>
        filter(c == input$SAFETYCOUNTYChoice)
    })

    output$kingSAFETY <- renderPlotly({
      psrc_column_chart_total_plotly(df = king_df(),
                                     colors = c("#91268F","#F05A28"),
                                     pos = "stack")})

    output$kitsapSAFETY <- renderPlotly({
      psrc_column_chart_total_plotly(df = kitsap_df(),
                                     colors = c("#91268F","#F05A28"),
                                     pos = "stack")})

    output$pierceSAFETY <- renderPlotly({
      psrc_column_chart_total_plotly(df = pierce_df(),
                                     colors = c("#91268F","#F05A28"),
                                     pos = "stack")})

    output$snohomishSAFETY<- renderPlotly({
      psrc_column_chart_total_plotly(df = snohomish_df(),
                                     colors = c("#91268F","#F05A28"),
                                     pos = "stack")})

    # Metro Comparison
    output$safety_geography_metro <- renderUI({HTML(page_information(tbl=page_text,
                                                                     page_name="Safety",
                                                                     page_section = "SAFETYMetro",
                                                                     page_info = "description"))})

    filtered_metro_deaths <- reactive({
      req(input$SAFETYMETROChoice)

      deaths_mpo_data |>
        filter(c == input$SAFETYMETROChoice)
    })

    output$metroDEATHS <- renderPlotly({psrc_bar_chart_total_plotly(df = filtered_metro_deaths(),
                                                                    colors = c("#8CC63E", "#91268F"))})
  })
}
