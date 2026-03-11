value_box_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("summary_boxes"))
  )
}

value_box_server <- function(id, df) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Tab layout
    output$summary_boxes <- renderUI({
      layout_column_wrap(
        width = 1/4,
        
        value_box(
          title = df[[1]][[2]],
          value = df[[1]][[1]],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = df[[2]][[2]],
          value = df[[2]][[1]],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = df[[3]][[2]],
          value = df[[3]][[1]],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = df[[4]][[2]],
          value = df[[4]][[1]],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        )
      )
    })
    
  }) # end module server
  
}
