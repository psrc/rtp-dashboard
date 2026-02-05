# Define server logic
shinyServer(function(input, output) {
  
  footer_server('psrcfooter')
  
  loaded <- reactiveValues(
    zev = FALSE,
    vmt = FALSE,
    wfh = FALSE,
    trnmet = FALSE,
    trnmod = FALSE
  )

  # Overview Page -----------------------------------------------------------
  
  overview_server('OVERVIEW')
  output$howto_text <- renderUI({HTML(page_information(tbl=page_text, page_name="Overview", page_section = "Overview-HowTo", page_info = "description"))})
  
  # Climate Page -----------------------------------------------------------

  output$climate_section_ui <- renderUI({
    switch(input$climate_section,
           "zev" = climate_zev_ui("zev"),
           "vmt" = climate_vmt_ui("vmt"),
           "wfh" = climate_wfh_ui("wfh")
    )
  })
  
  output$climate_overview <- renderUI({
    HTML(page_information(tbl=page_text, 
                          page_name="Climate", 
                          page_section = "Overview", 
                          page_info = "description"))
  })
  
  observeEvent(input$climate_section, {
    if (input$climate_section == "zev" && !loaded$zev) {
      climate_zev_server("zev")
      loaded$zev <- TRUE
    }
    
    if (input$climate_section == "vmt" && !loaded$vmt) {
      climate_vmt_server("vmt")
      loaded$vmt <- TRUE
    }
    
    if (input$climate_section == "wfh" && !loaded$wfh) {
      climate_wfh_server("wfh")
      loaded$wfh <- TRUE
    }
  })
  

  
  # Transit Page -----------------------------------------------------------
  output$transit_section_ui <- renderUI({
    switch(input$transit_section,
           "trnmet" = transit_metric_ui("trnmet"),
           "trnmod" = transit_mode_ui("trnmod")
    )
  })
  
  output$transit_overview <- renderUI({
    HTML(page_information(tbl=page_text, 
                          page_name="Transit", 
                          page_section = "TRANSITOverview", 
                          page_info = "description"))
    })
  
  observeEvent(input$transit_section, {
    if (input$transit_section == "trnmet" && !loaded$trnmet) {
      transit_metric_server("trnmet")
      loaded$trnmet <- TRUE
    }
    
    if (input$transit_section == "trnmod" && !loaded$trnmod) {
      transit_mode_server("trnmod")
      loaded$trnmod <- TRUE
    }
    
  })
  
})  


  