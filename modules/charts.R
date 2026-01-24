
bar_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("barchart"))
  )
}

bar_chart_server <- function(id, df, x, y, f, color, s, h) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Charts & Maps
    output$bar_chart <- renderPlotly({
      
      p <- psrc_make_interactive(psrc_bar_chart(df = df, x = x, y = y, fill = f, colors = color), legend=TRUE)
      
    })
    
    # Tab layout
    output$barchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          height = h,
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
      p <- psrc_make_interactive(psrc_column_chart(df = king_df(), x = "data_year", y = "estimate", fill = "geography", colors = c("#91268F")), legend=TRUE)
    })
    
    output$kitsap_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = kitsap_df(), x = "data_year", y = "estimate", fill = "geography", colors = c("#8CC63E")), legend=TRUE)
    })
    
    output$pierce_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = pierce_df(), x = "data_year", y = "estimate", fill = "geography", colors = c("#F05A28")), legend=TRUE)
    })
    
    output$snohomish_chart <- renderPlotly({
      p <- psrc_make_interactive(psrc_column_chart(df = snohomish_df(), x = "data_year", y = "estimate", fill = "geography", colors = c("#00A7A0")), legend=TRUE)
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
