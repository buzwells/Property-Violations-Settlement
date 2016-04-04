add_total_violations_column <- function(d) {
  e <- summary_violations_by_address(d) 
  left_join(d, e, by = 'Address')  
}