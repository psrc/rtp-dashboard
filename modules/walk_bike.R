walk_mode_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    value_box_ui(ns('WALKMODEvaluebox')),

    h2("Walk shares by County"),
    uiOutput(ns("walk_mode_region")),
    br(), br(),
    column_chart_ui(ns('WALKcounty')),

    h2("Walk shares by Race & Ethnicity"),
    uiOutput(ns("walk_mode_race")),
    br(),
    mepeople_chart_ui(ns('WALKrace')),

    h2("Walk shares by Metropolitan Region"),
    uiOutput(ns("walk_mode_metro")),
    br(), br(),
    bar_chart_ui(ns('WALKmetro')),

    h2("Walk shares by City"),
    uiOutput(ns("walk_mode_city")),
    br(),
    bar_chart_ui(ns('WALKcity'))
    
  )
}

walk_mode_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    value_box_server('WALKMODEvaluebox', 
                     df = commute_data,
                     by = wfh_base_year,
                     bv = "Walk",
                     vy = wfh_vision_year,
                     vv = "Walk",
                     cy = wfh_vmt_year,
                     cv = "Walk",
                     hy = wfh_horizon_year,
                     hv = "Walk",
                     gr = "All",
                     ge = "Region",
                     me = "commute-modes",
                     ti = "share of workers who walked to get to work",
                     fac = 100,
                     dec = 0,
                     s = "%",
                     val = "share")
    
    output$walk_mode_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKRegion", 
                            page_info = "description"))
      })
    
    column_chart_server('WALKcounty',
                        df = commute_data,
                        v = "Walk",
                        ch = acs_yrs,
                        s = "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties",
                        me = "commute-modes",
                        gr = "All",
                        gt = "County",
                        val = "share",
                        p = "yes",
                        dp = 1)
    
    output$walk_mode_race <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKRace", 
                            page_info = "description"))
      })
    
    mepeople_chart_server('WALKrace',
                          df = commute_data,
                          ch = pums_yrs,
                          s = "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties",
                          me = "Commute Mode",
                          v = "Walked",
                          gt = "Race",
                          val = "share",
                          grp = "grouping",
                          icon_pth = "www/person-walking-solid-full.svg",
                          icon_clr = "#4C4C4C",
                          data_max = 10,
                          per_icons = 1)
    
    output$walk_mode_metro <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKMetro", 
                            page_info = "description"))
      })
    
    bar_chart_server('WALKmetro',
                     df = commute_data |> filter(geography_type == "Metro Areas" & variable == "Walk"),
                     x = "geography",
                     y = "share",
                     f = "plot_id",
                     color = c("#8CC63E", "#91268F"),
                     h = "600px",
                     ch = acs_yrs,
                     p = "yes",
                     d = 0,
                     s = "Source: ACS 5yr Data Table B08301")
    
    output$walk_mode_city <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "WALKCity", 
                            page_info = "description"))
      })
    
    bar_chart_server('WALKcity',
                     df = commute_data |> filter(geography_type == "City" & variable == "Walk"),
                     x = "geography",
                     y = "share",
                     f = "plot_id",
                     color = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"),
                     h = "1400px",
                     ch = acs_yrs,
                     p = "yes",
                     d = 0,
                     s = "Source: ACS 5yr Data Table B08301")
    
  })
}

bike_mode_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    value_box_ui(ns('BIKEMODEvaluebox')),
    
    h2("Bike shares by County"),
    uiOutput(ns("bike_mode_region")),
    br(), br(),
    column_chart_ui(ns('BIKEcounty')),
    
    h2("Bike shares by Race & Ethnicity"),
    uiOutput(ns("bike_mode_race")),
    br(),
    mepeople_chart_ui(ns('BIKErace')),
    
    h2("Bike shares by Metropolitan Region"),
    uiOutput(ns("bike_mode_metro")),
    br(), br(),
    bar_chart_ui(ns('BIKEmetro')),
    
    h2("Bike shares by City"),
    uiOutput(ns("bike_mode_city")),
    br(),
    bar_chart_ui(ns('BIKEcity'))
    
  )
}

bike_mode_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    value_box_server('BIKEMODEvaluebox', 
                     df = commute_data,
                     by = wfh_base_year,
                     bv = "Bike",
                     vy = wfh_vision_year,
                     vv = "Bike",
                     cy = wfh_vmt_year,
                     cv = "Bike",
                     hy = wfh_horizon_year,
                     hv = "Bike",
                     gr = "All",
                     ge = "Region",
                     me = "commute-modes",
                     ti = "share of workers who biked to get to work",
                     fac = 100,
                     dec = 0,
                     s = "%",
                     val = "share")
    
    output$bike_mode_region <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKERegion", 
                            page_info = "description"))
      })
    
    column_chart_server('BIKEcounty',
                        df = commute_data,
                        v = "Bike",
                        ch = acs_yrs,
                        s = "Source: ACS 5yr Data Table B08301 for King, Kitsap, Pierce and Snohomish counties",
                        me = "commute-modes",
                        gr = "All",
                        gt = "County",
                        val = "share",
                        p = "yes",
                        dp = 1)
    
    output$bike_mode_race <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKERace", 
                            page_info = "description"))})
    
    mepeople_chart_server('BIKErace',
                          df = commute_data,
                          ch = pums_yrs,
                          s = "Source: US Census Bureau 5-yr PUMS Variable JWTRNS for King, Kitsap, Pierce and Snohomish counties",
                          me = "Commute Mode",
                          v = "Bicycle",
                          gt = "Race",
                          val = "share",
                          grp = "grouping",
                          icon_pth = "www/person-biking-solid-full.svg",
                          icon_clr = "#4C4C4C",
                          data_max = 5,
                          per_icons = 1)
    
    output$bike_mode_metro <- renderUI({
      HTML(page_information(tbl=page_text, 
                            page_name="WalkBike", 
                            page_section = "BIKEMetro", 
                            page_info = "description"))})
    
    bar_chart_server('BIKEmetro',
                     df = commute_data |> filter(geography_type == "Metro Areas" & variable == "Bike"),
                     x = "geography",
                     y = "share",
                     f = "plot_id",
                     color = c("#8CC63E", "#91268F"),
                     h = "600px",
                     ch = acs_yrs,
                     p = "yes",
                     d = 0,
                     s = "Source: ACS 5yr Data Table B08301")
    
    output$bike_mode_city <- renderUI({
      HTML(page_information(tbl=page_text,
                            page_name="WalkBike", 
                            page_section = "BIKECity", 
                            page_info = "description"))})
    
    bar_chart_server('BIKEcity',
                     df = commute_data |> filter(geography_type == "City" & variable == "Bike"),
                     x = "geography",
                     y = "share",
                     f = "plot_id",
                     color = c("#8CC63E", "#F05A28", "#91268F", "#00A7A0"),
                     h = "1400px",
                     ch = acs_yrs,
                     p = "yes",
                     d = 0,
                     s = "Source: ACS 5yr Data Table B08301")
    
  })
}
