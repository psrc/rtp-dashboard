echarts4r::e_common(font_family = "Poppins")

# General Information -------------------------------------------------------------
page_information <- function(tbl, page_name, page_section=NULL, page_info) {
  
  if(is.null(page_section)) {
    
    t <- tbl |>
      filter(page == page_name) |>
      select(all_of(page_info)) |>
      pull()
    
  } else {
    
    t <- tbl |>
      filter(page == page_name & section == page_section) |>
      select(all_of(page_info)) |>
      pull()
    
  }
  
  
  if(is.na(t)) {f <- ""} else {f <- t}
  
  return(f)
  
}

# Maps -------------------------------------------------------------
create_share_map<- function(lyr, title, efa_lyr, efa_title, colors="Blues", dec=0) {
  
  # Replace any NaNs with zero in the share column
  lyr <- lyr |> mutate(share = replace_na(share, 0))
  
  # Determine Bins
  rng <- range(lyr$share)
  max_bin <- max(abs(rng))
  round_to <- 10^floor(log10(max_bin))
  max_bin <- ceiling(max_bin/round_to)*round_to
  breaks <- (max_bin*c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1))
  bins <- c(0, breaks)
  pal <- colorBin(colors, domain = lyr$share, bins = bins)
  
  labels <- paste0("<b>",paste0(title,": "), "</b>", prettyNum(round(lyr$share*100, dec), big.mark = ","),"%") |> lapply(htmltools::HTML)
  
  working_map <- leaflet(data = lyr) |>
    
    addProviderTiles(providers$CartoDB.Positron) |>
    
    addLayersControl(baseGroups = c("Base Map"),
                     overlayGroups = c(title,"Equity Focus Area"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    
    addPolygons(fillColor = pal(lyr$share),
                weight = 0.5,
                opacity = 0,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                highlight = highlightOptions(
                  weight =5,
                  color = "76787A",
                  dashArray ="",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto"),
                group = title) |>
    
    addPolygons(data = efa_lyr,
                fillColor = "#91268F",
                fillOpacity = 0,
                weight = 1,
                opacity = 1,
                color = "#91268F",
                dashArray = "3",
                group = "Equity Focus Area") |> 
    
    addLegend(colors=c("#91268F"),
              labels=c("Yes"),
              group = "Equity Focus Area",
              position = "bottomright",
              title = efa_title)
  
  return(working_map)
  
}

create_project_selection_map <- function(project_lyr) {
  
  funded_projects <- project_lyr |> filter(funded == "Yes")
  
  funded_project_lbl <- paste0("<b>", paste0("Project #: "), "</b>", funded_projects$project_id, "</br>",
                               "<b>", paste0("Project Sponsor: "), "</b>", funded_projects$sponsor, "</br>",
                               "<b>", paste0("Request: "), "</b>", "$", prettyNum(round(funded_projects$funding_request, 0), big.mark = ","), "</br>",
                               "<b>", paste0("Funded: "), "</b>", funded_projects$funded) %>% lapply(htmltools::HTML)
  
  unfunded_projects <- project_lyr |> filter(funded == "No")
  
  unfunded_project_lbl <- paste0("<b>", paste0("Project #: "), "</b>", unfunded_projects$project_id, "</br>",
                                 "<b>", paste0("Project Sponsor: "), "</b>", unfunded_projects$sponsor, "</br>",
                                 "<b>", paste0("Request: "), "</b>", "$", prettyNum(round(unfunded_projects$funding_request, 0), big.mark = ","), "</br>",
                                 "<b>", paste0("Funded: "), "</b>", unfunded_projects$funded) %>% lapply(htmltools::HTML)
  
  
  project_map <- leaflet(options = leafletOptions(zoomControl=FALSE)) |>
    
    addProviderTiles(providers$CartoDB.Positron) |>
    
    addLayersControl(baseGroups = c("Base Map"),
                     overlayGroups = c("Funded", "Not Funded"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    
    addEasyButton(easyButton(
      icon="fa-globe", title="Region",
      onClick=JS("function(btn, map){map.setView([47.615,-122.257],8.5); }"))) |>
    
    addPolylines(data = funded_projects,
                 color = "#630460",
                 weight = 4,
                 fillColor = "#630460",
                 group = "Funded",
                 label = funded_project_lbl) |>
    
    addPolylines(data = unfunded_projects,
                 color = "#AD5CAB",
                 weight = 4,
                 fillColor = "#AD5CAB",
                 group = "Not Funded",
                 label = unfunded_project_lbl)
  
  return(project_map)
  
}

create_tip_map <- function(project_lyr) {
  
  nonmotorized_projects <- project_lyr |> filter(Projects == "Pedestrian / Bicycle")
  its_projects <- project_lyr |> filter(Projects == "ITS")
  transit_projects <- project_lyr |> filter(Projects == "Transit")
  ferry_projects <- project_lyr |> filter(Projects == "Ferry")
  preservation_projects <- project_lyr |> filter(Projects == "Roadway Preservation")
  bridge_projects <- project_lyr |> filter(Projects == "Bridges")
  roadway_projects <- project_lyr |> filter(Projects == "Roadways")
  intersection_projects <- project_lyr |> filter(Projects == "Intersections")
  safety_projects <- project_lyr |> filter(Projects == "Safety")
  other_projects <- project_lyr |> filter(Projects == "Other")
  
  safety_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", safety_projects$`TIP ID`, "</br>",
                       "<b>", paste0("Project Sponsor: "), "</b>", safety_projects$Sponsor, "</br>",
                       "<b>", paste0("Project Type: "), "</b>", safety_projects$Projects, "</br>",
                       "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(safety_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                       "<b>", paste0("Completion Year: "), "</b>", safety_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  preservation_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", preservation_projects$`TIP ID`, "</br>",
                             "<b>", paste0("Project Sponsor: "), "</b>", preservation_projects$Sponsor, "</br>",
                             "<b>", paste0("Project Type: "), "</b>", preservation_projects$Projects, "</br>",
                             "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(preservation_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                             "<b>", paste0("Completion Year: "), "</b>", preservation_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  bridge_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", bridge_projects$`TIP ID`, "</br>",
                       "<b>", paste0("Project Sponsor: "), "</b>", bridge_projects$Sponsor, "</br>",
                       "<b>", paste0("Project Type: "), "</b>", bridge_projects$Projects, "</br>",
                       "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(bridge_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                       "<b>", paste0("Completion Year: "), "</b>", bridge_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  nonmotorized_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", nonmotorized_projects$`TIP ID`, "</br>",
                             "<b>", paste0("Project Sponsor: "), "</b>", nonmotorized_projects$Sponsor, "</br>",
                             "<b>", paste0("Project Type: "), "</b>", nonmotorized_projects$Projects, "</br>",
                             "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(nonmotorized_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                             "<b>", paste0("Completion Year: "), "</b>", nonmotorized_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  its_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", its_projects$`TIP ID`, "</br>",
                    "<b>", paste0("Project Sponsor: "), "</b>", its_projects$Sponsor, "</br>",
                    "<b>", paste0("Project Type: "), "</b>", its_projects$Projects, "</br>",
                    "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(its_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                    "<b>", paste0("Completion Year: "), "</b>", its_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)

  
  intersection_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", intersection_projects$`TIP ID`, "</br>",
                             "<b>", paste0("Project Sponsor: "), "</b>", intersection_projects$Sponsor, "</br>",
                             "<b>", paste0("Project Type: "), "</b>", intersection_projects$Projects, "</br>",
                             "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(intersection_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                             "<b>", paste0("Completion Year: "), "</b>", intersection_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  transit_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", transit_projects$`TIP ID`, "</br>",
                        "<b>", paste0("Project Sponsor: "), "</b>", transit_projects$Sponsor, "</br>",
                        "<b>", paste0("Project Type: "), "</b>", transit_projects$Projects, "</br>",
                        "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(transit_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                        "<b>", paste0("Completion Year: "), "</b>", transit_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  ferry_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", ferry_projects$`TIP ID`, "</br>",
                      "<b>", paste0("Project Sponsor: "), "</b>", ferry_projects$Sponsor, "</br>",
                      "<b>", paste0("Project Type: "), "</b>", ferry_projects$Projects, "</br>",
                      "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(ferry_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                      "<b>", paste0("Completion Year: "), "</b>", ferry_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  other_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", other_projects$`TIP ID`, "</br>",
                      "<b>", paste0("Project Sponsor: "), "</b>", other_projects$Sponsor, "</br>",
                      "<b>", paste0("Project Type: "), "</b>", other_projects$Projects, "</br>",
                      "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(other_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                      "<b>", paste0("Completion Year: "), "</b>", other_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  roadway_lbl <- paste0("<b>", paste0("TIP ID: "), "</b>", roadway_projects$`TIP ID`, "</br>",
                        "<b>", paste0("Project Sponsor: "), "</b>", roadway_projects$Sponsor, "</br>",
                        "<b>", paste0("Project Type: "), "</b>", roadway_projects$Projects, "</br>",
                        "<b>", paste0("Cost: "), "</b>", "$", prettyNum(round(roadway_projects$`Total Project Cost`, 0), big.mark = ","), "</br>",
                        "<b>", paste0("Completion Year: "), "</b>", roadway_projects$`Estimated Completion Year`) %>% lapply(htmltools::HTML)
  
  project_map <- leaflet(options = leafletOptions(zoomControl=FALSE)) |>
    
    addProviderTiles(providers$CartoDB.Positron) |>
    
    addLayersControl(baseGroups = c("Base Map"),
                     overlayGroups = c("Safety", "Roadway Preservation", "Bridges", 
                                       "Pedestrian / Bicycle", "ITS", "Intersections",
                                       "Transit", "Ferry", "Other",
                                       "Roadways", "Legend"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    
    addEasyButton(easyButton(
      icon="fa-globe", title="Region",
      onClick=JS("function(btn, map){map.setView([47.615,-122.257],8.5); }"))) |>
    
    addPolylines(data = safety_projects,
                 color = "#630460",
                 weight = 4,
                 fillColor = "#630460",
                 group = "Safety",
                 label = safety_lbl) |>
    
    addPolylines(data = preservation_projects,
                 color = "#9f3913",
                 weight = 4,
                 fillColor = "#9f3913",
                 group = "Roadway Preservation",
                 label = preservation_lbl) |>
    
    addPolylines(data = bridge_projects,
                 color = "#588527",
                 weight = 4,
                 fillColor = "#588527",
                 group = "Bridges",
                 label = bridge_lbl) |>
    
    addPolylines(data = nonmotorized_projects,
                 color = "#00716c",
                 weight = 4,
                 fillColor = "#00716c",
                 group = "Pedestrian / Bicycle",
                 label = nonmotorized_lbl) |>
    
    addPolylines(data = its_projects,
                 color = "#EB4584",
                 weight = 4,
                 fillColor = "#EB4584",
                 group = "ITS",
                 label = its_lbl) |>
    
    addPolylines(data = intersection_projects,
                 color = "#AD5CAB",
                 weight = 4,
                 fillColor = "#AD5CAB",
                 group = "Intersections",
                 label = intersection_lbl) |>
    
    addPolylines(data = transit_projects,
                 color = "#F4835E",
                 weight = 4,
                 fillColor = "#F4835E",
                 group = "Transit",
                 label = transit_lbl) |>
    
    addPolylines(data = ferry_projects,
                 color = "#A9D46E",
                 weight = 4,
                 fillColor = "#A9D46E",
                 group = "Ferry",
                 label = ferry_lbl) |>
    
    addPolylines(data = other_projects,
                 color = "#40BDB8",
                 weight = 4,
                 fillColor = "#40BDB8",
                 group = "Other",
                 label = other_lbl) |>
    
    addPolylines(data = roadway_projects,
                 color = "#3e4040",
                 weight = 4,
                 fillColor = "#3e4040",
                 group = "Roadway",
                 label = roadway_lbl) |>
    
    addLegend(colors=c("#630460", "#9f3913", "#588527", "#00716c", "#EB4584", "#AD5CAB", "#F4835E", "#A9D46E", "#40BDB8", "#3e4040"),
              labels=c("Safety", "Preservation", "Bridges", "Pedestrian / Bicycle", "ITS", "Intersections", "Transit", "Ferry", "Other", "Roadway"),
              position = "topleft",
              group = "Legend",
              title = "Project Types") |>
    
    setView(lng = -122.257, lat = 47.615, zoom = 8.5)
    
  
  return(project_map)
  
}

create_roadway_map <- function(congestion_lyr, tod) {
  
  heavy_lyr <- congestion_lyr |> filter(date == max(date)) |> select("roadway", estimate=all_of(tod)) |> filter(estimate > 0.25 & estimate <= 0.50)
  heavy_lbl <- paste0("<b>",paste0("Speed Ratio: "), "</b>", prettyNum(round(heavy_lyr$estimate*100, 0), big.mark = ","),"%") %>% lapply(htmltools::HTML)
  
  severe_lyr <- congestion_lyr |> filter(date == max(date)) |> select("roadway", estimate=all_of(tod)) |> filter(estimate <= 0.25)
  severe_lbl <- paste0("<b>",paste0("Speed Ratio: "), "</b>", prettyNum(round(severe_lyr$estimate*100, 0), big.mark = ","),"%") %>% lapply(htmltools::HTML)
  
  roadway_map <- leaflet() |>
    
    addProviderTiles(providers$CartoDB.Positron) |>
    
    addLayersControl(baseGroups = c("Base Map"),
                     overlayGroups = c("Heavy", "Severe"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    
    addEasyButton(easyButton(
      icon="fa-globe", title="Region",
      onClick=JS("function(btn, map){map.setView([47.615,-122.257],8.5); }"))) |>
    
    addPolylines(data = heavy_lyr,
                 color = "#91268F",
                 weight = 3,
                 fillColor = "#91268F",
                 group = "Heavy",
                 label = heavy_lbl) |>
    
    addPolylines(data = severe_lyr,
                 color = "#F05A28",
                 weight = 3,
                 fillColor = "#F05A28",
                 group = "Severe",
                 label = severe_lbl) |>
    
    addLegend(colors=c("#91268F", "#F05A28"),
              labels=c("Heavy", "Severe"),
              position = "bottomright",
              title = "Congestion")
  
  return(roadway_map)
  
}

# Line Charts -------------------------------------------------------------
echart_line_chart <- function(df, x, y, fill, tog, dec, esttype, color, y_min=0) {
  
  if (color == "blues") {chart_color <- psrcplot::psrc_colors$blues_inc}
  if (color == "greens") {chart_color <- psrcplot::psrc_colors$greens_inc}
  if (color == "oranges") {chart_color <- psrcplot::psrc_colors$oranges_inc}
  if (color == "purples") {chart_color <- psrcplot::psrc_colors$purples_inc}
  if (color == "jewel") {chart_color <- psrcplot::psrc_colors$pognbgy_5}
  
  # Determine the number of Series to Plot
  bar_fill_values <- df %>% 
    select(all_of(fill)) %>% 
    dplyr::distinct() %>% 
    dplyr::pull() %>% 
    unique
  
  chart_fill <- as.character(bar_fill_values)
  
  top_padding <- 100
  title_padding <- 75
  bottom_padding <- 75
  
  # If the value is a percentage, round differently
  ifelse(esttype == "percent", num_dec <- 4, num_dec <- dec)
  
  # Create the most basic chart
  chart_df <- df %>%
    dplyr::filter(.data[[fill]] %in% chart_fill) %>%
    dplyr::mutate(!!y:= round(.data[[y]], num_dec)) %>%
    dplyr::select(tidyselect::all_of(fill), tidyselect::all_of(x), tidyselect::all_of(y), tidyselect::all_of(tog)) %>%
    tidyr::pivot_wider(names_from = tidyselect::all_of(fill), values_from = tidyselect::all_of(y))
  
  c <- chart_df %>%
    dplyr::group_by(.data[[tog]]) %>%
    echarts4r::e_charts_(x, timeline = TRUE) %>%
    e_toolbox_feature("dataView") %>%
    e_toolbox_feature("saveAsImage")
  
  for(fill_items in chart_fill) {
    c <- c %>%
      echarts4r::e_line_(fill_items, smooth = FALSE)
  }
  
  c <- c %>% 
    echarts4r::e_color(chart_color) %>%
    echarts4r::e_grid(left = '15%', top = top_padding, bottom = bottom_padding) %>%
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) %>%
    echarts4r::e_show_loading() %>%
    echarts4r::e_legend(show = TRUE, bottom=0)
  
  # Add in the Timeseries Selector
  c <- c %>%
    echarts4r::e_timeline_opts(autoPlay = FALSE,
                               tooltip = list(show=FALSE),
                               axis_type = "category",
                               top = 15,
                               right = 200,
                               left = 200,
                               #currentIndex = 2,
                               controlStyle=FALSE,
                               lineStyle=FALSE,
                               label = list(show=TRUE,
                                            interval = 0,
                                            color='#4C4C4C',
                                            fontFamily = 'Poppins'),
                               itemStyle = list(color='#BCBEC0'),
                               checkpointStyle = list(label = list(show=FALSE),
                                                      color='#4C4C4C',
                                                      animation = FALSE),
                               progress = list(label = list(show=FALSE),
                                               itemStyle = list (color='#BCBEC0')),
                               emphasis = list(label = list(show=FALSE),
                                               itemStyle = list (color='#4C4C4C')))
  
  # Format the Axis and Hover Text
  if (esttype == "percent") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter("percent", digits = dec)) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter("percent", digits = 0)) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"percent\",\"minimumFractionDigits\":1,\"maximumFractionDigits\":1,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.seriesName + '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of percent format
  
  if (esttype == "currency") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter(style="currency", digits = dec, currency = "USD")) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter(style="currency", digits = 0, currency = "USD")) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"currency\",\"minimumFractionDigits\":0,\"maximumFractionDigits\":0,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return('<strong>' + params.seriesName '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of currency format
  
  if (esttype == "number") {
    c <- c %>%
      echarts4r::e_tooltip(trigger = "item")
  }
  
  c <- c |> echarts4r::e_y_axis(min=y_min)
  
  return(c)
  
}

# Column Charts -----------------------------------------------------------
echart_column_chart <- function(df, x, y, fill, title, dec, esttype, color) {
  
  # Determine the number of series to plot (fill values)
  fill_values <- df |> dplyr::select(tidyselect::all_of(fill)) |> dplyr::pull() |> unique()
  
  # If the value is a percentage, round differently
  ifelse(esttype == "percent", num_dec <- 4, num_dec <- dec)
  
  # Round data before it is transformed
  tbl <- df |> dplyr::mutate(!!y:= round(.data[[y]], num_dec))
  
  # Pivot Wider so that multiple values can be plotted on the X-Axis
  tbl <- tbl |>
    dplyr::select(tidyselect::all_of(c(x, y, fill))) |>
    tidyr::pivot_wider(names_from = metric, values_from = estimate)
  
  # Set padding for charts
  top_padding <- 100
  title_padding <- 75
  bottom_padding <- 75
  
  # Create the most basic chart
  c <- tbl |>
    echarts4r::e_charts_(x, timeline = FALSE) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  # Add a bar for each series
  for (s in fill_values) {
    
    c <- c |> echarts4r::e_bar_(s, name = s, stack = x)

  }
  
  c <- c |>
    echarts4r::e_color(color) |>
    echarts4r::e_grid(left = '15%', top = top_padding, bottom = bottom_padding) |>
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) |>
    echarts4r::e_show_loading() |>
    echarts4r::e_legend(show = TRUE, bottom=0) |>
    echarts4r::e_title(top = title_padding,
                       left = 'center',
                       textStyle = list(fontSize = 14),
                       text=title) 
  
  # Format the Axis and Hover Text
  if (esttype == "percent") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter("percent", digits = dec)) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter("percent", digits = 0)) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"percent\",\"minimumFractionDigits\":1,\"maximumFractionDigits\":1,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.seriesName + '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of percent format
  
  if (esttype == "currency") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter(style="currency", digits = dec, currency = "USD")) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter(style="currency", digits = 0, currency = "USD")) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"currency\",\"minimumFractionDigits\":0,\"maximumFractionDigits\":0,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return('<strong>' + params.seriesName '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of currency format
  
  if (esttype == "number") {
    c <- c %>%
      echarts4r::e_tooltip(trigger = "item")
  }
  
  return(c)
  
}

echart_multi_series_bar_chart <- function(df, x, y, fill, title, dec, esttype, color) {
  
  c <- echart_column_chart(df=df, x=x, y=y, fill=fill, title=title, dec=dec, esttype=esttype, color=color) 
  
  c <- c %>%
    e_flip_coords()
  
  return(c)
  
}

echart_bar_chart <- function(df, x, y, tog, title, dec, esttype, color) {
  
  # If the value is a percentage, round differently
  ifelse(esttype == "percent", num_dec <- 4, num_dec <- dec)
  
  top_padding <- 100
  title_padding <- 75
  bottom_padding <- 75
  
  # Create the most basic chart
  c <- df |>
    dplyr::mutate(!!y:= round(.data[[y]], num_dec)) |>
    dplyr::group_by(.data[[tog]]) |>
    echarts4r::e_charts_(x, timeline = TRUE) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  if (color == "blues") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#BFE9E7', '#73CFCB', '#40BDB8', '#00A7A0', '#00716c', '#005753'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "greens") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#E2F1CF', '#C0E095', '#A9D46E', '#8CC63E', '#588527', '#3f6618'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "oranges") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#FBD6C9', '#F7A489', '#F4835E', '#F05A28', '#9f3913', '#7a2700'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "purples") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#E3C9E3', '#C388C2', '#AD5CAB', '#91268F', '#630460', '#4a0048'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "jewel") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040','#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040', '#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  c <- c |> 
    echarts4r::e_grid(left = '20%', top = top_padding, bottom = bottom_padding) %>%
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) %>%
    echarts4r::e_show_loading() %>%
    echarts4r::e_legend(show = FALSE)
  
  # Add in the Timeseries Selector
  c <- c |>
    echarts4r::e_timeline_opts(autoPlay = FALSE,
                               tooltip = list(show=FALSE),
                               axis_type = "category",
                               top = 15,
                               right = 200,
                               left = 200,
                               #currentIndex = 2,
                               controlStyle=FALSE,
                               lineStyle=FALSE,
                               label = list(show=TRUE,
                                            interval = 0,
                                            color='#4C4C4C',
                                            fontFamily = 'Poppins'),
                               itemStyle = list(color='#BCBEC0'),
                               checkpointStyle = list(label = list(show=FALSE),
                                                      color='#4C4C4C',
                                                      animation = FALSE),
                               progress = list(label = list(show=FALSE),
                                               itemStyle = list (color='#BCBEC0')),
                               emphasis = list(label = list(show=FALSE),
                                               itemStyle = list (color='#4C4C4C')))
  
  
  # Format the Axis and Hover Text
  if (esttype == "percent") {
    c <- c |>
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter("percent", digits = dec)) |>
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter("percent", digits = 0)) |>
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"percent\",\"minimumFractionDigits\":1,\"maximumFractionDigits\":1,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.seriesName + '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of percent format
  
  if (esttype == "currency") {
    c <- c |>
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter(style="currency", digits = dec, currency = "USD")) |>
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter(style="currency", digits = 0, currency = "USD")) |>
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"currency\",\"minimumFractionDigits\":0,\"maximumFractionDigits\":0,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.marker + ' ' +\n
      params.seriesName + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of currency format
  
  if (esttype == "number") {
    c <- c |>
      echarts4r::e_tooltip(trigger = "item")
  }
  
  c <- c |>
    e_flip_coords()
  
  return(c)
  
}

echart_pictorial <- function(df, x, y, tog, icon, color, title, dec=0, esttype="decimal") {
  
  pic_chart <- df |> 
    mutate(!!y:= round(.data[[y]], dec)) |>
    arrange(.data[[y]]) |>
    e_charts_(x) |>
    e_color(color) |>
    e_tooltip() |>
    e_grid(left = '20%') |>
    e_pictorial_(serie = y, 
                 symbol = icon,
                 symbolRepeat = TRUE, z = -1,
                 symbolSize = 30,
                 legend = FALSE,
                 name=title) |>
    e_flip_coords() |>
    e_legend(show = FALSE) |>
    e_x_axis(splitLine=list(show = FALSE),
             formatter = e_axis_formatter(esttype, digits = 0)) |>
    e_y_axis(splitLine=list(show = FALSE),
             axisPointer = list(show = FALSE)) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  return(pic_chart)
  
}

echart_column_chart_timeline <- function(df, x, y, fill, tog, title, dec, esttype, color) {
  
  # If the value is a percentage, round differently
  ifelse(esttype == "percent", num_dec <- 4, num_dec <- dec)
  
  top_padding <- 100
  title_padding <- 75
  bottom_padding <- 75
  
  # Create the most basic chart
  c <- df |>
    dplyr::mutate(!!y:= round(.data[[y]], num_dec)) |>
    dplyr::group_by(.data[[tog]]) |>
    echarts4r::e_charts_(x, timeline = TRUE) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  if (color == "blues") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#BFE9E7', '#73CFCB', '#40BDB8', '#00A7A0', '#00716c', '#005753'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "greens") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#E2F1CF', '#C0E095', '#A9D46E', '#8CC63E', '#588527', '#3f6618'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "oranges") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#FBD6C9', '#F7A489', '#F4835E', '#F05A28', '#9f3913', '#7a2700'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "purples") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#E3C9E3', '#C388C2', '#AD5CAB', '#91268F', '#630460', '#4a0048'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  if (color == "jewel") {
    
    c <- c |>
      echarts4r::e_bar_(y, 
                        name = title,
                        itemStyle = list(color = htmlwidgets::JS("
                      function(params) {var colorList = ['#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040','#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040', '#91268F', '#F05A28', '#8CC63E', '#00A7A0', '#4C4C4C', '#630460', '#9f3913', '#588527', '#00716c', '#3e4040'];
                                                               return colorList[params.dataIndex]}"))) 
  }
  
  c <- c |> 
    echarts4r::e_grid(left = '20%', top = top_padding, bottom = bottom_padding) %>%
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) %>%
    echarts4r::e_show_loading() %>%
    echarts4r::e_legend(show = FALSE)
  
  # Add in the Timeseries Selector
  c <- c |>
    echarts4r::e_timeline_opts(autoPlay = FALSE,
                               tooltip = list(show=FALSE),
                               axis_type = "category",
                               top = 15,
                               right = 200,
                               left = 200,
                               #currentIndex = 2,
                               controlStyle=FALSE,
                               lineStyle=FALSE,
                               label = list(show=TRUE,
                                            interval = 0,
                                            color='#4C4C4C',
                                            fontFamily = 'Poppins'),
                               itemStyle = list(color='#BCBEC0'),
                               checkpointStyle = list(label = list(show=FALSE),
                                                      color='#4C4C4C',
                                                      animation = FALSE),
                               progress = list(label = list(show=FALSE),
                                               itemStyle = list (color='#BCBEC0')),
                               emphasis = list(label = list(show=FALSE),
                                               itemStyle = list (color='#4C4C4C')))
  
  
  # Format the Axis and Hover Text
  if (esttype == "percent") {
    c <- c |>
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter("percent", digits = dec)) |>
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter("percent", digits = 0)) |>
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"percent\",\"minimumFractionDigits\":1,\"maximumFractionDigits\":1,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.seriesName + '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of percent format
  
  if (esttype == "currency") {
    c <- c |>
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter(style="currency", digits = dec, currency = "USD")) |>
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter(style="currency", digits = 0, currency = "USD")) |>
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"currency\",\"minimumFractionDigits\":0,\"maximumFractionDigits\":0,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.marker + ' ' +\n
      params.seriesName + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of currency format
  
  if (esttype == "number") {
    c <- c |>
      echarts4r::e_tooltip(trigger = "item")
  }
  
  return(c)
  
}

# Data Download -----------------------------------------------------------
create_public_spreadsheet <- function(table_list) {
  
  hs <- createStyle(
    fontColour = "black",
    border = "bottom",
    fgFill = "#00a7a0",
    halign = "center",
    valign = "center",
    textDecoration = "bold"
  )
  
  table_idx <- 1
  sheet_idx <- 1
  
  wb <- createWorkbook()
  
  for (i in table_list) {
    for (j in names(table_list)) {
      if (names(table_list)[table_idx] == j) {
        
        addWorksheet(wb, sheetName = j)
        writeDataTable(wb, sheet = sheet_idx, x = i, tableStyle = "none", headerStyle = hs, withFilter = FALSE)
        setColWidths(wb, sheet = sheet_idx, cols = 1:length(i), widths = "auto")
        freezePane(wb, sheet = sheet_idx, firstRow = TRUE)
        
      } else {next}
    }
    if (table_idx < length(table_list)) {
      
      table_idx <- table_idx + 1
      sheet_idx <- sheet_idx + 1
      
    } else {break}
  }
  
  return(wb)

}

echart_column_chart_toggle <- function(df, x, y, fill, tog, title, dec, esttype, color) {
  
  # Determine the number of series to plot (fill values)
  fill_values <- df |> dplyr::select(tidyselect::all_of(fill)) |> dplyr::pull() |> unique()
  
  # If the value is a percentage, round differently
  ifelse(esttype == "percent", num_dec <- 4, num_dec <- dec)
  
  # Round data before it is transformed
  tbl <- df |> dplyr::mutate(!!y:= round(.data[[y]], num_dec))
  
  # Pivot Wider so that multiple values can be plotted on the X-Axis
  tbl <- tbl |>
    dplyr::select(tidyselect::all_of(c(x, y, fill, tog))) |>
    tidyr::pivot_wider(names_from = all_of(fill), values_from = all_of(y))
  
  # Set padding for charts
  top_padding <- 100
  title_padding <- 75
  bottom_padding <- 75
  
  # Create the most basic chart
  c <- tbl |>
    dplyr::group_by(.data[[tog]]) |>
    echarts4r::e_charts_(x, timeline = TRUE) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  # Add a bar for each series
  for (s in fill_values) {
    
    c <- c |> echarts4r::e_bar_(s, name = s, stack = x)
    
  }
  
  c <- c |>
    echarts4r::e_color(color) |>
    echarts4r::e_grid(left = '15%', top = top_padding, bottom = bottom_padding) |>
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) |>
    echarts4r::e_show_loading() |>
    echarts4r::e_legend(show = TRUE, bottom=0)
  
  # Add in the Timeseries Selector
  c <- c |>
    echarts4r::e_timeline_opts(autoPlay = FALSE,
                               tooltip = list(show=FALSE),
                               axis_type = "category",
                               top = 15,
                               right = 200,
                               left = 200,
                               #currentIndex = 2,
                               controlStyle=FALSE,
                               lineStyle=FALSE,
                               label = list(show=TRUE,
                                            interval = 0,
                                            color='#4C4C4C',
                                            fontFamily = 'Poppins'),
                               itemStyle = list(color='#BCBEC0'),
                               checkpointStyle = list(label = list(show=FALSE),
                                                      color='#4C4C4C',
                                                      animation = FALSE),
                               progress = list(label = list(show=FALSE),
                                               itemStyle = list (color='#BCBEC0')),
                               emphasis = list(label = list(show=FALSE),
                                               itemStyle = list (color='#4C4C4C')))
  
  # Format the Axis and Hover Text
  if (esttype == "percent") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter("percent", digits = dec)) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter("percent", digits = 0)) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"percent\",\"minimumFractionDigits\":1,\"maximumFractionDigits\":1,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return(params.seriesName + '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of percent format
  
  if (esttype == "currency") {
    c <- c %>%
      echarts4r::e_y_axis(formatter = echarts4r::e_axis_formatter(style="currency", digits = dec, currency = "USD")) %>%
      echarts4r::e_tooltip(trigger = "item", formatter =  echarts4r::e_tooltip_item_formatter(style="currency", digits = 0, currency = "USD")) %>%
      echarts4r::e_tooltip(formatter =  htmlwidgets::JS("
      function(params, ticket, callback) {
      var fmt = new Intl.NumberFormat('en',
      {\"style\":\"currency\",\"minimumFractionDigits\":0,\"maximumFractionDigits\":0,\"currency\":\"USD\"});\n
      var idx = 0;\n
      if (params.name == params.value[0]) {\n
      idx = 1;\n        }\n
      return('<strong>' + params.seriesName '<br>' + 
      params.marker + ' ' +\n
      params.name + ': ' + fmt.format(parseFloat(params.value[idx]))
      )
      }")
      )
    
  } # end of currency format
  
  if (esttype == "number") {
    c <- c %>%
      echarts4r::e_tooltip(trigger = "item")
  }
  
  return(c)
  
}

# Simple Charts -----------------------------------------------------------
echart_column_chart_simple <- function(df, x, fill, color) {
  
  # Set padding for charts
  top_padding <- 25
  bottom_padding <- 75
  
  # Create the most basic chart
  c <- df |>
    echarts4r::e_charts_(x, timeline = FALSE) |>
    e_toolbox_feature("dataView") |>
    e_toolbox_feature("saveAsImage")
  
  # Add a bar for each series
  for (s in fill) {
    
    c <- c |> echarts4r::e_bar_(s, name = s, stack = x)
    
  }
  
  c <- c |>
    echarts4r::e_color(color) |>
    echarts4r::e_grid(left = '15%', top = top_padding, bottom = bottom_padding) |>
    echarts4r::e_x_axis(axisTick=list(show = FALSE)) |>
    echarts4r::e_show_loading() |>
    echarts4r::e_legend(show = FALSE, bottom=0) |>
    echarts4r::e_tooltip(trigger = "item")
  
  return(c)
  
}

# Bar Chart ---------------------------------------------------------------
echart_bar_chart_simple <- function(df, x, fill, color) {
  
  c <- echart_column_chart_simple(df=df, x=x, fill=fill, color=color)
  
  c <- c %>%
    e_flip_coords()
  
  return(c)
  
}

# Tables ------------------------------------------------------------------

create_project_table <- function(df, data_cols, currency_cols) {
  
  num_cols <- length(data_cols) + 1
  clean_names <- str_replace_all(data_cols, "_", " ")
  clean_names <- str_to_title(clean_names)
  clean_names <- c(clean_names, "Funded")
  
  tbl <- df |> 
    mutate(Funded = case_when(
      is.na(center_Yes) ~ "No",
      !(is.na(center_Yes)) ~ "Yes")) |>
    select(all_of(data_cols), "Funded") |>
    arrange(as.integer(project_id))

  final_tbl <- datatable(tbl,
                         colnames = clean_names,
                         options = list(pageLength = 15,
                                        columnDefs = list(list(className = 'dt-center', targets=1:num_cols-1))),
                         filter = 'none',
                         rownames = FALSE) |>
    formatCurrency(currency_cols, "$", digits = 0)
  
  return(final_tbl)
  
}

create_tip_table <- function(df, data_cols=tip_cols, currency_cols=tip_currency_cols) {
  
  num_cols <- length(data_cols)
  
  tbl <- df |> select(all_of(data_cols)) |> arrange(`TIP ID`)
  
  final_tbl <- datatable(tbl,
                         options = list(pageLength = 15,
                                        columnDefs = list(list(className = 'dt-center', targets=1:num_cols-1))),
                         filter = 'none',
                         rownames = FALSE) |>
    formatCurrency(currency_cols, "$", digits = 0)
  
  return(final_tbl)
  
}

create_source_table <- function(d=source_info) {
  
  # Table with Titles as first row
  t <- rbind(names(d), d)
  
  headerCallbackRemoveHeaderFooter <- c(
    "function(thead, data, start, end, display){",
    "  $('th', thead).css('display', 'none');",
    "}"
  )
  
  summary_tbl <- datatable(t,
                           options = list(paging = FALSE,
                                          pageLength = 30,
                                          searching = FALSE,
                                          dom = 't',
                                          headerCallback = JS(headerCallbackRemoveHeaderFooter),
                                          columnDefs = list(list(targets = c(0,3), className = 'dt-left'))),
                           selection = 'none',
                           callback = JS(
                             "$('table.dataTable.no-footer').css('border-bottom', 'none');"
                           ),
                           class = 'row-border',
                           filter = 'none',              
                           rownames = FALSE,
                           escape = FALSE
  ) 
  
  # Add Section Breaks
  
  summary_tbl <- summary_tbl %>%
    formatStyle(0:ncol(t), valueColumns = "Data Point",
                `border-bottom` = styleEqual(c("Work from Home: City", 
                                               "Traffic Related Deaths and Serious Injuries: Day of Week", 
                                               "Population, Housing Units and Jobs: Near High Capacity Transit",
                                               "Transit Mode to Work: City",
                                               "Bike to Work: City",
                                               "Departure Time to Work: Metro Areas"), "solid 2px"))
  
  summary_tbl <- summary_tbl %>%
    formatStyle(0:ncol(t), valueColumns = "Data Point",
                `border-top` = styleEqual(c("Vehicle Registrations: Region"), "solid 2px"))
  
  return(summary_tbl)
  
}

create_summary_table <- function(d=summary_info) {
  
  # Table with Titles as first row
  t <- rbind(names(d), d)
  
  headerCallbackRemoveHeaderFooter <- c(
    "function(thead, data, start, end, display){",
    "  $('th', thead).css('display', 'none');",
    "}"
  )
  
  summary_tbl <- datatable(t,
                           options = list(paging = FALSE,
                                          pageLength = 30,
                                          searching = FALSE,
                                          dom = 't',
                                          headerCallback = JS(headerCallbackRemoveHeaderFooter),
                                          columnDefs = list(list(targets = c(0,2), className = 'dt-left'))),
                           selection = 'none',
                           callback = JS(
                             "$('table.dataTable.no-footer').css('border-bottom', 'none');"
                           ),
                           class = 'row-border',
                           filter = 'none',              
                           rownames = FALSE,
                           escape = FALSE
  ) 
  
  # Add Section Breaks
  
  summary_tbl <- summary_tbl %>%
    formatStyle(0:ncol(t), valueColumns = "Data Point",
                `border-bottom` = styleEqual(c("Working from Home", 
                                               "Traffic Related Deaths: Race and Ethnicity", 
                                               "Population, Housing Units and Jobs",
                                               "Transit Service Hours"), "solid 2px"))
  
  summary_tbl <- summary_tbl %>%
    formatStyle(0:ncol(t), valueColumns = "Data Point",
                `border-top` = styleEqual(c("Decarbonization of the Transportation Fleet"), "solid 2px"))
  
  return(summary_tbl)
  
}
