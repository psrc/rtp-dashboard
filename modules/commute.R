commute_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Managing Travel Time & Congestion"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: Limit Growth in Annual Delay per Household"),
    htmlOutput(ns("tt_overview")),
    br(), br(),
    
    h2("Travel Time to Work"),
    
    value_box_ui(ns('TTvaluebox')),
    
    h3("Mean Travel Time to Work by County"),
    uiOutput(ns("tt_commute_county")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TTCounty"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("ttCOUNTY")),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWMNP for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Workers with a Commute over an Hour by Race & Ethnicity"),
    htmlOutput(ns("tt_commute_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TTRace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("ttRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWMNP for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Workers with a Commute over an Hour by Metropolitan Region"),
    uiOutput(ns("tt_commute_metro")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("TTMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),

      plotlyOutput(ns("ttMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08303")
    ),

    h3("Workers with a Commute over an Hour by City"),
    uiOutput(ns("tt_commute_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("TTCity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("ttCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08303")
    )
  )
}

commute_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$tt_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="TravelTime", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # By  County
    output$tt_commute_county <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="TravelTime", 
                                                                page_section = "TTCounty",
                                                                page_info = "description"))})
    
    value_box_server('TTvaluebox', df = tt_box_values)
    
    filtered_tt_county <- reactive({
      req(input$TTCounty)
      
      tt_county_data |>
        filter(c == input$TTCounty)
    })
    
    output$ttCOUNTY <- renderPlotly({psrc_column_chart_total_plotly(filtered_tt_county(),
                                                                    colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))})
    # By Race
    output$tt_commute_race <- renderUI({HTML(page_information(tbl=page_text, 
                                                              page_name="TravelTime", 
                                                              page_section = "TTRace", 
                                                              page_info = "description"))})
    
    
    filtered_tt_race <- reactive({
      req(input$TTRace)

      tt_race_data |>
        filter(c == input$TTRace)
    })

    output$ttRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_tt_race(),
                                                               colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                          "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                               legend = FALSE)})

    # By Metro Area
    output$tt_commute_metro <- renderUI({HTML(page_information(tbl=page_text,
                                                               page_name="TravelTime", 
                                                               page_section = "TTMetro",
                                                               page_info = "description"))})
    
    filtered_tt_metro <- reactive({
      req(input$TTMetro)

      tt_metro_data |>
        filter(c == input$TTMetro)
    })

    output$ttMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_tt_metro(),
                                                                colors = c("#8CC63E", "#91268F"))})

    # By City
    output$tt_commute_city <- renderUI({HTML(page_information(tbl=page_text,
                                                              page_name="TravelTime", 
                                                              page_section = "TTCity",
                                                              page_info = "description"))})
    
    filtered_tt_city <- reactive({
      req(input$TTCity)
      
      tt_city_data |>
        filter(c == input$TTCity)
    })
    
    output$ttCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_tt_city(),
                                                               colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))
      })
    
  })
}
