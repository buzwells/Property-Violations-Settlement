by_chapter <- function(d) {
  d %>% 
    group_by(Ordinance.Chapter)
}

summarize_by_chapter <- function(d) {
  by_chapter(d) %>% 
    summarize(Ch.Violation.Count = n(), 
              Ch.Mean.Days.Open = mean(Days.Open), 
              Ch.Median.Days = median(Days.Open), 
              Ch.Sd = sd(Days.Open, na.rm = TRUE)) %>%
    ungroup() %>% 
    mutate(Percent.Violations = (Ch.Violation.Count / nrow(d))*100.00) %>% 
    arrange(desc(Ch.Violation.Count))
}

top_chapters <- function(d) {
  d %>% 
    filter(Ordinance.Chapter %in% c('48', '56'))
}