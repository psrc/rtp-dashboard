psrc_style <- function() {
  font <- "Poppins"
  
  ggplot2::theme(
    
    #Text format:
    #This sets the font, size, type and color of text for the chart's title
    plot.title = ggplot2::element_text(family=font,
                                       face="bold",
                                       size=13, 
                                       color='#4C4C4C'),
    plot.title.position = "plot",
    
    #This sets the font, size, type and color of text for the chart's subtitle, as well as setting a margin between the title and the subtitle
    plot.subtitle = ggplot2::element_text(family=font,
                                          size=12,
                                          margin=ggplot2::margin(9,0,9,0)),
    
    #This leaves the caption text element empty, because it is set elsewhere in the finalise plot function
    plot.caption =  ggplot2::element_text(family=font,
                                          size=10,
                                          face="italic",
                                          color="#4C4C4C",
                                          hjust=0),
    plot.caption.position = "plot",
    
    #Legend format
    #This sets the position and alignment of the legend, removes a title and background for it and sets the requirements for any text within the legend.
    legend.position = "bottom",
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(family=font,
                                        size=12,
                                        color="#4C4C4C"),
    
    #Axis format
    #This sets the text font, size and colour for the axis test, as well as setting the margins and removes lines and ticks. In some cases, axis lines and axis ticks are things we would want to have in the chart - the cookbook shows examples of how to do so.
    axis.title = ggplot2::element_text(family=font, size=12, color="#2f3030"),
    axis.text = ggplot2::element_text(family=font, size=11, color="#2f3030"),
    axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    
    #Grid lines
    #This removes all minor gridlines and adds major y gridlines. In many cases you will want to change this to remove y gridlines and add x gridlines.
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color="#cbcbcb"),
    panel.grid.major.x = ggplot2::element_blank(),
    
    #Blank background
    #This sets the panel background as blank, removing the standard grey ggplot background color from the plot
    panel.background = ggplot2::element_blank(),
    
    #Strip background sets the panel background for facet-wrapped plots to PSRC Gray and sets the title size of the facet-wrap title
    strip.background = ggplot2::element_rect(fill="#BCBEC0"),
    strip.text = ggplot2::element_text(size  = 12,  hjust = 0)
  )
}

psrc_infogram_style <- function() {
  font <- "Poppins"
  
  ggplot2::theme(
    
    #Text format:
    #This sets the font, size, type and color of text for the chart's title
    plot.title = ggplot2::element_text(family=font,
                                       face="bold",
                                       size=16, 
                                       color='black'),
    plot.title.position = "plot",
    
    #This sets the font, size, type and color of text for the chart's subtitle, as well as setting a margin between the title and the subtitle
    plot.subtitle = ggplot2::element_text(family=font,
                                          color='black',
                                          size=14,
                                          margin=ggplot2::margin(9,0,9,0)),
    
    #This sets the caption text element
    plot.caption =  ggplot2::element_text(family=font,
                                          size=12,
                                          face="plain",
                                          color='black',
                                          hjust=0),
    plot.caption.position = "plot",
    
    #Legend format
    #This sets the position and alignment of the legend, removes a title and background for it and sets the requirements for any text within the legend.
    legend.position = "bottom",
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(family=font,
                                        size=14,
                                        color="black"),
    
    #Axis format
    #This sets the text font, size and colour for the axis test, as well as setting the margins and removes lines and ticks. In some cases, axis lines and axis ticks are things we would want to have in the chart - the cookbook shows examples of how to do so.
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(family=font, size=12, color="black"),
    axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    
    #Grid lines
    #This removes all minor gridlines and adds major y gridlines. In many cases you will want to change this to remove y gridlines and add x gridlines.
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(linewidth = 0.2, color="#BCBEC0"),
    panel.grid.major.x = ggplot2::element_line(linewidth = 0.2, color="#BCBEC0"),
    
    #Blank background
    #This sets the panel background as blank, removing the standard grey ggplot background color from the plot
    panel.background = ggplot2::element_blank(),
    
    
  )
}

psrc_column_chart <- function(df, x, y, fill, colors, dec=0, chart_style=psrc_infogram_style(), title=NULL, source=NULL, pos="dodge", legend = TRUE, is_percent = "no") {
  
  # Set the axis labels, maximum value for y axis and hoverlabel options
  if (is_percent == "yes") {
    l <- scales::label_percent()
    suff <- "%"
    fact <- 100
  }
  else {
    l <- scales::label_comma()
    suff <- ""
    fact <- 1
  }
  
  c <- ggplot(data=df,
              aes(x=.data[[x]],
                  y=.data[[y]],
                  fill=.data[[fill]],
                  text = paste0(.data[[x]], ": ", format(round(.data[[y]]*fact, dec), nsmall=0, big.mark=","), suff)))  + 
    geom_bar(position=pos, stat="identity", na.rm=TRUE) +
    scale_fill_manual(values = colors) +
    scale_y_continuous(labels = l, expand=expansion(mult = c(0, .2)))  +   # expand is to accommodate value labels
    labs(title=title, caption=source) +
    chart_style
  
  if (legend == FALSE) {
    
    c <- c + theme(legend.position = "none")
  }
  
  return (c)
}

psrc_bar_chart <- function(df, x, y, fill, colors, dec=0, chart_style=psrc_infogram_style(), title=NULL, source=NULL, pos="dodge", legend = TRUE, is_percent = "no") {
  
  df <- df |> mutate(!!x := fct_reorder(.data[[x]], .data[[y]], .desc = FALSE))
  
  # Set the axis labels, maximum value for y axis and hoverlabel options
  if (is_percent == "yes") {
    l <- scales::label_percent()
    suff <- "%"
    fact <- 100
  }
  else {
    l <- scales::label_comma()
    suff <- ""
    fact <- 1
  }
  
  c <- ggplot(data=df,
              aes(x=.data[[x]],
                  y=.data[[y]],
                  fill=.data[[fill]],
                  text = paste0(.data[[x]], ": ", format(round(.data[[y]]*fact, dec), nsmall=0, big.mark=","), suff)))  + 
    geom_bar(position=pos, stat="identity", na.rm=TRUE) +
    scale_fill_manual(values = colors) +
    scale_y_continuous(labels = l, expand=expansion(mult = c(0, 0)))  +   # expand is to accommodate value labels
    labs(title=title, caption=source) +
    chart_style
  
  c <- c + coord_flip()
  
  if (legend == FALSE) {
    
    c <- c + theme(legend.position = "none")
  }
  
  return (c)
}

psrc_line_chart <- function(df, x, y, fill, lwidth=1, colors, dec=0, breaks=NULL, title=NULL, source=NULL, legend = TRUE, chart_style=psrc_infogram_style(), is_date = "no", is_percent = "no") {
  
  # Set the axis labels, maximum value for y axis and hoverlabel options
  if (is_percent == "yes") {
    l <- scales::label_percent()
    ymax <- 1
    suff <- "%"
    fact <- 100
    }
  else {
    l <- scales::label_comma()
    ymax <- df |> select(all_of(y)) |> pull() |> max()
    suff <- ""
    fact <- 1
    }

  if (is_date == "yes") {
    
    c <- ggplot(data=df,
                aes(x=.data[[x]],
                    y=.data[[y]],
                    group=.data[[fill]],
                    color=.data[[fill]],
                    text = paste0(.data[[fill]], ": ", format(round(.data[[y]]*fact, dec), nsmall=0, big.mark=","), suff)))  + 
      geom_line(linewidth=lwidth, linejoin = "round", na.rm=TRUE) +
      geom_point(fill = "white", shape = 21, stroke = 0.5) +
      scale_color_manual(values = colors)  +
      scale_y_continuous(labels = l, limits = c(0, ymax))  +   
      labs(title=title, caption=source) +
      scale_x_date(date_breaks = "12 month", date_labels =  "%b %Y") +
      chart_style
    
  } else {
    
    c <- ggplot(data=df,
                aes(x=.data[[x]],
                    y=.data[[y]],
                    group=.data[[fill]],
                    color=.data[[fill]],
                    text = paste0(.data[[fill]], ": ", format(round(.data[[y]]*fact, dec), nsmall=0, big.mark=","), suff)))  + 
      geom_line(linewidth=lwidth, linejoin = "round", na.rm=TRUE) +
      geom_point(fill = "white", shape = 21, stroke = 0.5) +
      scale_color_manual(values = colors)  +
      scale_y_continuous(labels = l, limits = c(0, ymax))  +   
      labs(title=title, caption=source) +
      scale_x_continuous(n.breaks=breaks) +
      chart_style
    
  }
  
  
  return(c)
  
}

psrc_mepeople_chart <- function(df, per_icons, val, grp, icon_pth, icon_clr, data_max, chart_style=psrc_infogram_style()) {
  
  df <- df |>
    mutate(icon = icon_pth, !!grp := reorder(.data[[grp]], .data[[val]])) |>
    select(all_of(grp), all_of(val), "icon")
  
  df_people <- df |>
    mutate(n_icons = round(.data[[val]] * 100/per_icons)) |>
    uncount(n_icons) |>
    group_by(.data[[grp]]) |>
    mutate(x = row_number()*per_icons) |>
    ungroup()
  
  df_labels <- df_people |>
   mutate(!!val := round(.data[[val]],3)) |>
   group_by(.data[[grp]]) |>
   filter(x == max(x)) |>
   ungroup() |>
   mutate(label = scales::percent(.data[[val]]))
  
  c <- ggplot(df_people, aes(
    x = x, 
    y = .data[[grp]], 
    image = icon)) +
    geom_image(
      image = icon_pth,
      size = 0.08,
      color = icon_clr) +
    geom_text(
     data = df_labels,
     aes(x = x + 3,
         y = .data[[grp]],
         label = label),
     hjust = 0,
     vjust = 0.5,
     size = 6,
     fontface = "bold"
    ) +
    scale_x_continuous(
      limits = c(0,data_max), 
      breaks = seq(0, data_max, data_max/5), 
      labels = scales::percent_format(scale = 1)) +
    chart_style +
    theme(
      panel.grid.major.y = element_blank(),
      axis.text = element_text(size=16, color="black"),
    )
  
  return(c)
  
}

psrc_make_interactive <- function(plot_obj, legend=FALSE, hover=y) {
  
  c <- plotly::ggplotly(plot_obj, tooltip = "text")
  
  c <- plotly::layout(c,
                      showlegend = legend,
                      legend=list(orientation="h", xanchor="center", xref="container", x=0.5, y=-0.10,         
                                  title="", font=list(family="Poppins", size=20, color="black"),
                                  pad=list(b=50, t=50)),
                      hoverlabel = list(bgcolor = "#EDF9FF", font = list(size=16, color = "#2F3030", face="bold"))
                      )
  
  return(c)
  
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
    
    addTiles(group = "Open Street Map") |>
    
    addProviderTiles(providers$CartoDB.Positron, group = "Positron (minimal)") |>
    
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
    
    
    addLayersControl(baseGroups = c("Positron (minimal)", "Open Street Map","Satellite"),
                     overlayGroups = c(title,"Equity Focus Area"),
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
              title = efa_title) |>
    
    setView(lng = -122.257, lat = 47.615, zoom = 7.5)
  
  return(working_map)
  
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
