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

value_box_vmt_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("summary_boxes"))
  )
}

value_box_vmt_server <- function(id, df) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Box Titles
    output$base_title <- renderUI(paste0(climate_base_year, " daily vehicle miles per capita"))
    output$vision_title <- renderUI(paste0(climate_vision_year, " daily vehicle miles per capita"))
    output$current_title <- renderUI(paste0(climate_vmt_year, " daily vehicle miles per capita"))
    output$horizon_title <- renderUI(paste0(climate_horizon_year, " daily vehicle miles per capita"))
    
    # Box Values
    output$base_value <- renderText({paste0(round((df |> filter(data_year == climate_base_year & grouping == "per Capita" & variable == "Observed" & geography == "Region") |> select("estimate") |> pull())*1, 1))})
    output$vision_value <- renderText({paste0(round((df |> filter(data_year == climate_vision_year & grouping == "per Capita" & variable == "Observed" & geography == "Region") |> select("estimate") |> pull())*1, 1))})
    output$current_value <- renderText({paste0(round((df |> filter(data_year == climate_vmt_year & grouping == "per Capita" & variable == "Observed" & geography == "Region") |> select("estimate") |> pull())*1, 1))})
    output$horizon_value <- renderText({paste0(round((df |> filter(data_year == climate_horizon_year & grouping == "per Capita" & variable == "Forecast" & geography == "Region") |> select("estimate") |> pull())*1, 1))})
    
    # Tab layout
    output$summary_boxes <- renderUI({
      tagList(
        
        layout_column_wrap(
          width = 1/4,
          value_box(
            title = htmlOutput(ns("base_title")), 
            value = textOutput(ns("base_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"), 
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("vision_title")), 
            value = textOutput(ns("vision_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("current_title")), 
            value = textOutput(ns("current_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("horizon_title")), 
            value = textOutput(ns("horizon_value")),
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







value_box_ntd_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("ntd_summary_boxes"))
  )
}

value_box_ntd_server <- function(id, df, m, v, g, gt, gr) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    filtered_df <- reactive(df |> filter(variable == v() & geography == g() & geography_type == gt() & metric == m() & grouping == gr))
    
    # Output Values
    output$pre_pandemic_title <- renderUI(paste0(pre_pandemic, " YTD ", m()))
    output$current_title <- renderUI(paste0(current_year," YTD ", m()))
    output$pandemic_share_title <- renderUI(paste0("% of ", pre_pandemic, " YTD ", m()))
    output$recent_share_title <- renderUI(paste0("% change from ", base_yr))
    
    output$pre_pandemic_value <- renderText({
      if (m() == "Boardings-per-Hour") {
        paste0(round((filtered_df() |> filter(year == pre_pandemic) |> select("estimate") |> pull()), 1))
      } else {
        paste0(round((filtered_df() |> filter(year == pre_pandemic) |> select("estimate") |> pull())/1000000, 1), "M")
      }
    })
    
    output$current_value <- renderText({
      if(m() == "Boardings-per-Hour") {
        paste0(round((filtered_df() |> filter(year == current_year) |> select("estimate") |> pull()), 1))
      } else {
        paste0(round((filtered_df() |> filter(year == current_year) |> select("estimate") |> pull())/1000000, 1), "M")  
      }
    })
    
    output$pre_pandemic_share <- renderText(paste0(round((filtered_df() |> filter(year == current_year) |> select("estimate") |> pull()) / (filtered_df() |> filter(year == pre_pandemic) |> select("estimate") |> pull()), 3)*100, "%"))
    
    output$recent_growth <- renderText(paste0(round((filtered_df() |> filter(year == current_year) |> select("estimate") |> pull()) / (filtered_df() |> filter(year == base_yr) |> select("estimate") |> pull())*100-100, 1), "%"))
    
    # Tab layout
    output$ntd_summary_boxes <- renderUI({
      tagList(
        
        layout_column_wrap(
          width = 1/4,
          value_box(
            title = htmlOutput(ns("pre_pandemic_title")), 
            value = textOutput(ns("pre_pandemic_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"), 
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("current_title")), 
            value = textOutput(ns("current_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("pandemic_share_title")), 
            value = textOutput(ns("pre_pandemic_share")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("recent_share_title")), 
            value = textOutput(ns("recent_growth")),
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

# Value boxes summarizing access from GTFS data ---------------------------

value_box_access_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("access_summary_boxes"))
  )
}

value_box_access_server <- function(id, df, bm, bd, em) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    filtered_df <- reactive({
      df |> 
        filter(transit_buffer == bm() & buffer == bd()) |> 
        select("year", !(contains("share"))) |>
        pivot_longer(cols = !c(year, transit_buffer)) |>
        mutate(year = as.character(year), 
               name = str_remove_all(name, "_share"),
               name = str_replace_all(name, "population", "People"),
               name = str_replace_all(name, "poc", "People of Color"),
               name = str_replace_all(name, "pov", "People with Lower Incomes"),
               name = str_replace_all(name, "lep", "People with Limited English"),
               name = str_replace_all(name, "yth", "People under 18"),
               name = str_replace_all(name, "old", "People over 65"),
               name = str_replace_all(name, "dis", "People with a Disability")) |>
        filter(name %in% c(em()))
    })
    
    stop_dist <- reactive({
      if (bd() == 0.25) {"1/4 mile"} else {"1/2 mile"}
    })
    
    # Value Box Titles
    output$pre_pandemic_title <- renderUI(paste0(em()," in ", pre_pandemic, " lived within a ", stop_dist(), " of a ", bm(), " stop"))
    output$current_title <- renderUI(paste0(em()," in ", gtfs_year, " lived within a ", stop_dist(), " of a ", bm(), " stop"))
    output$pandemic_share_title <- renderUI(paste0("% change from ", pre_pandemic))
    output$recent_share_title <- renderUI(paste0("% change from ", base_yr))
    
    # Value Box Values
    output$pre_pandemic_value <- renderText({format(round((filtered_df() |> filter(year == as.numeric(pre_pandemic)) |> select("value") |> pull()), -1), nsmall=0, big.mark=",")})
    output$current_value <- renderText({format(round((filtered_df() |> filter(year == current_year) |> select("value") |> pull()), -1), nsmall=0, big.mark=",")})
    output$pre_pandemic_share <- renderText({paste0(round(((filtered_df() |> filter(year == current_year) |> select("value") |> pull()) / (filtered_df() |> filter(year == as.numeric(pre_pandemic)) |> select("value") |> pull()))*100-100, 0),"%")})
    output$recent_growth <- renderText({paste0(round(((filtered_df() |> filter(year == current_year) |> select("value") |> pull()) / (filtered_df() |> filter(year == as.numeric(base_yr)) |> select("value") |> pull()))*100-100, 1),"%")})
    
    # Tab layout
    output$access_summary_boxes <- renderUI({
      tagList(
        
        layout_column_wrap(
          width = 1/4,
          value_box(
            title = htmlOutput(ns("pre_pandemic_title")), 
            value = textOutput(ns("pre_pandemic_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"), 
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("current_title")), 
            value = textOutput(ns("current_value")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("pandemic_share_title")), 
            value = textOutput(ns("pre_pandemic_share")),
            theme = value_box_theme(bg = "#EDF9FF", fg = "#0B4B6E"),
            showcase = NULL, showcase_layout = "left center",
            full_screen = FALSE, fill = TRUE, height = NULL, align = "center",
            class = "value-box-outcomes"
          ),
          value_box(
            title = htmlOutput(ns("recent_share_title")), 
            value = textOutput(ns("recent_growth")),
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




