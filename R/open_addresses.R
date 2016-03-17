library(dplyr)
library(tidyr)

open_addresses <- violations %>% 
  filter(Status == "Open" & 
           (Ordinance.Chapter == "48" | Ordinance.Chapter == "56") &
           Case.ID != "0") %>% 
  arrange(Address, Violation.Entry.Date, Ordinance.Title) %>% 
  group_by(Address, Ordinance.Chapter) %>% 
  summarize(Violation.Count = n(),
            Case.Opened.Date = first(Case.Opened.Date),
            Days.Open = mean(Days.Open), 
            Latitude = first(Latitude),
            Longitude = first(Longitude),
            Zip.Code = first(Zip.Code)) %>% 
  spread(Ordinance.Chapter, Violation.Count, fill = 0) %>% 
  mutate(Violation.Count = `48` + `56`, Property.Ratio = `56` / Violation.Count) %>% 
  select(-(`48`:`56`)) %>% 
  filter(Longitude != '') %>% 
  ungroup()

#list of ordinances for open cases
open_ordinances_by_address <- violations %>% 
  filter(Status == "Open" & 
           (Ordinance.Chapter == "48" | Ordinance.Chapter == "56") &
           Case.ID != "0") %>% 
  group_by(Address) %>% 
  summarize(Ordinances = paste(sprintf("%s %s", Violation.Entry.Date, Ordinance.Title), collapse = "<br/>")) %>% 
  ungroup()

open_addresses <- left_join(open_addresses, open_ordinances_by_address, by = 'Address')

rm(open_ordinances_by_address)