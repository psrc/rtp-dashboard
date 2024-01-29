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
    output$zev_tracts <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "ZEV-Tracts", page_info = "description")})
    
    output$ev_share_new_registrations_chart <- renderEcharts4r({echart_line_chart(df=climate_data |> 
                                                                                    filter(geography == "Region" & metric == "vehicle-registrations" & variable != "Plug-in Hybrid Electric Vehicle") |>
                                                                                    mutate(plot_date = paste0(lubridate::month(date),"-",lubridate::year(date))),
                                                                                  x='plot_date', y='share', fill='variable', tog = 'grouping',
                                                                                  esttype="percent", color = "jewel", dec = 0)})
    
    output$ev_tract_map <- renderLeaflet({create_share_map(lyr=ev_by_tract, title="ZEV Share", 
                                                           efa_lyr=efa_income, 
                                                           efa_title="Equiy Focus Area: Income")})
    
    # Tab layout
    output$climatezev <- renderUI({
      tagList(
        h1("Vehicle Registrations in the PSRC Region"),
        textOutput(ns("zev_region")) |> withSpinner(color=load_clr),
        br(),
        strong(tags$div(class="chart_title","Share of New Vehicle Registrations")),
        fluidRow(column(12,echarts4rOutput(ns("ev_share_new_registrations_chart")))),
        tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;"),
        
        #  Tracts
        h1("Vehicle Registrations by Census Tract"),
        textOutput(ns("zev_tracts")),
        br(),
        fluidRow(column(12,leafletOutput(ns("ev_tract_map")))),
        tags$div(class="chart_source","Source: WA State Open Data Portal, King, Kitsap, Pierce & Snohomish counties"),
        hr(style = "border-top: 1px solid #000000;")
      )
    }) #|> withSpinner(color="#0dc5c1")
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
    
    output$chart_vkt_per_capita <- renderEcharts4r({echart_bar_chart(df=vkt_data, title = "", tog = 'metric',
                                                                     y='estimate', x='geography', esttype="number", dec=1, color = 'jewel')})
    
    # Tab layout
    output$climatevmt <- renderUI({
      tagList(
        h1("Region"),
        textOutput(ns("regional_vmt_text")) |> withSpinner(color=load_clr),
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
        fluidRow(column(12,echarts4rOutput(ns("chart_vkt_per_capita"), height = "800px"))),
        tags$div(class="chart_source","Source: WSDOT HPMS, SoundCast, "),
        br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

telework_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("teleworktab"))
  )
}

telework_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$wfh_share_county_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "WFH-County", page_info = "description")})
    output$wfh_share_race_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "WFH-Race", page_info = "description")})
    output$wfh_share_metro_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "WFH-Metro", page_info = "description")})
    output$wfh_share_city_text <- renderText({page_information(tbl=page_text, page_name="Climate", page_section = "WFH-City", page_info = "description")})
    
    # Charts
    output$wfh_ms_county_chart <- renderEcharts4r({echart_column_chart_timeline(df = commute_data |> 
                                                                                  filter(variable == "Work from Home" & geography_type == "County" & metric == "commute-modes") |>
                                                                                  mutate(geography = str_wrap(geography, 10)) |>
                                                                                  mutate(year = factor(x=year, levels = yr_ord)) |>
                                                                                  mutate(geography = factor(x=geography, levels = county_ord)) |>
                                                                                  arrange(year, geography),
                                                                                x = "geography", y = "share", fill = "geography", tog = "year", 
                                                                                dec = 1, title = "Work from Home", esttype = "percent", color = "jewel")})
    
    output$wfh_ms_race_chart <- renderEcharts4r({echart_pictorial(df= commute_data |> 
                                                                    filter(geography_type=="Race" & year == current_pums_year & variable == "Worked from home") |>
                                                                    mutate(grouping = str_wrap(grouping, 15)),
                                                                  x="grouping", y="share", tog="variable", 
                                                                  icon=fa_wfh, 
                                                                  color=psrc_colors$gnbopgy_5[[5]],
                                                                  title="Race & Hispanic Origin", dec = 2, esttype = "percent")})
    
    output$wfh_ms_metro_chart <- renderEcharts4r({echart_bar_chart(df=commute_data |>
                                                                     filter(geography_type == "Metro Areas" & variable == "Work from Home") |>
                                                                     mutate(year = factor(x=year, levels=yr_ord)) |>
                                                                     arrange(year, share), 
                                                                   title = "Work from Home", tog = 'year',
                                                                   y='share', x='geography', esttype="percent", dec=1, color = 'jewel')})
    
    output$wfh_ms_city_chart <- renderEcharts4r({echart_multi_series_bar_chart(df=commute_data |>
                                                                                 filter(geography_type == "City" & variable == "Work from Home" & year == current_census_year) |>
                                                                                 arrange(share) |>
                                                                                 mutate(estimate = share) |>
                                                                                 mutate(metric = "Work from Home"), 
                                                                               x = "geography", y='estimate', fill='metric', 
                                                                               esttype="percent", title="Work from Home", dec=1, color = psrc_colors$pognbgy_5[[5]])})
    
    # Tab layout
    output$teleworktab <- renderUI({
      tagList(
        h1("Work from Home: County"),
        textOutput(ns("wfh_share_county_text")) |> withSpinner(color=load_clr),
        fluidRow(column(12,echarts4rOutput(ns("wfh_ms_county_chart")))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Work from Home: Race & Ethnicity"),
        textOutput(ns("wfh_share_race_text")),
        fluidRow(column(12,echarts4rOutput(ns("wfh_ms_race_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties"),
        hr(),
        
        h1("Work from Home: Metropolitan Region"),
        textOutput(ns("wfh_share_metro_text")),
        fluidRow(column(12,echarts4rOutput(ns("wfh_ms_metro_chart"), height = "600px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr(),
        
        h1("Work from Home: City"),
        textOutput(ns("wfh_share_city_text")),
        fluidRow(column(12,echarts4rOutput(ns("wfh_ms_city_chart"), height = "1200px"))),
        tags$div(class="chart_source","Source: ACS 5yr Data Table B08301"),
        hr()
      )
    })
  }) # end moduleServer
}
