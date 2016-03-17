# reduce the violations dataset to open nuisances and property violations grouped by case
open_cases <- violations %>% 
  filter(Status == "Open" & 
           (Ordinance.Chapter == "48" | Ordinance.Chapter == "56") &
           Case.ID != "0") %>% 
  arrange(Case.ID, Violation.Entry.Date, Ordinance.Title) %>% 
  group_by(Case.ID, Ordinance.Chapter) %>% 
  summarize(Violation.Count = n(),
            Case.Opened.Date = first(Case.Opened.Date),
            Days.Open = mean(Days.Open), 
            Latitude = first(Latitude),
            Longitude = first(Longitude),
            Address = first(Address),
            Zip.Code = first(Zip.Code)) %>% 
  spread(Ordinance.Chapter, Violation.Count, fill = 0) %>% 
  mutate(Violation.Count = `48` + `56`, Property.Ratio = `56` / Violation.Count) %>% 
  select(-(`48`:`56`)) %>% 
  filter(Longitude != '') %>% 
  ungroup()
  
  #list of ordinances for open cases
  open_ordinances_by_case <- violations %>% 
    filter(Status == "Open" & 
             (Ordinance.Chapter == "48" | Ordinance.Chapter == "56") &
             Case.ID != "0") %>% 
    group_by(Case.ID) %>% 
    summarize(Ordinances = paste(sprintf("%s %s", Violation.Entry.Date, Ordinance.Title), collapse = "<br/>")) %>% 
    ungroup()
  
open_cases <-  left_join(open_cases, open_ordinances_by_case, by = 'Case.ID')
    