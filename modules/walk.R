walking_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Walking and Biking to Work"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: 83% More Walk Trips by 2050"),
    
    htmlOutput(ns("walk_bike_overview")),
    br(), br(),
    
    h2("Walking to Work"),
    
    value_box_ui(ns('WALKMODEvaluebox')),
    
    h3("Walk shares by County"),
    uiOutput(ns("walk_mode_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WALKCounty"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("walkCOUNTY")),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Walk shares by Race & Ethnicity"),
    htmlOutput(ns("walk_mode_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WALKRace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("walkRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Walk shares by Metropolitan Region"),
    uiOutput(ns("walk_mode_metro")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WALKMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("walkMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301")
    ),
    
    h3("Walk shares by City"),
    uiOutput(ns("walk_mode_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WALKCity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("walkCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    )
  )
}

walking_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$walk_bike_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKBIKEOverview", 
                            page_info = "description"))
    })
    
    value_box_server('WALKMODEvaluebox', df = walk_mode_box_values)

    output$walk_mode_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKRegion", 
                            page_info = "description"))
      })
    
    filtered_walk_county <- reactive({
      req(input$WALKCounty)
      
      walk_mode_county_data |>
        filter(c == input$WALKCounty)
    })
    
    output$walkCOUNTY <- renderPlotly({psrc_column_chart_share_plotly(filtered_walk_county(),
                                                                      colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))
      })

    
    output$walk_mode_race <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKRace", 
                            page_info = "description"))
      })
    
    filtered_walk_race <- reactive({
      req(input$WALKRace)
      
      walk_mode_race_data |>
        filter(c == input$WALKRace)
    })
    
    output$walkRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_walk_race(),
                                                                 colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                            "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                                 legend = FALSE)})

    output$walk_mode_metro <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKMetro", 
                            page_info = "description"))
      })
    
    filtered_walk_metro <- reactive({
      req(input$WALKMetro)
      
      walk_mode_metro_data |>
        filter(c == input$WALKMetro)
    })
    
    output$walkMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_walk_metro(),
                                                                  colors = c("#8CC63E", "#91268F"))})

    output$walk_mode_city <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKCity", 
                            page_info = "description"))
      })
    
    filtered_walk_city <- reactive({
      req(input$WALKCity)
      
      walk_mode_city_data |>
        filter(c == input$WALKCity)
    })
    
    output$walkCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_walk_city(),
                                                                 colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))
    })

  })
}
