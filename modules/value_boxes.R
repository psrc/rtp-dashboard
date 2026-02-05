value_box_registrations_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("registation_summary_boxes"))
  )
}

value_box_registrations_server <- function(id, df) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Box Titles
    output$bev_title <- renderUI(paste0(current_registration_year, " Electric Vehicle share of all vehicle purchases"))
    output$hev_title <- renderUI(paste0(current_registration_year, " Hybrid Vehicle share of all vehicle purchases"))
    output$phev_title <- renderUI(paste0(current_registration_year, " Plug-In Hybrid Vehicle share of all vehicle purchases"))
    output$ic_title <- renderUI(paste0(current_registration_year, " Internal-Combustion Vehicle share of all vehicle purchases"))
    
    # Box Values
    output$bev_value <- renderText({paste0(round((df |> filter(variable == "Battery Electric Vehicle") |> select("share") |> pull())*100, 1), "%")})
    output$hev_value <- renderText({paste0(round((df |> filter(variable == "Hybrid Electric Vehicle") |> select("share") |> pull())*100, 1), "%")})
    output$phev_value <- renderText({paste0(round((df |> filter(variable == "Plug-in Hybrid Electric Vehicle") |> select("share") |> pull())*100, 1), "%")})
    output$ic_value <- renderText({paste0(round((df |> filter(variable == "Internal Combustion Engine") |> select("share") |> pull())*100, 1), "%")})
    
    # Tab layout
    output$registation_summary_boxes <- renderUI({
      tagList(
        
        layout_column_wrap(
          width = 1/4,
          value_box(
            title = htmlOutput(ns("bev_title")), 
            value = textOutput(ns("bev_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"), 
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("hev_title")), 
            value = textOutput(ns("hev_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("phev_title")), 
            value = textOutput(ns("phev_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("ic_title")), 
            value = textOutput(ns("ic_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          )
        )
      ) 
      
    })  # end renderui
  }) # end module server
  
}

value_box_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("summary_boxes"))
  )
}

value_box_server <- function(
    id, df,
    by, bv,
    vy, vv,
    cy, cv,
    hy, hv,
    gr, ge, me,
    ti, fac, dec, s, val
) {
  
  moduleServer(id, function(input, output, session) {
    
    # ---- ONE cached computation ----
    summary_vals <- reactive({
      
      df |>
        filter(
          grouping %in% gr,
          geography == ge,
          metric == me,
          year %in% c(by, vy, cy, hy)
        ) |>
        mutate(
          box = case_when(
            year == by & variable == bv ~ "base",
            year == vy & variable == vv ~ "vision",
            year == cy & variable == cv ~ "current",
            year == hy & variable == hv ~ "horizon"
          )
        ) |>
        filter(!is.na(box)) |>
        select(box, value = all_of(val)) |>
        mutate(
          value = paste0(round(value * fac, dec), s)
        ) |>
        tibble::deframe()
      
    }) |>
      bindCache(by, vy, cy, hy, bv, vv, cv, hv, ge, me)
    
    # ---- ONE renderUI ----
    output$summary_boxes <- renderUI({
      vals <- summary_vals()
      
      layout_column_wrap(
        width = 1/4,
        
        value_box(
          title = paste(by, ti),
          value = vals["base"],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = paste(vy, ti),
          value = vals["vision"],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = paste(cy, ti),
          value = vals["current"],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        ),
        
        value_box(
          title = paste(hy, ti),
          value = vals["horizon"],
          theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
          align = "center",
          class = "value-box-outcomes"
        )
      )
    })
  })
}
