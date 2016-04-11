summary_basic <- function(d) {
  d %>% 
    summarize(Violation.Count = n(), 
              Mean.Days.Open = round(mean(Days.Open), digits = 2),
              Median.Days.Open = round(median(Days.Open), digits = 2))
}