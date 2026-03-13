# Define server logic
shinyServer(function(input, output) {
  
  footer_server('psrcfooter')

  output$main_content <- renderUI({

    switch(input$section_selection,

           "overview" = overview_ui("overview"),
           "registrations" = registrations_ui("registrations"),
           "vmt" = vmt_ui("vmt"),
           "wfh" = wfh_ui("wfh"),
           "safety_geo" = safety_geography_ui("safety_geo"),
           "safety_dem" = safety_demographics_ui("safety_dem"),
           "safety_oth" = safety_other_ui("safety_oth"),
           "growth" = growth_ui("growth"),
           "boardings" = boardings_ui("boardings"),
           "transit" = transit_ui("transit"),
           "walking" = walking_ui("walking"),
           "biking" = biking_ui("biking"),
           "commute" = commute_ui("commute"),
           "departure" = departure_ui("departure"),
           "congestion" = congestion_ui("congestion"),
           "resources" = source_ui("resources")
    )
  })
  
  overview_server('overview')
  registrations_server('registrations')
  vmt_server('vmt')
  wfh_server('wfh')
  safety_geography_server('safety_geo')
  safety_demographics_server("safety_dem")
  safety_other_server("safety_oth")
  growth_server('growth')
  boardings_server('boardings')
  transit_server('transit')
  walking_server('walking')
  biking_server('biking')
  commute_server("commute")
  departure_server("departure")
  congestion_server("congestion")
  source_server("resources")
  
})  


  