summary_basic <- function(d) {
  d %>% 
    summarize(Violation.Count = n(), Mean.Days.Open = round(mean(Days.Open), digits = 2))
}

summary_violations_by_address <- function(d) {
  d %>% 
    by_address() %>% 
    summarize(Violation.Count = n()) %>% 
    ungroup()
}