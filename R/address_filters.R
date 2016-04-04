by_address <- function(d) {
  d %>% 
    group_by(Address)
}

by_address_and_chapter <- function(d) {
  d %>% 
    group_by(Address, Ordinance.Chapter)
}