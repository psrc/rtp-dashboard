# Climate Overview ----------------------------------------------------------------------------
climate_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climateoverview"))
  )
}

climate_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$climate_overview_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$climateoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Goal: 80% below 1990 GHG Emissions by 2050"),
        textOutput(ns("climate_overview_text")),
        br()
      )
    })
  })  # end moduleServer
}

# Climate Tabs --------------------------------------------------------------------------------
climate_zev_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climatezev"))
  )
}

climate_zev_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$zev_region <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "ZEV-Regional", page_info = "description")})
    output$zev_tracts <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "ZEV-Zipcode", page_info = "description")})
    
    output$ev_share_new_registrations_chart <- renderEcharts4r({echart_line_chart(df=climate_data |> 
                                                                                    filter(geography == "Region" & metric == "new-vehicle-registrations" & variable != "Plug-in Hybrid Electric Vehicle") |>
                                                                                    mutate(plot_date = paste0(lubridate::month(date),"-",lubridate::year(date))),
                                                                                  x='plot_date', y='share', fill='variable', tog = 'grouping',
                                                                                  esttype="percent", color = "jewel", dec = 0)})
    
    output$ev_tract_map <- renderLeaflet({create_share_map(lyr=ev_by_tract, title="ZEV Share")})
    
    # Tab layout
    output$climatezev <- renderUI({
      tagList(
        h1("New Vehicle Registrations in the PSRC Region"),
        textOutput(ns("zev_region")),
        br(),
        strong(tags$div(class="chart_title","Share of New Vehicle Registrations")),
        fluidRow(column(12,echarts4rOutput(ns("ev_share_new_registrations_chart")))),
        tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        #  Tracts
        h1("New Vehicle Registrations by Census Tract"),
        textOutput(ns("zev_tracts")),
        br(),
        fluidRow(column(12,leafletOutput(ns("ev_tract_map")))),
        tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

climate_vmt_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("climatevmt"))
  )
}

climate_vmt_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$regional_vmt_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "VMT-Regional", page_info = "description")})
    output$county_vmt_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "VMT-County", page_info = "description")})
    output$vkt_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "VMT-Global", page_info = "description")})

    output$chart_region_vmt <- renderEcharts4r({echart_line_chart(df=vmt_data |> filter(data_year >= 2000 & geography == "Region"),
                                                              x='data_year', y='estimate', fill='variable', tog = 'grouping',
                                                              esttype="number", color = "jewel", dec = 0)})
    
    output$king_vmt_chart <- renderEcharts4r({echart_column_chart(df = vmt_data |> filter(data_year >= 2000 & geography == "King" & variable == "Observed"),
                                                                  x='data_year', y='estimate', fill='metric', title='King County',
                                                                  dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$kitsap_vmt_chart <- renderEcharts4r({echart_column_chart(df = vmt_data |> filter(data_year >= 2000 & geography == "Kitsap" & variable == "Observed"),
                                                                    x='data_year', y='estimate', fill='metric', title='Kitsap County',
                                                                    dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$pierce_vmt_chart <- renderEcharts4r({echart_column_chart(df = vmt_data |> filter(data_year >= 2000 & geography == "Pierce" & variable == "Observed"),
                                                                    x='data_year', y='estimate', fill='metric', title='Pierce County',
                                                                    dec = 1, esttype = 'number', color = psrc_colors$obgnpgy_5)})
    
    output$snohomish_vmt_chart <- renderEcharts4r({echart_column_chart(df = vmt_data |> filter(data_year >= 2000 & geography == "Snohomish" & variable == "Observed"),
                                                                       x='data_year', y='estimate', fill='metric', title='Snohomish County',
                                                                       dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5[[2]])})
    
    output$chart_vkt_per_capita <- renderPlotly({interactive_bar_chart(t=vkt_data,
                                                                       y='geography', x='vkt', fill='plot_id',
                                                                       est="number", dec=0, color='pgnobgy_10') %>% layout(showlegend = FALSE)})
    
    # Tab layout
    output$climatevmt <- renderUI({
      tagList(
        h1("Region"),
        textOutput(ns("regional_vmt_text")),
        br(),
        strong(tags$div(class="chart_title","Daily Regional Vehicle Miles Traveled")),
        fluidRow(column(12,echarts4rOutput(ns("chart_region_vmt")))),
        tags$div(class="chart_source","Source: WSDOT HPMS, OFM and SoundCast Model"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # County VMT
        h1("County"),
        textOutput(ns("county_vmt_text")),
        br(),
        fluidRow(column(6,echarts4rOutput(ns("king_vmt_chart"))),
                 column(6,echarts4rOutput(ns("kitsap_vmt_chart")))),
        fluidRow(column(6,echarts4rOutput(ns("pierce_vmt_chart"))),
                 column(6,echarts4rOutput(ns("snohomish_vmt_chart")))),
        tags$div(class="chart_source","Source: WSDOT HPMS"),
        hr(style = "border-top: 1px solid #000000;"),

        # VKT
        h1("Vehicle Kilometers Traveled Comparison"),
        textOutput(ns("vkt_text")),
        br(),
        strong(tags$div(class="chart_title","Annual Vehicle Kilometers Traveled per Capita")),
        fluidRow(column(12,plotlyOutput(ns("chart_vkt_per_capita")))),
        tags$div(class="chart_source","Source: WSDOT HPMS, SoundCast, "),
        br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}
