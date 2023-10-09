# Walk, Bike, & Roll Overview -----------------------------------------------------------------
mode_overview_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("modeoverview"))
  )
}

mode_overview_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text
    
    
    # Overview UI
    output$modeoverview <- renderUI({
      tagList(
       
      )
    })
  }) # end moduleServer
}

# Mode Tabs -----------------------------------------------------------------------------------
walk_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("walktab"))
  )
}

walk_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$commute_mode_walk_est_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Walked"),
                                                                                 y='estimate', x='geography', moe="estimate_moe", fill='data_year', pos = "dodge",
                                                                                 est="number", color='pgnobgy_10')})
    
    output$commute_mode_walk_share_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Walked"),
                                                                                   y='share', x='geography', moe="share_moe", fill='data_year', pos = "dodge",
                                                                                   est="percent", dec=1, color='pgnobgy_10')})
    
    # Tab layout
    output$walktab <- renderUI({
      tagList(
        fluidRow(column(6,strong(tags$div(class="chart_title","Number of People Making a Walk Commute by County"))),
                 column(6,strong(tags$div(class="chart_title","Share of People Making a Walk Commute by County")))),
        fluidRow(column(6,plotlyOutput(ns("commute_mode_walk_est_chart"))),
                 column(6,plotlyOutput(ns("commute_mode_walk_share_chart")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: US Census PUMS Data, 2011-2016 & 2017-2021")),
                 column(6,tags$div(class="chart_source","Source: US Census PUMS Data, 2011-2016 & 2017-2021"))),
        br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  }) # end moduleServer
}

bike_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("biketab"))
  )
}

bike_server <- function(id) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Text and charts
    output$commute_mode_bike_est_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Bicycle"),
                                                                                 y='estimate', x='geography', moe="estimate_moe", fill='data_year', pos = "dodge",
                                                                                 est="number", color='pgnobgy_10')})
    
    output$commute_mode_bike_share_chart <- renderPlotly({interactive_column_chart(t=data %>% filter(metric=="Simplified Commute Mode" & geography_type=="County" & variable=="Bicycle"),
                                                                                   y='share', x='geography', moe="share_moe", fill='data_year', pos = "dodge",
                                                                                   est="percent", dec=1, color='pgnobgy_10')})
    
    # Tab layout
    output$biketab <- renderUI({
      tagList(
        fluidRow(column(6,strong(tags$div(class="chart_title","Number of People Making a Bicycle Commute by County"))),
                 column(6,strong(tags$div(class="chart_title","Share of People Making a Bicycle Commute by County")))),
        fluidRow(column(6,plotlyOutput(ns("commute_mode_bike_est_chart"))),
                 column(6,plotlyOutput(ns("commute_mode_bike_share_chart")))),
        fluidRow(column(6,tags$div(class="chart_source","Source: US Census PUMS Data, 2011-2016 & 2017-2021")),
                 column(6,tags$div(class="chart_source","Source: US Census PUMS Data, 2011-2016 & 2017-2021"))),
        br(),
        hr(style = "border-top: 1px solid #000000;")
      )
    })
  }) # end moduleServer
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
    
    # Text and charts
    
    
    # Tab layout
    output$teleworktab <- renderUI({
      tagList(
        
      )
    })
  }) # end moduleServer
}
