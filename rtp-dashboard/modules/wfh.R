wfh_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Addressing Climate Change"),
    
    tags$div(class="page_goals", "Goal: 95% below 1990 GHG Emissions by 2050"),
    htmlOutput(ns("climate_overview")),
    br(), br(),
    
    h2("Working from Home"),
    
    value_box_ui(ns('WFHvaluebox')),
    
    h3("Work from Home shares by County"),
    uiOutput(ns("climate_wfh_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WFHCounty"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("wfhCOUNTY")),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Work from Home shares by Race & Ethnicity"),
    htmlOutput(ns("climate_wfh_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WFHRace"), label = NULL, choices = pums_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("wfhRACE"), height = "600px"),
      tags$div(class = "chart_source", "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties")
    ),
    
    h3("Work from Home shares by Metropolitan Region"),
    uiOutput(ns("climate_wfh_metro")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("WFHMetro"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),

      plotlyOutput(ns("wfhMETRO"), height = "900px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301")
    ),

    h3("Work from Home shares by City"),
    uiOutput(ns("climate_wfh_city")),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("WFHCity"), label = NULL, choices = acs_yrs, inline = TRUE)
      ),
      
      plotlyOutput(ns("wfhCITY"), height = "1800px"),
      tags$div(class = "chart_source", "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties")
    )
  )
}

wfh_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Climate Overview
    output$climate_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Climate", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # Working from Home by  County
    output$climate_wfh_region <- renderUI({HTML(page_information(tbl=page_text, 
                                                                 page_name="Climate", 
                                                                 page_section = "WFHRegion", 
                                                                 page_info = "description"))})
    
    value_box_server('WFHvaluebox', df = wfh_box_values)
    
    filtered_wfh_county <- reactive({
      req(input$WFHCounty)
      
      wfh_county_data |>
        filter(c == input$WFHCounty)
    })
    
    output$wfhCOUNTY <- renderPlotly({psrc_column_chart_share_plotly(filtered_wfh_county(),
                                                                     colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#76787A"))})
    # Working from Home by Race
    output$climate_wfh_race <- renderUI({HTML(page_information(tbl=page_text, 
                                                               page_name="Climate", 
                                                               page_section = "WFHRace", 
                                                               page_info = "description"))})
    
    
    filtered_wfh_race <- reactive({
      req(input$WFHRace)

      wfh_race_data |>
        filter(c == input$WFHRace)
    })

    output$wfhRACE <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_wfh_race(),
                                                                colors = c("#8CC63E", "#F05A28", "#00A7A0", "#91268F",
                                                                           "#E2F1CF", "#FBD6C9", "#BFE9E7", "#E3C9E3"),
                                                                legend = FALSE)})

    # Working from Home by Metro Area
    output$climate_wfh_metro <- renderUI({HTML(page_information(tbl=page_text, 
                                                                page_name="Climate", 
                                                                page_section = "WFHMetro", 
                                                                page_info = "description"))})
    
    filtered_wfh_metro <- reactive({
      req(input$WFHMetro)

      wfh_metro_data |>
        filter(c == input$WFHMetro)
    })

    output$wfhMETRO <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_wfh_metro(),
                                                                 colors = c("#8CC63E", "#91268F"))})

    # Working from Home by City
    output$climate_wfh_city <- renderUI({HTML(page_information(tbl=page_text, 
                                                               page_name="Climate", 
                                                               page_section = "WFHCity", 
                                                               page_info = "description"))})
    
    filtered_wfh_city <- reactive({
      req(input$WFHCity)
      
      wfh_city_data |>
        filter(c == input$WFHCity)
    })
    
    output$wfhCITY <- renderPlotly({psrc_bar_chart_share_plotly(df = filtered_wfh_city(),
                                                                colors = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"))
      })
    
  })
}
