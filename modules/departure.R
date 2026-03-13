departure_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Managing Travel Time & Congestion"),
    
    tags$div(class="page_goals", "Draft 2026-2050 Plan Outcome: Limit Growth in Annual Delay per Household"),
    htmlOutput(ns("tt_overview")),
    br(), br(),
    
    h2("Departure Time to Work"),
    
    value_box_ui(ns('DTvaluebox')),
    
    h3("Early Morning Departure Time to Work by County"),
    uiOutput(ns("dt_commute_county")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("DTCounty"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("dtCOUNTY")),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWDP for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Early Morning Departure Time to Work by Race & Ethnicity"),
    htmlOutput(ns("dt_commute_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("DTRace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("dtRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWDP for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Early Morning Departure Time to Work by Metropolitan Region"),
    uiOutput(ns("dt_commute_metro")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("DTMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),

      plotlyOutput(ns("dtMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08011")
    ),

    h3("Early Morning Departure Time to Work by City"),
    uiOutput(ns("dt_commute_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("DTCity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("dtCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08011")
    )
  )
}

departure_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$tt_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="TravelTime", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # By  County
    output$dt_commute_county <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="TravelTime", 
                                                                page_section = "DTCounty",
                                                                page_info = "description"))})
    
    value_box_server('DTvaluebox', df = dt_box_values)
    
    filtered_dt_county <- reactive({
      req(input$DTCounty)
      
      dt_county_data |>
        filter(c == input$DTCounty)
    })
    
    output$dtCOUNTY <- renderPlotly({psrc_column_chart_share_plotly(filtered_dt_county(),
                                                                    colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))})
    # By Race
    output$dt_commute_race <- renderUI({HTML(page_information(tbl=page_text, 
                                                              page_name="TravelTime", 
                                                              page_section = "DTRace", 
                                                              page_info = "description"))})
    
    
    filtered_dt_race <- reactive({
      req(input$DTRace)

      dt_race_data |>
        filter(c == input$DTRace)
    })

    output$dtRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_dt_race(),
                                                               colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                          "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                               legend = FALSE)})

    # By Metro Area
    output$dt_commute_metro <- renderUI({HTML(page_information(tbl=page_text,
                                                               page_name="TravelTime", 
                                                               page_section = "DTMetro",
                                                               page_info = "description"))})
    
    filtered_dt_metro <- reactive({
      req(input$DTMetro)

      dt_metro_data |>
        filter(c == input$DTMetro)
    })

    output$dtMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_dt_metro(),
                                                                colors = c("#8CC63E", "#91268F"))})

    # By City
    output$dt_commute_city <- renderUI({HTML(page_information(tbl=page_text,
                                                              page_name="TravelTime", 
                                                              page_section = "DTCity",
                                                              page_info = "description"))})
    
    filtered_dt_city <- reactive({
      req(input$DTCity)
      
      dt_city_data |>
        filter(c == input$DTCity)
    })
    
    output$dtCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_dt_city(),
                                                               colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))
      })
    
  })
}
