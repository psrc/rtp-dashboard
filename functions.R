# General Information -------------------------------------------------------------
page_information <- function(tbl, page_name, page_info) {
  
  t <- tbl |>
    filter(page == page_name) |>
    select(all_of(page_info)) |>
    pull()
  
  if(is.na(t)) {f <- ""} else {f <- t}
  
  return(f)
  
}

