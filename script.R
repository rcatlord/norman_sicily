## Norman art and architecture in Sicily ##

library(tidyverse); library(sf) ; library(leaflet) ; library(leaflet.extras) ; library(htmlwidgets)

sf <- read_csv("data/sites.csv") %>% st_as_sf(coords = c("lon", "lat"), crs = 4326)

popup <- paste0("<p style='text-align: center; font-weight: 400; line-height: 19px; font-family: \"Georgia\", serif; font-size: 15px;'><strong>", sf$name, ", (", sf$date, ")</strong><br/>",
                "<a href='",  sf$url, "' target='_blank'><img style = 'height: 120px; padding-top:5px;' src = ", sf$image, "></a><br/><span style='color: #777;'>",
                sf$location, "</span><br/>",
                sf$detail, "</p>")

icon <- awesomeIcons(icon = "fa-map-marker", library = "fa", markerColor = "lightgreen")

map <- leaflet() %>%
  setView(13.352104, 38.122561, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Road map") %>% 
  addProviderTiles(providers$Esri.WorldImagery, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Satellite") %>%
  addProviderTiles(providers$Stamen.TerrainBackground, options = tileOptions(minZoom = 5, maxZoom = 17), group = "Terrain") %>%
  addAwesomeMarkers(data = sf, icon = icon, popup = popup,
                    label = ~name, labelOptions = labelOptions(opacity = 0),
                    group = 'sites') %>% 
  addLayersControl(position = 'bottomright',
                   baseGroups = c("Road map", "Satellite", "Terrain"),
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  addFullscreenControl() %>% 
  addSearchFeatures(targetGroups = 'sites',
    options = searchFeaturesOptions(zoom = 12, openPopup = TRUE, firstTipSubmit = TRUE,
      autoCollapse = TRUE, hideMarkerOnCollapse = TRUE)) %>% 
  addControl("<strong>Art and architecture in Norman Sicily</strong>",
             position = 'topright') %>%
  htmlwidgets::onRender(paste0("
                               function(el, x) {
                               $('head').append(","\'<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\'",");
                               }"))

saveWidget(map, file = "index.html",
           title = "Norman Sicily")
