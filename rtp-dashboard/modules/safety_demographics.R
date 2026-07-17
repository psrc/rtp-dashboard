safety_demographics_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Adressing Safety via the Safe System Approach"),
    
    tags$div(class="page_goals", "Goal: Zero Fatal and Serious Injuries by 2030"),
    htmlOutput(ns("safety_overview")),
    br(), br(),
    
    h2("Demographic Summarization of Safety Trends"),
    
    value_box_ui(ns('SAFETYvaluebox')),
    
    h3("Annual Deaths and Serious Injuries by Race & Ethnicity"),
    uiOutput(ns("safety_demographic_race")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYRACEChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), selected = "Rate per 100k people", inline = TRUE)
      ),
      
      plotlyOutput(ns("raceDEATHS"), height = "600px"),
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files")
    ),
    
    h3("Annual Deaths and Serious Injuries by Age Group"),
    uiOutput(ns("safety_demographic_age")),
    br(),

    card(
      full_screen = FALSE,

      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYAGEChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), selected = "Rate per 100k people", inline = TRUE)
      ),

      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),

      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("ageDEATHS")),
        plotlyOutput(ns("ageSERIOUS"))
      ),

      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    ),
    
    h3("Annual Deaths and Serious Injuries by Gender"),
    uiOutput(ns("safety_demographic_gender")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("SAFETYGENDERChoice"), label = NULL, choices = c("Total", "Rate per 100k people"), selected = "Rate per 100k people", inline = TRUE)
      ),
      
      layout_columns(
        col_widths = c(6,6),
        strong("Traffic Related Deaths"),
        strong("Serious Injuries")
      ),
      
      layout_columns(
        col_widths = c(6,6),
        plotlyOutput(ns("genderDEATHS")),
        plotlyOutput(ns("genderSERIOUS"))
      ),
      
      tags$div(class = "chart_source", "Source: WTSC Coded Fatality Files & WSDOT Multi-Row data files (MRFF)")
    )
  )
}

safety_demographics_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Overview
    output$safety_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Safety", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    value_box_server('SAFETYvaluebox', df = safety_person_box_values)
    
    # By race
    output$safety_demographic_race <- renderUI({HTML(page_information(tbl=page_text, 
                                                                      page_name="Safety", 
                                                                      page_section = "SAFETYRace", 
                                                                      page_info = "description"))})
    
    
    
    filtered_race_deaths <- reactive({
      req(input$SAFETYRACEChoice)
      
      deaths_race_data |>
        filter(c == input$SAFETYRACEChoice)
    })
    
    output$raceDEATHS <- renderPlotly({psrc_bar_chart_total_plotly(df = filtered_race_deaths(),
                                                                    colors = c("#8CC63E"))})
    
    #By Age Group
    output$safety_demographic_age <- renderUI({HTML(page_information(tbl=page_text,
                                                                   page_name="Safety",
                                                                   page_section = "SAFETYAge",
                                                                   page_info = "description"))})

    filtered_age_deaths <- reactive({
      req(input$SAFETYAGEChoice)

      deaths_age_data  |>
        filter(c == input$SAFETYAGEChoice)
    })

    output$ageDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_age_deaths(),
                                     colors = c("#F05A28"))})

    filtered_age_serious <- reactive({
      req(input$SAFETYAGEChoice)

      serious_age_data  |>
        filter(c == input$SAFETYAGEChoice)
    })

    output$ageSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_age_serious(),
                                     colors = c("#91268F"))})

    #By Gender
    output$safety_demographic_gender <- renderUI({HTML(page_information(tbl=page_text,
                                                                        page_name="Safety",
                                                                        page_section = "SAFETYGender",
                                                                        page_info = "description"))})
    
    filtered_gender_deaths <- reactive({
      req(input$SAFETYGENDERChoice)
      
      deaths_gender_data  |>
        filter(c == input$SAFETYGENDERChoice)
    })
    
    output$genderDEATHS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_gender_deaths(),
                                     colors = c("#F05A28"))})
    
    filtered_gender_serious <- reactive({
      req(input$SAFETYGENDERChoice)
      
      serious_gender_data  |>
        filter(c == input$SAFETYGENDERChoice)
    })
    
    output$genderSERIOUS <- renderPlotly({
      psrc_column_chart_total_plotly(df = filtered_gender_serious(),
                                     colors = c("#91268F"))}) 
  })
}
