by_ordinance_and_description <- function(d) {
  d %>% 
    group_by(Ordinance.Title, Violation.Description)
}

by_ordinance_and_code <- function(d) {
  d %>% 
    group_by(Ordinance.Title, Violation.Code)
}