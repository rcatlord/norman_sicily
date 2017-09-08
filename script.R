## Norman art and architecture in Sicily ##

library(tidyverse); library(sf) ; library(leaflet) ; library(leaflet.extras)
pts <- read_csv("data/sites.csv")
pts <- st_as_sf(pts, coords = c("lon", "lat"), crs = 4326)

popup <- paste0("<p align=\"center\"><em>", pts$detail, "</em><br/><br/>",
                "<a href='",  pts$url, "' target='_blank'><img style = 'height: 100px;' src = ", pts$image, ">",
                "</a><br/>", "<strong>", pts$name, "</strong>", "<br/>", pts$date)

icon <- awesomeIcons(icon = "fa-map-marker", library = "fa", markerColor = "lightgreen", 
                     squareMarker = TRUE)

map <- leaflet() %>%
  setView(14.015356, 37.599994, zoom = 8) %>% 
  addProviderTiles(providers$CartoDB.Positron, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Road map") %>% 
  addProviderTiles(providers$Esri.WorldImagery, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Satellite") %>%
  addProviderTiles(providers$Stamen.TerrainBackground, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Terrain") %>%
  addAwesomeMarkers(data = pts, icon = icon, popup = popup,
                    label = ~name, labelOptions = labelOptions(opacity = 0),
                    group = 'sites') %>% 
  addLayersControl(position = 'bottomleft',
                   baseGroups = c("Road map", "Satellite", "Terrain"),
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  addEasyButton(easyButton(
    icon='fa-home', title='Reset',
    onClick=JS("function(btn, map){ map.setView([37.599994, 14.015356], 8);}"))) %>%
  addEasyButton(easyButton(
    icon="fa-location-arrow", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>% 
  addSearchMarker(targetGroup = 'sites',
    options = searchMarkersOptions(zoom = 14, openPopup = TRUE)) %>% 
  addControl("<strong>Search for Norman art and architecture in Sicily</strong>
             <br><em>Click popup image for Wikipedia entry</em>",
             position = 'bottomright')

library(htmlwidgets)
saveWidget(map, file = "index.html")
