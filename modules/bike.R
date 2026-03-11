biking_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Walking and Biking to Work"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: 58% More Bike trips by 2050"),
    
    htmlOutput(ns("walk_bike_overview")),
    br(), br(),
    
    h2("Biking to Work"),
    
    value_box_ui(ns('BIKEMODEvaluebox')),
    
    h3("Bike shares by County"),
    uiOutput(ns("bike_mode_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("BIKECounty"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("bikeCOUNTY")),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Bike shares by Race & Ethnicity"),
    htmlOutput(ns("bike_mode_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("BIKERace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("bikeRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Bike shares by Metropolitan Region"),
    uiOutput(ns("bike_mode_metro")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("BIKEMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("bikeMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301")
    ),
    
    h3("Bike shares by City"),
    uiOutput(ns("bike_mode_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("BIKECity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("bikeCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    )
  )
}

biking_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$walk_bike_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKBIKEOverview", 
                            page_info = "description"))
    })
    
    value_box_server('BIKEMODEvaluebox', df = bike_mode_box_values)

    output$bike_mode_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKERegion", 
                            page_info = "description"))
      })
    
    filtered_bike_county <- reactive({
      req(input$BIKECounty)
      
      bike_mode_county_data |>
        filter(c == input$BIKECounty)
    })
    
    output$bikeCOUNTY <- renderPlotly({psrc_column_chart_share_plotly(filtered_bike_county(),
                                                                      colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))
      })

    
    output$bike_mode_race <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKERace", 
                            page_info = "description"))
      })
    
    filtered_bike_race <- reactive({
      req(input$BIKERace)
      
      bike_mode_race_data |>
        filter(c == input$BIKERace)
    })
    
    output$bikeRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_bike_race(),
                                                                 colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                            "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                                 legend = FALSE)})

    output$bike_mode_metro <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKEMetro", 
                            page_info = "description"))
      })
    
    filtered_bike_metro <- reactive({
      req(input$BIKEMetro)
      
      bike_mode_metro_data |>
        filter(c == input$BIKEMetro)
    })
    
    output$bikeMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_bike_metro(),
                                                                  colors = c("#8CC63E", "#91268F"))
      })

    output$bike_mode_city <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKECity", 
                            page_info = "description"))
      })
    
    filtered_bike_city <- reactive({
      req(input$BIKECity)
      
      bike_mode_city_data |>
        filter(c == input$BIKECity)
    })
    
    output$bikeCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_bike_city(),
                                                                 colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))
      })

  })
}
