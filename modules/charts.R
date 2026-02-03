
bar_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("barchart"))
  )
}

bar_chart_server <- function(id, df, x, y, f, color, s, h, ch, p, d) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Charts & Maps
    output$bar_chart <- renderPlotly({
      
      chart_metric <- reactive({input$BARyear})
      p <- psrc_make_interactive(psrc_bar_chart(df = df, x = x, y = y, fill = f, colors = color, is_percent = p, dec = d), legend=TRUE)
      
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
          
          #height = h,
          plotlyOutput(ns("bar_chart"))
        ),

        br(),
        
        tags$div(class = "chart_source", s),
        
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
          
          plotlyOutput(ns("region_line_chart"))
        ),
        
        br(),
        
        tags$div(class = "chart_source", s),
        
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
          
        ),
        
        br(),
        
        tags$div(class = "chart_source", s),
        
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
            plotlyOutput(ns("county_chart"))
            
          ),
          
        ),
        
        br(),
        
        tags$div(class = "chart_source", s),
        
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
          
        ),
        
        br(),
        
        tags$div(class = "chart_source", s),
        
      )
    }) 
  })  # end moduleServer
}