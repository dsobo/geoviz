#47.6062  122.3321 -- Seattle
#45.5051  122.6750 -- Portland

Wahklakum - 53069
Cowitz - 53015 
skamania - 53059
clatsop - 41007
columbia - 41009
clark - 53011
Tillamook - 41057 
Washington - 41067 
Yamhill - 41071
Multnomah - 41051
Hood River -  41027
Wasco - 41065
Clackamas - 41005
Marion - 41047


county_geo <- c(53069,53015,53059,41007,41009,53011,41057,41067,41071,41051,41027,41065,41005,41047)
county_geo <- as.character(county_geo)

library(rvest)

county_roads <- html("ftp://ftp2.census.gov/geo/tiger/TIGER2018/ROADS/")

library(RCurl)
library(tidyverse)

county_roads <- "ftp://ftp2.census.gov/geo/tiger/TIGER2018/ROADS/"

roads_zip <- getURL(url = county_roads, dirlistonly = T)
roads_zip <- unlist(strsplit(x = roads_zip, split = "\r\n"))
roads_zip <- roads_zip[grepl(paste(county_geo, collapse = "|"),roads_zip)]

for (n in roads_zip) {
  download.file(paste0(county_roads, n), paste0(here::here("pnw/roads"), "/", n))
  
}

road_zip_files <- list.files(path = here::here("pnw/roads/shape/"), pattern = "*.zip", full.names = TRUE)


for (i in 1:length(road_zip_files)){
  unzip(road_zip_files[i], files = grep("\\.shp$",unzip(road_zip_files[i], list=TRUE)$Name, value = T),exdir = here::here("pnw/roads/shape/"))
  
}


county_features <- read_html("https://www2.census.gov/geo/tiger/TIGER2018/FEATNAMES/")

features_table <- county_features %>%
  html_node("table") %>%
  html_table()

feature_table <- features_table %>%
  select(Name,`Last modified`, Size) %>%
  filter(str_detect(Name,paste(county_geo, collapse = "|")))


for (n in feature_table$Name) {
  download.file(paste0("https://www2.census.gov/geo/tiger/TIGER2018/FEATNAMES/", n), paste0(here::here("pnw/features/"), "/", n))
  
}
      


?unzip      
              
