
###Install necessary packages
install.packages("rgdal")
install.packages("spdplyr")
install.packages("geojsonio")
install.packages("geojson")

###Load required packages
library(rgdal)
library(spdplyr)
library(geojsonio)
library(geojson)

###Download zipfile from State Board of Elections and store as SpatialPolygonsDataFrame object
temp <- tempfile()
download.file("http://dl.ncsbe.gov.s3.amazonaws.com/PrecinctMaps/SBE_PRECINCTS_20170519.zip",temp)
shp <- readOGR(dsn = ".", layer = "Precincts2")

###Delete and unlink temporary file location
unlink(temp)
rm(temp)

###Filter for only Guilford County
gc_shp <- shp %>% filter(COUNTY_NAM == "GUILFORD")

###Convert to long/lat projections
gc_shp <- spTransform(gc_shp, CRS("+init=epsg:4326 +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

###Convert to json object
gc_geojson <- geojson_json(gc_shp)

###Two options, (1) create temp location to store and transfer or (2) write file locally and save manually to desired location

###Option 1
temp <- tempfile()
geojson_write(gc_shp, file = "./precincts.geojson")
###ADD CODE FOR FTP

###Option 2
geojson_write(gc_geojson, file = "Type File Path Here")

###Delete and unlink temporary file location
unlink(temp)
rm(temp)