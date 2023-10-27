# Safety Overview -----------------------------------------------------------------------------
safety_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("safetyoverview"))
  )
}

safety_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    output$safety_overview_text <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Overview", page_info = "description")})
    
    # Overview UI
    output$safetyoverview <- renderUI({
      tagList(
        tags$div(class="page_goals", "Goal: Zero Fatal and Serious Injuries by 2030"),
        textOutput(ns("safety_overview_text")) |> withSpinner(color=load_clr),
        br()
      )
    })
  })  # end moduleServer
}

# Safety Tabs ---------------------------------------------------------------------------------
safety_geography_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("geographytab"))
  )
}

safety_geography_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$geography_region <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Geography-Regional", page_info = "description")})
    output$geography_county <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Geography-County", page_info = "description")})
    output$geography_mpo <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Geography-MPO", page_info = "description")})
    output$geography_hdc <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Geography-HDC", page_info = "description")})

    output$region_collisions_chart <- renderEcharts4r({echart_line_chart(df=safety_data |> filter(geography == "Region" & geography_type == "Region"),
                                                                        x='data_year', y='estimate', fill='metric', tog = 'variable',
                                                                        esttype="number", color = "jewel", dec = 1)})
    
    output$geography_hdc_fatal_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                               filter(geography_type == "Historically Disadvantaged Community" & variable == "Total" & metric == "Traffic Related Deaths" & grouping != "Other") |>
                                                                               mutate(metric=grouping),
                                                                             x='data_year', y='estimate', fill='metric', title='Traffic Related Deaths',
                                                                             dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$geography_hdc_serious_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                              filter(geography_type == "Historically Disadvantaged Community" & variable == "Total" & metric == "Serious Injury"& grouping != "Other") |>
                                                                              mutate(metric=grouping),
                                                                            x='data_year', y='estimate', fill='metric', title='Serious Injury',
                                                                            dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$king_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "King" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                         x='data_year', y='estimate', fill='metric', title='King County',
                                                                         dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$kitsap_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Kitsap" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                           x='data_year', y='estimate', fill='metric', title='Kitsap County',
                                                                           dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$pierce_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Pierce" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                           x='data_year', y='estimate', fill='metric', title='Pierce County',
                                                                           dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$snohomish_collisions_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(variable == "Total" & geography_type == "County" & geography == "Snohomish" & (data_year >= as.integer(current_population_year)-5 & data_year <= current_population_year)),
                                                                              x='data_year', y='estimate', fill='metric', title='Snohomish County',
                                                                              dec = 1, esttype = 'number', color = psrc_colors$pognbgy_5)})
    
    output$mpo_fatal_collisions_chart <- renderEcharts4r({echart_bar_chart(df=mpo_safety, title = "Traffic Deaths per 100,000 people", tog = 'variable',
                                                                           y='estimate', x='geography', esttype="number", dec=1, color = 'jewel')})
    # Tab layout
    output$geographytab <- renderUI({
      tagList(
        # Region
        h1("Region"),
        textOutput(ns("geography_region")) |> withSpinner(color=load_clr),
        br(),
        fluidRow(column(12,echarts4rOutput(ns("region_collisions_chart")))),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        hr(style = "border-top: 1px solid #000000;"),
        
        h1("Historically Disadvantaged Community"),
        textOutput(ns("geography_hdc")),
        br(),
        fluidRow(column(6,echarts4rOutput(ns("geography_hdc_fatal_chart"))),
                 column(6,echarts4rOutput(ns("geography_hdc_serious_chart")))),
        br(),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # County
        h1("County"),
        textOutput(ns("geography_county")),
        br(),
        #strong(tags$div(class="chart_title","Fatal Collisions by County")),
        fluidRow(column(6,echarts4rOutput(ns("king_collisions_chart"))),
                 column(6,echarts4rOutput(ns("kitsap_collisions_chart")))),
        fluidRow(column(6,echarts4rOutput(ns("pierce_collisions_chart"))),
                 column(6,echarts4rOutput(ns("snohomish_collisions_chart")))),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # MPO
        h1("Metropolitan Region"),
        textOutput(ns("geography_mpo")),
        fluidRow(column(12,echarts4rOutput(ns("mpo_fatal_collisions_chart"), height = "600px"))),
        tags$div(class="chart_source","Fatalities: NHTSA Fatality Analysis Reporting System (FARS) Data"),
        tags$div(class="chart_source","Population: US Census Bureau American Community Survey (ACS) 5-year data Table B03002"),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  })  # end moduleServer
}

safety_demographics_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("demographicstab"))
  )
}

safety_demographics_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$demographics_race <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Demographics-Race", page_info = "description")})
    output$demographics_age <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Demographics-Age", page_info = "description")})
    output$demographics_gender <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Demographics-Gender", page_info = "description")})
    
    
    output$demographics_race_chart <- renderEcharts4r({echart_pictorial(df= safety_data |> 
                                                                          filter(geography_type=="Race" & data_year == current_census_year & variable == "Rate per 100k people") |>
                                                                          mutate(grouping = str_wrap(grouping, 15)),
                                                                        x="grouping", y="estimate", tog="variable", 
                                                                        icon=fa_user, color=psrc_colors$gnbopgy_5,
                                                                        title="Race & Hispanic Origin", dec = 2)})
    
    output$demographics_age_total_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(geography_type == "Age Group" & data_year == current_census_year & variable == "Total"),
                                                                                x='grouping', y='estimate', fill='metric', title='Total Injuries',
                                                                                dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$demographics_age_rate_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(geography_type == "Age Group" & data_year == current_census_year & variable == "Rate per 100k people"),
                                                                               x='grouping', y='estimate', fill='metric', title='Rate per 100k people',
                                                                               dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$demographics_gender_total_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(geography_type == "Gender" & data_year == current_census_year & variable == "Total"),
                                                                                   x='grouping', y='estimate', fill='metric', title='Total Injuries',
                                                                                   dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    output$demographics_gender_rate_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> filter(geography_type == "Gender" & data_year == current_census_year & variable == "Rate per 100k people"),
                                                                                  x='grouping', y='estimate', fill='metric', title='Rate per 100k people',
                                                                                  dec = 1, esttype = 'number', color = psrc_colors$gnbopgy_5)})
    
    
    # Tab layout
    output$demographicstab <- renderUI({
      tagList(
        # Race
        h1("Race & Ethnicity"),
        textOutput(ns("demographics_race")) |> withSpinner(color=load_clr),
        br(),
        fluidRow(column(12,echarts4rOutput(ns("demographics_race_chart")))),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Population: US Census Bureau American Community Survey (ACS) 5-year data Table B03002"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # Age
        h1("Age Group"),
        textOutput(ns("demographics_age")),
        br(),
        fluidRow(column(6,echarts4rOutput(ns("demographics_age_total_chart"))),
                 column(6,echarts4rOutput(ns("demographics_age_rate_chart")))),
        br(),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        tags$div(class="chart_source","Population: US Census Bureau American Community Survey (ACS) 5-year data Table B01001"),
        hr(style = "border-top: 1px solid #000000;"),
        
        # Gender
        h1("Gender"),
        textOutput(ns("demographics_gender")),
        br(),
        fluidRow(column(6,echarts4rOutput(ns("demographics_gender_total_chart"))),
                 column(6,echarts4rOutput(ns("demographics_gender_rate_chart")))),
        br(),
        tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
        tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
        tags$div(class="chart_source","Population: US Census Bureau American Community Survey (ACS) 5-year data Table B01001"),
        hr(style = "border-top: 1px solid #000000;")
        
      )
    }) # end of render ui for demographics tab
  })
  } # end of module server for demographics server
  

    safety_other_ui <- function(id) {
      ns <- NS(id)
      
      tagList(
        uiOutput(ns("othertab"))
      )
    }
    
    safety_other_server <- function(id) {
      moduleServer(id, function(input, output, session){
        ns <- session$ns
        
        # Text and charts
        output$other_mode <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Other-Mode", page_info = "description")})
        output$other_time <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Other-Time", page_info = "description")})
        output$other_day <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Other-Day", page_info = "description")})
        output$other_roadway <- renderText({page_information(tbl=page_text, page_name="Safety", page_section = "Other-Roadway", page_info = "description")})
        
        
        output$other_mode_fatal_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                filter(geography_type == "Mode" & variable == "Total" & metric == "Traffic Related Deaths" & grouping != "Other") |>
                                                                                mutate(metric=grouping),
                                                                              x='data_year', y='estimate', fill='metric', title='Traffic Related Deaths',
                                                                              dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_mode_serious_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                  filter(geography_type == "Mode" & variable == "Total" & metric == "Serious Injury"& grouping != "Other") |>
                                                                                mutate(metric=grouping),
                                                                              x='data_year', y='estimate', fill='metric', title='Serious Injury',
                                                                              dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_tod_fatal_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                               filter(geography_type == "Time of Day" & variable == "Total" & metric == "Traffic Related Deaths" & grouping != "Other") |>
                                                                               mutate(metric=grouping),
                                                                             x='data_year', y='estimate', fill='metric', title='Traffic Related Deaths',
                                                                             dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_tod_serious_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                 filter(geography_type == "Time of Day" & variable == "Total" & metric == "Serious Injury" & grouping != "Other") |>
                                                                                 mutate(metric=grouping),
                                                                               x='data_year', y='estimate', fill='metric', title='Serious Injury',
                                                                               dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_dow_fatal_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                               filter(geography_type == "Day of Week" & variable == "Total" & metric == "Traffic Related Deaths" & grouping != "Other") |>
                                                                               mutate(metric=grouping),
                                                                             x='data_year', y='estimate', fill='metric', title='Traffic Related Deaths',
                                                                             dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_dow_serious_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                 filter(geography_type == "Day of Week" & variable == "Total" & metric == "Serious Injury" & grouping != "Other") |>
                                                                                 mutate(metric=grouping),
                                                                               x='data_year', y='estimate', fill='metric', title='Serious Injury',
                                                                               dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_roadway_fatal_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                   filter(geography_type == "Roadway Type" & variable == "Total" & metric == "Traffic Related Deaths" & grouping != "Other") |>
                                                                                   mutate(metric=grouping),
                                                                                 x='data_year', y='estimate', fill='metric', title='Traffic Related Deaths',
                                                                                 dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        output$other_roadway_serious_chart <- renderEcharts4r({echart_column_chart(df = safety_data |> 
                                                                                     filter(geography_type == "Roadway Type" & variable == "Total" & metric == "Serious Injury" & grouping != "Other") |>
                                                                                     mutate(metric=grouping),
                                                                                   x='data_year', y='estimate', fill='metric', title='Serious Injury',
                                                                                   dec = 0, esttype = 'number', color = psrc_colors$gnbopgy_5)})
        
        
        
        
        # Tab layout
        output$othertab <- renderUI({
          tagList(
            # Mode
            h1("Mode"),
            textOutput(ns("other_mode")) |> withSpinner(color=load_clr),
            br(),
            fluidRow(column(6,echarts4rOutput(ns("other_mode_fatal_chart"))),
                     column(6,echarts4rOutput(ns("other_mode_serious_chart")))),
            br(),
            tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
            tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
            hr(style = "border-top: 1px solid #000000;"),
            
            h1("Roadway Type"),
            textOutput(ns("other_roadway")),
            br(),
            fluidRow(column(6,echarts4rOutput(ns("other_roadway_fatal_chart"))),
                     column(6,echarts4rOutput(ns("other_roadway_serious_chart")))),
            br(),
            tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
            tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
            hr(style = "border-top: 1px solid #000000;"),
            
            h1("Time of Day"),
            textOutput(ns("other_time")),
            br(),
            fluidRow(column(6,echarts4rOutput(ns("other_tod_fatal_chart"))),
                     column(6,echarts4rOutput(ns("other_tod_serious_chart")))),
            br(),
            tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
            tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
            hr(style = "border-top: 1px solid #000000;"),
            
            h1("Day of Week"),
            textOutput(ns("other_day")),
            br(),
            fluidRow(column(6,echarts4rOutput(ns("other_dow_fatal_chart"))),
                     column(6,echarts4rOutput(ns("other_dow_serious_chart")))),
            br(),
            tags$div(class="chart_source","Fatalities: Washington Traffic Safety Commission Coded Fatality Files (2022 Preliminary)"),
            tags$div(class="chart_source","Serious Injuries: WSDOT, Crash Data Division, Multi-Row data files (MRFF)"),
            hr(style = "border-top: 1px solid #000000;")
            
          )
        })
  
  })  # end moduleServer
}
