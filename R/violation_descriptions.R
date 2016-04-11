by_description <- function(d) {
  d %>% 
    group_by(Violation.Description)
}

top_descriptions <- function(d, top_tier_threshold = 2000) {
  d %>% 
    summarize_by_description() %>%  
    ungroup() %>% 
    filter(Violation.Count > top_tier_threshold) %>% 
    mutate(Percent.Violations = (Violation.Count / nrow(violations))*100.00)
}

summarize_by_description <- function(d) {
  d %>% 
    by_description() %>% 
    summarize(Violation.Count = n(), Median.Days.Open = median(Days.Open))
}

plot_top_description_frequency <- function(d, top_tier_threshold = 2000) {
  d %>% 
    top_descriptions(top_tier_threshold) %>% 
    ggplot(aes(reorder(Violation.Description, -Violation.Count), Violation.Count)) +    
    geom_bar(stat="identity") + 
    labs(title="Number of Violations by Description (2009-2016)") + 
    xlab("Code Description") + ylab("Violations") +
    theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))    
}