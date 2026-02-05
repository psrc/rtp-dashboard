
bar_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("barchart"))
  )
}

bar_chart_server <- function(id, df, x, y, f, color, s, h, ch, p, d) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$BARyear})
    filtered_df <- reactive({df |> filter(year == chart_metric())})
    
    # Charts & Maps
    output$bar_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_bar_chart(df = filtered_df(), x = x, y = y, fill = f, colors = color, is_percent = p, dec = d), legend=TRUE)
    })
    
    # Tab layout
    output$barchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("BARyear"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          plotlyOutput(ns("bar_chart"), height = h),
          tags$div(class = "chart_source", s)
        )
      )
    }) 
  })  # end moduleServer
}

line_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("linechart"))
  )
}

line_chart_server <- function(id, df, m, v, g, d, color, ch, s, x, y, f, p, dp) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$REGISTRATIONtype})
    filtered_df <- reactive({df |> filter(variable %in% v & geography %in% g & metric %in% m & grouping == chart_metric())})

    # Charts & Maps
    output$region_line_chart <- renderPlotly({
      
      p <- psrc_make_interactive(psrc_line_chart(df = filtered_df(), x = x, y = y, fill = f, colors = color, is_date = d, dec = dp, is_percent = p), legend=TRUE)
      
    })
    
    # Tab layout
    output$linechart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("REGISTRATIONtype"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          plotlyOutput(ns("region_line_chart")),
          tags$div(class = "chart_source", s)
        ),
      )
    }) 
  })  # end moduleServer
}

column_chart_counties_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("columnchart"))
  )
}

column_chart_counties_server <- function(id, df, v, ch, s) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$VMTtype})
    king_df <- reactive({df |> filter(variable %in% v & geography == "King" & grouping == chart_metric())})
    kitsap_df <- reactive({df |> filter(variable %in% v & geography == "Kitsap" & grouping == chart_metric())})
    pierce_df <- reactive({df |> filter(variable %in% v & geography == "Pierce" & grouping == chart_metric())})
    snohomish_df <- reactive({df |> filter(variable %in% v & geography == "Snohomish" & grouping == chart_metric())})
    
    # Charts & Maps
    output$king_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = king_df(), x = "year", y = "estimate", fill = "geography", colors = c("#91268F")), legend=TRUE)
    })
    
    output$kitsap_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = kitsap_df(), x = "year", y = "estimate", fill = "geography", colors = c("#8CC63E")), legend=TRUE)
    })
    
    output$pierce_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = pierce_df(), x = "year", y = "estimate", fill = "geography", colors = c("#F05A28")), legend=TRUE)
    })
    
    output$snohomish_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = snohomish_df(), x = "year", y = "estimate", fill = "geography", colors = c("#00A7A0")), legend=TRUE)
    })
    
    # Tab layout
    output$columnchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("VMTtype"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          layout_columns(
            
            col_widths = c(6,6),
            plotlyOutput(ns("king_chart")),
            plotlyOutput(ns("kitsap_chart")),
            plotlyOutput(ns("pierce_chart")),
            plotlyOutput(ns("snohomish_chart"))
            
          ),
          
          tags$div(class = "chart_source", s)
          
        )
      )
    }) 
  })  # end moduleServer
}

column_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("columnchart"))
  )
}

column_chart_server <- function(id, df, v, ch, s, me, gr, gt, val, p, dp) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$WFHyear})
    
    county_df <- reactive({df |> filter(metric == me & variable == v & grouping == gr & year == chart_metric() & geography_type == gt)})
    
    # Charts & Maps
    output$county_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = county_df(), 
                                                   x = "geography", 
                                                   y = val, 
                                                   fill = "geography", 
                                                   is_percent = p,
                                                   dec = dp,
                                                   colors = c("#91268F", "#8CC63E", "#F05A28", "#00A7A0", "#4C4C4C")), legend=TRUE)
    })
    
    # Tab layout
    output$columnchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("WFHyear"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          layout_columns(
            
            col_widths = c(12),
            plotlyOutput(ns("county_chart")),
          
          ),
          tags$div(class = "chart_source", s),
        ),
      )
    }) 
  })  # end moduleServer
}

mepeople_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("mepeoplechart"))
  )
}

mepeople_chart_server <- function(id, df, ch, s, me, v, gt, val, grp, icon_pth, icon_clr, data_max, per_icons) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$WFHRACEyear})
    
    county_df <- reactive({df |> filter(metric == me & variable == v & year == chart_metric() & geography_type == gt)})
    
    # Charts & Maps
    output$county_chart <- renderPlot({
      p <- psrc_mepeople_chart(df = county_df(), 
                               val = val,
                               grp = grp,
                               icon_pth = icon_pth,
                               icon_clr = icon_clr,
                               data_max = data_max,
                               per_icons = per_icons)
      p})
    
    # Tab layout
    output$mepeoplechart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("WFHRACEyear"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          layout_columns(
            
            col_widths = c(12),
            plotOutput(ns("county_chart"), height = "400px")
            
          ),
          
          tags$div(class = "chart_source", s)
        ),
      )
    }) 
  })  # end moduleServer
}

line_chart_metric_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("linechart"))
  )
}

line_chart_metric_server <- function(id, df, v, g, gr, d, color, ch, s, x, y, f, p, dp) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$METRICtype})
    filtered_df <- reactive({df |> filter(variable %in% v & geography %in% g & metric %in% chart_metric() & grouping %in% gr)})
    
    # Charts & Maps
    output$region_line_chart <- renderPlotly({
      
      p <- psrc_make_interactive(psrc_line_chart(df = filtered_df(), x = x, y = y, fill = f, colors = color, is_date = d, dec = dp, is_percent = p), legend=TRUE)
      
    })
    
    # Tab layout
    output$linechart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("METRICtype"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          plotlyOutput(ns("region_line_chart")),
          tags$div(class = "chart_source", s)
        ),
      )
    }) 
  })  # end moduleServer
}

bar_chart_metric_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("barchart"))
  )
}

bar_chart_metric_server <- function(id, df, x, y, f, color, s, h, ch, p, d) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$BARyear})
    filtered_df <- reactive({df |> filter(metric == chart_metric())})
    
    # Charts & Maps
    output$bar_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_bar_chart(df = filtered_df(), x = x, y = y, fill = f, colors = color, is_percent = p, dec = d), legend=TRUE)
    })
    
    # Tab layout
    output$barchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("BARyear"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          plotlyOutput(ns("bar_chart"), height = h),
          tags$div(class = "chart_source", s)
        ),
      )
    }) 
  })  # end moduleServer
}

column_chart_transit_modes_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("columnchart"))
  )
}

column_chart_transit_modes_server <- function(id, df, ch, s) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$Transitmode})
    
    bus_df <- reactive({df |> filter(geography_type == "Region" & variable == "Bus" & grouping == "YTD" & metric == chart_metric())})
    commuter_df <- reactive({df |> filter(geography_type == "Region" & variable == "Commuter Rail" & grouping == "YTD" & metric == chart_metric())})
    demand_df <- reactive({df |> filter(geography_type == "Region" & variable == "Demand Response" & grouping == "YTD" & metric == chart_metric())})
    ferry_df <- reactive({df |> filter(geography_type == "Region" & variable == "Ferry" & grouping == "YTD" & metric == chart_metric())})
    rail_df <- reactive({df |> filter(geography_type == "Region" & variable == "Rail" & grouping == "YTD" & metric == chart_metric())})
    vanpool_df <- reactive({df |> filter(metric == chart_metric() & geography_type == "Region" & variable == "Vanpool" & grouping == "YTD")})
    
    # Charts & Maps
    output$bus_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = bus_df(), x = "year", y = "estimate", fill = "variable", colors = c("#F05A28")), legend=TRUE)
    })
    
    output$crt_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = commuter_df(), x = "year", y = "estimate", fill = "variable", colors = c("#00A7A0")), legend=TRUE)
    })
    
    output$dmd_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = demand_df(), x = "year", y = "estimate", fill = "variable", colors = c("#8CC63E")), legend=TRUE)
    })
    
    output$frr_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = ferry_df(), x = "year", y = "estimate", fill = "variable", colors = c("#91268F")), legend=TRUE)
    })
    
    output$rai_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = rail_df(), x = "year", y = "estimate", fill = "variable", colors = c("#4C4C4C")), legend=TRUE)
    })
    
    output$van_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = vanpool_df(), x = "year", y = "estimate", fill = "variable", colors = c("#9f3913")), legend=TRUE)
    })
    
    # Tab layout
    output$columnchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("Transitmode"), label = NULL, choices = ch, inline = TRUE)
          ),
          
          layout_columns(
            
            col_widths = c(4,4,4),
            plotlyOutput(ns("bus_chart")),
            plotlyOutput(ns("crt_chart")),
            plotlyOutput(ns("dmd_chart")),
            plotlyOutput(ns("frr_chart")),
            plotlyOutput(ns("rai_chart")),
            plotlyOutput(ns("van_chart"))
            
          ),
          
          tags$div(class = "chart_source", s)
        ),
      )
    }) 
  })  # end moduleServer
}
