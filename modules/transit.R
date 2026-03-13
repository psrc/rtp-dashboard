transit_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Regional Transit Network"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: Triple transit trips by 2050"),
    htmlOutput(ns("transit_overview")),
    br(), br(),
    
    h2("Transit Commute Mode to Work"),
    value_box_ui(ns('TRANSITMODEvaluebox')),
    
    h3("Transit shares by County"),
    uiOutput(ns("transit_mode_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITCounty"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("transitCOUNTY")),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Transit shares by Race & Ethnicity"),
    htmlOutput(ns("transit_mode_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITRace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("transitRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Transit shares by Metropolitan Region"),
    uiOutput(ns("transit_mode_metro")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("transitMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301")
    ),
    
    h3("Transit shares by City"),
    uiOutput(ns("transit_mode_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TRANSITCity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("transitCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    )
    
  )
}

transit_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$transit_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Transit", 
                            page_section = "TRANSITOverview", 
                            page_info = "description"))
    })
    
    value_box_server('TRANSITMODEvaluebox', df = transit_mode_box_values)
    
    output$transit_mode_region <- renderUI({HTML(page_information(tbl=page_text, 
                                                                  page_name="Transit",
                                                                  page_section = "TRANSITRegion", 
                                                                  page_info = "description"))})
    
    filtered_transit_county <- reactive({
      req(input$TRANSITCounty)
      
      transit_mode_county_data |>
        filter(c == input$TRANSITCounty)
    })
    
    output$transitCOUNTY <- renderPlotly({psrc_column_chart_share_plotly(filtered_transit_county(),
                                                                         colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))
    })
    
    output$transit_mode_race <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="Transit", 
                                                                page_section = "TRANSITRace", 
                                                                page_info = "description"))})
    
    filtered_transit_race <- reactive({
      req(input$TRANSITRace)
      
      transit_mode_race_data |>
        filter(c == input$TRANSITRace)
    })
    
    output$transitRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_transit_race(),
                                                                    colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                               "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                                    legend = FALSE)})

    output$transit_mode_metro <- renderUI({HTML(page_information(tbl=page_text, 
                                                                 page_name="Transit", 
                                                                 page_section = "TRANSITMetro", 
                                                                 page_info = "description"))})
    
    filtered_transit_metro <- reactive({
      req(input$TRANSITMetro)
      
      transit_mode_metro_data |>
        filter(c == input$TRANSITMetro)
    })
    
    output$transitMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_transit_metro(),
                                                                     colors = c("#8CC63E", "#91268F"))})
    
    output$transit_mode_city <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="Transit", 
                                                                page_section = "TRANSITCity", 
                                                                page_info = "description"))})
    
    filtered_transit_city <- reactive({
      req(input$TRANSITCity)
      
      transit_mode_city_data |>
        filter(c == input$TRANSITCity)
    })
    
    output$transitCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_transit_city(),
                                                                    colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))})

  })
}

