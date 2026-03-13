vmt_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Addressing Climate Change"),
    
    tags$div(class="page_goals", "Goal: 95% below 1990 GHG Emissions by 2050"),
    htmlOutput(ns("climate_overview")),
    br(), br(),
    
    h2("Vehicle Miles Traveled"),
    
    value_box_ui(ns('VMTvaluebox')),
    
    h3("Daily Vehicle Miles Traveled in the PSRC Region"),
    uiOutput(ns("climate_vmt_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("VMTChoice"), label = NULL, choices = c("Total", "per Capita"), inline = TRUE)
      ),
      
      plotlyOutput(ns("VMTlinechart")),
      tags$div(class = "chart_source", "Source: Washington State Department of Transportation HPMS and SoundCast Model")
    ),

    h3("Daily Vehicle Miles Traveled by County"),
    uiOutput(ns("climate_vmt_county")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("VMTcounty"), label = NULL, choices = c("Total", "per Capita"), inline = TRUE)
      ),
      
      layout_columns(
        
        col_widths = c(6,6),
        plotlyOutput(ns("kingVMT")),
        plotlyOutput(ns("kitsapVMT")),
        plotlyOutput(ns("pierceVMT")),
        plotlyOutput(ns("snohomishVMT"))
        
      ),
      
      tags$div(class = "chart_source", "Source: Washington State Department of Transportation Highway Performance Monitoring System")
      
    ),
  
    h3("Vehicle Kilometers Traveled Comparison"),
    uiOutput(ns("climate_vkt_compare")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("VKTyear"), label = NULL, choices = c(2024), inline = TRUE)
      ),
      
      plotlyOutput(ns("vktCOMPARE"), height = "600px"),
      tags$div(class = "chart_source", "Source: Washington State Department of Transportation Highway Performance Monitoring System, SoundCast")
    )
  )
}

vmt_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Climate Overview
    output$climate_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Climate", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # VMT by region
    output$climate_vmt_region <- renderUI({HTML(page_information(tbl=page_text, 
                                                                 page_name="Climate", 
                                                                 page_section = "VMTRegion", 
                                                                 page_info = "description"))})
    
    value_box_server('VMTvaluebox', df = vmt_box_values)
    
    filtered_vmt <- reactive({
      req(input$VMTChoice)
      
      vmt_region_data |>
        filter(c == input$VMTChoice)
    })
    
    output$VMTlinechart <- renderPlotly({
      psrc_line_chart_total_plotly(filtered_vmt())})
    
    # VMT by County
    output$climate_vmt_county <- renderUI({HTML(page_information(tbl=page_text, 
                                                                 page_name="Climate", 
                                                                 page_section = "VMTCounty", 
                                                                 page_info = "description"))})
    
    king_df <- reactive({
      req(input$VMTcounty)
      
      vmt_county_data[[1]]  |>
        filter(c == input$VMTcounty)
    })
    
    kitsap_df <- reactive({
      req(input$VMTcounty)
      
      vmt_county_data[[2]]  |>
        filter(c == input$VMTcounty)
    })
    
    pierce_df <- reactive({
      req(input$VMTcounty)
      
      vmt_county_data[[3]]  |>
        filter(c == input$VMTcounty)
    })
    
    snohomish_df <- reactive({
      req(input$VMTcounty)
      
      vmt_county_data[[4]]  |>
        filter(c == input$VMTcounty)
    })

    output$kingVMT <- renderPlotly({
      psrc_column_chart_total_plotly(df = king_df(), 
                                     colors = c("#91268F"),
                                     nt = 2)})
    
    output$kitsapVMT <- renderPlotly({
      psrc_column_chart_total_plotly(df = kitsap_df(), 
                                     colors = c("#8CC63E"),
                                     nt = 2)})
    
    output$pierceVMT <- renderPlotly({
      psrc_column_chart_total_plotly(df = pierce_df(), 
                                     colors = c("#F05A28"),
                                     nt = 2)})
    
    output$snohomishVMT <- renderPlotly({
      psrc_column_chart_total_plotly(df = snohomish_df(), 
                                     colors = c("#00A7A0"),
                                     nt = 2)})
    
    # VKT Comparison
    output$climate_vkt_compare <- renderUI({HTML(page_information(tbl=page_text, 
                                                                  page_name="Climate", 
                                                                  page_section = "VKTCompare", 
                                                                  page_info = "description"))})
    
    filtered_vkt <- reactive({
      req(input$VKTyear)
      
      vkt_data |>
        filter(c == input$VKTyear)
    })
    
    output$vktCOMPARE <- renderPlotly({psrc_bar_chart_total_plotly(df = filtered_vkt(), 
                                                                   colors = c("#8CC63E", "#F05A28", "#00A7A0","#999999", "#91268F"))})
  })
}
