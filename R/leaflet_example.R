library(leaflet)
library(maps)
library(rgdal)
library(sp)
library(rgeos)
library(maptools)
library(tidyr)
library(RColorBrewer)

# by address
qpal <- colorQuantile("Reds", open_addresses$Days.Open, n = 5)

open_addresses$Gmap.Fragment <-  paste(gsub(" ", "+", open_addresses$Address), 
                                   ",Kansas+City,+MO+", 
                                   open_addresses$Zip.Code, 
                                   "/@", 
                                   open_addresses$Latitude, 
                                   ",", 
                                   open_addresses$Longitude, 
                                   sep = "")

leaflet(open_addresses) %>% 
  setView(lng = -94.5783, lat = 39.0997, zoom = 11) %>% 
  addTiles() %>% 
  addCircleMarkers(radius = ~Violation.Count*.5, 
                   color = ~qpal(Days.Open), 
                   popup = sprintf("<a href='%s'><h3>%s</h3></a>
                                   <ul>
                                   <li>Opened: %s</li>
                                   <li>Mean Days Open: %d</li>
                                   <li># of Violations: %d</li>
                                   </ul>
                                   <h4>Ordinances</h4><p>%s</p>", 
                                   sprintf("http://www.google.com/maps/place/%s", open_addresses$Gmap.Fragment),
                                   open_addresses$Address, 
                                   open_addresses$Case.Opened.Date, 
                                   open_addresses$Days.Open, 
                                   open_addresses$Violation.Count,
                                   open_addresses$Ordinances)) %>% 
  addLegend(pal = qpal, values = ~Days.Open, opacity = 1)
