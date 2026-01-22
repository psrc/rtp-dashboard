
bar_chart_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("barchart"))
  )
}

bar_chart_server <- function(id, df, m, v, g, gt, color) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    period_metric <- reactive({input$NTDPeriod})
    
    num_dec <- reactive({
      if (m() != "Boardings-per-Hour") {-2} else {1}
    })

    filtered_df <- reactive({df |> filter(variable == v() & geography == g() & geography_type == gt() & metric == m() & grouping == period_metric())})
    
    # Charts & Maps
    output$ntd_region_chart <- renderPlotly({
      
      p <- psrc_make_interactive(psrc_column_chart(df = filtered_df(), x = "year", y = "estimate", fill = "metric", colors = color, dec = num_dec()), legend=TRUE)
      
      # Use onRender to apply JavaScript for responsiveness
      p %>% onRender("
      function(el, x) {
        
        el.setAttribute('aria-label', 'Bar chart of transit metrics for all transit modes for all transit oeprators in the Central Puget Sound Region');
      
        var resizeLabels = function() {
          var layout = el.layout;
          var width = el.clientWidth;
          var fontSize = width < 600 ? 12 : width < 800 ? 14 : 16;
          var numTicks = width < 600 ? 3 : width < 800 ? 2 : 1;
          var legendSize = width < 600 ? 12 : width < 800 ? 14 : 16;
          
          layout.xaxis = { dtick: numTicks };
          layout.xaxis.tickfont = { size: fontSize};
          layout.yaxis.tickfont = { size: fontSize };
          layout.legend.font = {size: legendSize};
          
          Plotly.relayout(el, layout);
        };
        
        // Run the function initially and on window resize
        resizeLabels();
        window.addEventListener('resize', resizeLabels);
      }
    ")
      
    })
    
    # Tab layout
    output$barchart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("NTDPeriod"), label = NULL, choices = c(paste0("Year to Date: Jan-",latest_ntd_month), "Annual"), inline = TRUE)
            ),
          
          plotlyOutput(ns("ntd_region_chart"))
        ),

        br(),
        
        tags$div(class = "chart_source", "Source: USDOT Federal Transit Administration (FTA) National Transit Database (NTD)"),
        
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

line_chart_server <- function(id, df, m, v, g, color, d) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    chart_metric <- reactive({input$REGISTRATIONtype})
    filtered_df <- reactive({df |> filter(variable %in% v & geography == g & metric == m & grouping == chart_metric())})
    
    # Charts & Maps
    output$region_line_chart <- renderPlotly({
      
      p <- psrc_make_interactive(psrc_line_chart(df = filtered_df(), x = "date", y = "share", fill = "variable", labels=scales::label_percent(), colors = color, dec = 1, is_date = d), legend=TRUE)
      
    })
    
    # Tab layout
    output$linechart <- renderUI({
      tagList(
        
        card(
          full_screen = FALSE,
          
          layout_column_wrap(
            width = 1,
            radioButtons(ns("REGISTRATIONtype"), label = NULL, choices = c("New", "Used"), inline = TRUE)
          ),
          
          plotlyOutput(ns("region_line_chart"))
        ),
        
        br(),
        
        tags$div(class = "chart_source", "Source: Washington State Department on Licensing"),
        
      )
    }) 
  })  # end moduleServer
}
