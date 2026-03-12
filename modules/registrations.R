registrations_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    h1("Addressing Climate Change"),
    
    tags$div(class="page_goals", "Goal: 95% below 1990 GHG Emissions by 2050"),
    htmlOutput(ns("climate_overview")),
    br(), br(),
    
    h2("Vehicle Registrations"),

    value_box_ui(ns("REGIONregistrationvaluebox")),
    
    h3("New Vehicle Registrations in the PSRC Region"),
    uiOutput(ns("climate_registrations_region")),
    br(),
    
    card(
      full_screen = FALSE,
      
      layout_column_wrap(
        width = 1,
        radioButtons(ns("RegistrationChoice"), label = NULL, choices = c("New", "Used"), inline = TRUE)
      ),

      plotlyOutput(ns("REGISTRATIONSlinechart")),
      tags$div(class = "chart_source", "Source: Washington State Department of Licensing")
    ),
    
    h3("New Registrations by Census Tract"),
    
    uiOutput(ns("climate_registrations_tract")),
    br(),
    
    card(
      full_screen = FALSE,
      leafletOutput(ns("tract_map"))
    )
  )
}

registrations_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Climate Overview
    output$climate_overview <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Climate", 
                            page_section = "Overview", 
                            page_info = "description"))
    })
    
    # Region Registrations
    output$climate_registrations_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Climate", 
                            page_section = "RegistrationsRegion", 
                            page_info = "description"))
    })
    
    value_box_server('REGIONregistrationvaluebox', df = registration_box_values)
    
    filtered_registration <- reactive({
      req(input$RegistrationChoice)
      
      vehicle_region_data |>
        filter(c == input$RegistrationChoice)
    })
    
    output$REGISTRATIONSlinechart <- renderPlotly({
      psrc_line_chart_share_plotly(filtered_registration())})
    
    # Registrations by Tract
    output$climate_registrations_tract <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="Climate", 
                            page_section = "RegistrationsTract", 
                            page_info = "description"))
    })
    
    output$tract_map <- renderLeaflet({
      create_share_map(lyr=tract_ev_data, 
                       title="ZEV Share")})
    
  })
}
