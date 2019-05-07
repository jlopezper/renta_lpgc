library(tidyverse)
library(sf)          # classes and functions for vector data
library(raster)      # classes and functions for raster data
library(spData)        # load geographic data
library(spDataLarge)   # load larger geographic data

renta <- readr::read_csv2("./data/data_renta.csv", col_types = cols(
  cp = col_character(),
  numero_declaraciones = col_number(),
  renta_media = col_number(),
  renta_disp_media = col_number(),
  renta_trabajo = col_number(),
  renta_exenta = col_number(),
  renta_bruta = col_number(),
  cotizaciones_ss = col_number(),
  cuota_resultante = col_number(),
  renta_disp = col_number()
))

geometry <- readr::read_csv("./data/postal.cat.csv", col_types = cols(
  codigopostalid = col_character(),
  poblacionid = col_character(),
  poblacion = col_character(),
  provinciaid = col_character(),
  provincia = col_character(),
  ineid = col_character(),
  lat = col_double(),
  lon = col_double()
))

gas <- rgdal::readOGR(dsn = "/Users/jorgelopezperez/Google Drive/renta_lpgc/data/9113-LAS_PALMAS/", layer = "LAS_PALMAS")
gas2 <- st_as_sf(gas)
gas3 <- gas2 %>% dplyr::filter(COD_POSTAL %in% renta$cp)

gas4 <- 
  gas3 %>% 
  left_join(renta[c("cp", "renta_media", "renta_disp_media")], by = c("COD_POSTAL" = "cp"))

gas5 <- gas4[c("COD_POSTAL", "renta_media", "renta_disp_media", "geometry")]


tm1 <- 
  tm_shape(gas5) +
  tm_polygons(col = "renta_media", breaks = c(15000, 20000, 25000, 30000, 35000, 40000, 45000, 50000))


tm2 <- 
  tm_shape(gas5) +
  tm_polygons(col = "renta_disp_media", breaks = c(15000, 20000, 25000, 30000, 35000, 40000, 45000, 50000))


tmap_arrange(tm1, tm2)
