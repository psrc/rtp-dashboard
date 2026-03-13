boardings_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Regional Transit Network"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: Triple transit trips by 2050"),
    htmlOutput(ns("transit_overview")),
    br(), br(),
    
    h2("Transit Ridership"),
    
    value_box_ui(ns("TRANSITMETRICvaluebox")),

    h3("Public Transportation metrics in the PSRC Region"),
    uiOutput(ns("transit_metric_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITMetric"), label = NULL, choices = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"), inline = TRUE)
      ),
      
      plotlyOutput(ns("TRANSITlinechart")),
      tags$div(class = "chart_source", "Source: USDOT Federal Transit Administration (FTA) National Transit Database")
    ),

    h3("Public Transportation metrics by Transit Mode"),
    uiOutput(ns("transit_metric_mode")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITMode"), label = NULL, choices = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"), inline = TRUE)
      ),
      
      layout_columns(
        
        col_widths = c(4,4,4),
        plotlyOutput(ns("bus_chart")),
        plotlyOutput(ns("crt_chart")),
        plotlyOutput(ns("dmd_chart")),
        plotlyOutput(ns("frr_chart")),
        plotlyOutput(ns("rai_chart")),
        plotlyOutput(ns("van_chart"))
        
      ),
      
      tags$div(class = "chart_source", "Source: USDOT Federal Transit Administration (FTA) National Transit Database")
    ),

    h3("Public Transportation metrics by Metropolitan Region"),
    uiOutput(ns("transit_metric_metro")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITMetro"), label = NULL, choices = c("Boardings", "Revenue-Hours", "Boardings-per-Hour"), inline = TRUE)
      ),
      
      plotlyOutput(ns("transitMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: USDOT Federal Transit Administration (FTA) National Transit Database")
    ),
    
  )
}

boardings_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$transit_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Transit", 
                            page_section = "TRANSITOverview", 
                            page_info = "description"))
    })
    
    value_box_server('TRANSITMETRICvaluebox', df = transit_metric_box_values)
    
    output$transit_metric_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Transit", 
                            page_section = "TRANSITMETRICRegion", 
                            page_info = "description"))
    })
    
    filtered_boardings <- reactive({
      req(input$TRANSITMetric)
      
      transit_metric_region |>
        filter(c == input$TRANSITMetric)
    })
    
    output$TRANSITlinechart <- renderPlotly({
      psrc_line_chart_total_plotly(filtered_boardings())})
    
    output$transit_metric_mode <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Transit", 
                            page_section = "TRANSITMETRICMode", 
                            page_info = "description"))
      })
    
    bus_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Bus" & c == input$TRANSITMode)
    })
    
    commuter_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Commuter Rail" & c == input$TRANSITMode)
    })
    
    demand_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Demand Response" & c == input$TRANSITMode)
    })
    
    ferry_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Ferry" & c == input$TRANSITMode)
    })
    
    rail_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Rail" & c == input$TRANSITMode)
    })
    
    vanpool_df <- reactive({
      req(input$TRANSITMode)
      
      transit_metric_by_mode  |>
        filter(f == "Vanpool" & c == input$TRANSITMode)
    })
    
    output$bus_chart <- renderPlotly({psrc_column_chart_total_plotly(df = bus_df(), colors = c("#F05A28"))})
    output$crt_chart <- renderPlotly({psrc_column_chart_total_plotly(df = commuter_df(), colors = c("#00A7A0"))})
    output$dmd_chart <- renderPlotly({psrc_column_chart_total_plotly(df = demand_df(), colors = c("#8CC63E"))})
    output$frr_chart <- renderPlotly({psrc_column_chart_total_plotly(df = ferry_df(), colors = c("#91268F"))})
    output$rai_chart <- renderPlotly({psrc_column_chart_total_plotly(df = rail_df(), colors = c("#4C4C4C"))})
    output$van_chart <- renderPlotly({psrc_column_chart_total_plotly(df = vanpool_df(), colors = c("#9f3913"))})
    
    output$transit_metric_metro <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Transit",
                            page_section = "TRANSITMETRICMetro", 
                            page_info = "description"))
      })
    
    filtered_transit_metro <- reactive({
      req(input$TRANSITMetro)
      
      transit_metric_metro |>
        filter(c == input$TRANSITMetro)
    })
    
    output$transitMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_transit_metro(),
                                                                     colors = c("#8CC63E", "#91268F"))})

  })
}

