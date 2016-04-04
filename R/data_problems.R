for(col_name in names(violations)) {
  col_class <- class(violations[,col_name])
  print(col_class)
  errors <- 0
  if(col_class == 'character') {
    errors <- nrow(violations %>% filter(violations[,col_name] == ''))
  } else {
    errors <- nrow(violations %>% filter(is.na(violations[,col_name])))
    print(col_name)
  }
  data_problems[1,col_name] <- errors
}

scrub_bad_data <- function(d) {
  for(col_name in names(d)) {
    col_class <- class(d[,col_name])
    if(col_class == 'character') {
      d <- d %>% filter(d[,col_name] != '')
    } else if(col_name != 'Case.Closed.Date') {
      d <- d %>% filter(!is.na(d[,col_name]))
    }
    print(col_name)
    print(nrow(d))
  }
  d
}