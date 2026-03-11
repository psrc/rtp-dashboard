# Line Chart Functions ----------------------------------------------------
psrc_line_chart_share_plotly <- function(df) {
  
  plot_ly(
    data = df,
    x = ~x,
    y = ~y,
    color = ~f,
    colors = wcag_palette,
    type = "scatter",
    mode = "lines+markers",
    text = ~l,
    hoverinfo = "text",
    marker = list(size = 6),
    line = list(width = 2)
  ) |>
    layout(
      xaxis = list(
        title = "",
        tickfont = list(family="Poppins", size = 16)
      ),
      yaxis = list(
        title = "",
        tickformat = ".0%",
        tickfont = list(family="Poppins", size = 16),
        separatethousands = TRUE
      ),
      legend=list(
        orientation="h", 
        xanchor="center", 
        xref="container", 
        x=0.5, 
        y=-0.10,
        title="", 
        font=list(family="Poppins", size=20, color="black"),
        pad=list(b=50, t=50)),
      hovermode = "x unified",
      margin = list(t = 20, r = 20, b = 60, l = 60),
      hoverlabel = list(bgcolor = "#EDF9FF", font = list(size=16, color = "#2F3030", face="bold"))
    )
}

psrc_line_chart_total_plotly <- function(df) {
  
  plot_ly(
    data = df,
    x = ~x,
    y = ~y,
    color = ~f,
    colors = wcag_palette,
    type = "scatter",
    mode = "lines+markers",
    text = ~l,
    hoverinfo = "text",
    marker = list(size = 6),
    line = list(width = 2)
  ) |>
    layout(
      xaxis = list(
        title = "",
        tickfont = list(family="Poppins", size = 16)
      ),
      yaxis = list(
        title = "",
        tickfont = list(family="Poppins", size = 16),
        separatethousands = TRUE
      ),
      legend=list(
        orientation="h", 
        xanchor="center", 
        xref="container", 
        x=0.5, 
        y=-0.10,
        title="", 
        font=list(family="Poppins", size=20, color="black"),
        pad=list(b=50, t=50)),
      hovermode = "x unified",
      margin = list(t = 20, r = 20, b = 60, l = 60),
      hoverlabel = list(bgcolor = "#EDF9FF", font = list(size=16, color = "#2F3030", face="bold"))
    )
}

# Column Chart Functions --------------------------------------------------
psrc_column_chart_total_plotly <- function(df, colors, pos = "dodge", legend = TRUE, nt = 1) {
  
  # Create vertical chart
  p <- plot_ly(
    data = df,
    x = ~x,
    y = ~y,
    color = ~f,
    colors = colors,
    type = "bar",
    orientation = "v",
    text = ~l,
    hoverinfo = "text"
  )
  
  # handle dodge (grouped bars)
  if (pos == "dodge") {
    p <- layout(p, barmode = "group")
  } else {
    p <- layout(p, barmode = "stack")
  }
  
  p <- layout(
    p,
    showlegend = legend,
    
    yaxis = list(
      separatethousands = TRUE,
      tickfont = list(family="Poppins", size = 16),
      title = ""
    ),
    
    xaxis = list(
      title = "",
      tickfont = list(family="Poppins", size = 16),
      automargin = TRUE,
      dtick=nt
    ),
    
    legend = list(
      orientation = "h",
      xanchor = "center",
      x = 0.5,
      y = -0.10,
      title = list(text = ""),
      font = list(
        family = "Poppins",
        size = 20,
        color = "black"
      )
    ),
    
    hoverlabel = list(
      bgcolor = "#EDF9FF",
      font = list(
        size = 16,
        color = "#2F3030"
      )
    )
  )
  
  return(p)
}

psrc_column_chart_share_plotly <- function(df, colors, pos = "dodge", legend = TRUE, nt = 1) {

  # Create vertical chart
  p <- plot_ly(
    data = df,
    x = ~x,
    y = ~y,
    color = ~f,
    colors = colors,
    type = "bar",
    orientation = "v",
    text = ~l,
    hoverinfo = "text"
  )
  
  # handle dodge (grouped bars)
  if (pos == "dodge") {
    p <- layout(p, barmode = "group")
  } else {
    p <- layout(p, barmode = "stack")
  }
  
  p <- layout(
    p,
    showlegend = legend,
    
    yaxis = list(
      tickformat = ".0%",
      tickfont = list(family="Poppins", size = 16),
      title = ""
    ),
    
    xaxis = list(
      title = "",
      tickfont = list(family="Poppins", size = 16),
      automargin = TRUE,
      dtick=nt
    ),
    
    legend = list(
      orientation = "h",
      xanchor = "center",
      x = 0.5,
      y = -0.10,
      title = list(text = ""),
      font = list(
        family = "Poppins",
        size = 20,
        color = "black"
      )
    ),
    
    hoverlabel = list(
      bgcolor = "#EDF9FF",
      font = list(
        size = 16,
        color = "#2F3030"
      )
    )
  )
  
  return(p)
}

psrc_column_chart_share_plotly_auto <- function(df, colors, pos = "dodge", legend = TRUE) {
  
  # Create vertical chart
  p <- plot_ly(
    data = df,
    x = ~x,
    y = ~y,
    color = ~f,
    colors = colors,
    type = "bar",
    orientation = "v",
    text = ~l,
    hoverinfo = "text"
  )
  
  # handle dodge (grouped bars)
  if (pos == "dodge") {
    p <- layout(p, barmode = "group")
  } else {
    p <- layout(p, barmode = "stack")
  }
  
  p <- layout(
    p,
    showlegend = legend,
    
    yaxis = list(
      tickformat = ".0%",
      tickfont = list(family="Poppins", size = 16),
      title = ""
    ),
    
    xaxis = list(
      title = "",
      tickfont = list(family="Poppins", size = 16),
      automargin = TRUE
    ),
    
    legend = list(
      orientation = "h",
      xanchor = "center",
      x = 0.5,
      y = -0.10,
      title = list(text = ""),
      font = list(
        family = "Poppins",
        size = 20,
        color = "black"
      )
    ),
    
    hoverlabel = list(
      bgcolor = "#EDF9FF",
      font = list(
        size = 16,
        color = "#2F3030"
      )
    )
  )
  
  return(p)
}

# Bar Chart Functions -----------------------------------------------------
psrc_bar_chart_share_plotly <- function(df, colors, pos = "dodge", legend = TRUE) {
  
  df <- df |> 
    mutate(x = fct_reorder(x, y, .desc = FALSE))
  
  # Create horizontal chart
  p <- plot_ly(
    data = df,
    x = ~y,
    y = ~x,
    color = ~f,
    colors = colors,
    type = "bar",
    orientation = "h",
    text = ~l,
    hoverinfo = "text"
  )
  
  # handle dodge (grouped bars)
  if (pos == "dodge") {
    p <- layout(p, barmode = "group")
  } else {
    p <- layout(p, barmode = "stack")
  }
  
  p <- layout(
    p,
    showlegend = legend,
    
    xaxis = list(
      tickformat = ".0%",
      tickfont = list(family="Poppins", size = 15),
      title = ""
    ),
    
    yaxis = list(
      title = "",
      tickfont = list(family="Poppins", size = 15),
      automargin = TRUE
    ),
    
    legend = list(
      orientation = "h",
      xanchor = "center",
      x = 0.5,
      y = -0.10,
      title = list(text = ""),
      font = list(
        family = "Poppins",
        size = 20,
        color = "black"
      )
    ),
    
    hoverlabel = list(
      bgcolor = "#EDF9FF",
      font = list(
        size = 16,
        color = "#2F3030"
      )
    )
  )
  
  return(p)
}

psrc_bar_chart_total_plotly <- function(df, colors, pos = "dodge", legend = TRUE) {
  
  df <- df |> 
    mutate(x = fct_reorder(x, y, .desc = FALSE))
  
  # Create horizontal chart
  p <- plot_ly(
    data = df,
    x = ~y,
    y = ~x,
    color = ~f,
    colors = colors,
    type = "bar",
    orientation = "h",
    text = ~l,
    hoverinfo = "text"
  )
  
  # handle dodge (grouped bars)
  if (pos == "dodge") {
    p <- layout(p, barmode = "group")
  } else {
    p <- layout(p, barmode = "stack")
  }
  
  p <- layout(
    p,
    showlegend = legend,
    
    xaxis = list(
      separatethousands = TRUE,
      tickfont = list(family="Poppins", size = 15),
      title = ""
    ),
    
    yaxis = list(
      title = "",
      tickfont = list(family="Poppins", size = 15),
      automargin = TRUE
    ),
    
    legend = list(
      orientation = "h",
      xanchor = "center",
      x = 0.5,
      y = -0.10,
      title = list(text = ""),
      font = list(
        family = "Poppins",
        size = 20,
        color = "black"
      )
    ),
    
    hoverlabel = list(
      bgcolor = "#EDF9FF",
      font = list(
        size = 16,
        color = "#2F3030"
      )
    )
  )
  
  return(p)
}

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
create_share_map<- function(lyr, title, colors="Blues", dec=0) {
  
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
    
    addTiles(group = "Open Street Map") |>
    
    addProviderTiles(providers$CartoDB.Positron, group = "Positron (minimal)") |>
    
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
    
    
    addLayersControl(baseGroups = c("Positron (minimal)", "Open Street Map","Satellite"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    
    addEasyButton(easyButton(
      icon="fa-globe", title="Region",
      onClick=JS("function(btn, map){map.setView([47.615,-122.257],7.5); }"))) |>
    
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
                  direction = "auto")) |>

    setView(lng = -122.257, lat = 47.615, zoom = 7.5)
  
  return(working_map)
  
}

create_roadway_map <- function(congestion_lyr) {
  
  heavy_lyr <- congestion_lyr |> filter(grouping == "Heavy")
  severe_lyr <- congestion_lyr |> filter(grouping == "Severe")
  
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
                 label = heavy_lyr$l) |>
    
    addPolylines(data = severe_lyr,
                 color = "#F05A28",
                 weight = 3,
                 fillColor = "#F05A28",
                 group = "Severe",
                 label = severe_lyr$l) |>
    
    addLegend(colors=c("#91268F", "#F05A28"),
              labels=c("Heavy", "Severe"),
              position = "bottomright",
              title = "Congestion")
  
  return(roadway_map)
  
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

# Tables ------------------------------------------------------------------

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
                                               "NHS Congestion by AM & PM Peak Period: Facility"),
                                             "solid 2px"))
  
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
                                               "Traffic Related Deaths: Rural areas", 
                                               "Population, Housing Units and Jobs",
                                               "Transit Service Hours",
                                               "Walking to Work",
                                               "Commute Times"), "solid 2px"))
  
  summary_tbl <- summary_tbl %>%
    formatStyle(0:ncol(t), valueColumns = "Data Point",
                `border-top` = styleEqual(c("Decarbonization of the Transportation Fleet"), "solid 2px"))
  
  return(summary_tbl)
  
}
