setwd("~/FluHawkes/")

library(readr)
library(ggmap)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")


latlong_to_xyz <- function(lat,lon) {
  
  # convert to radians
  lat <- lat * pi / 180
  lon <- lon * pi / 180
  
  # radians to cartesian with km units
  x = 6371 * cos(lat) * cos(lon)
  y = 6371 * cos(lat) * sin(lon)
  z = 6371 * sin(lat)
  
  return(c(x,y,z))
}

# # geocode locations
df <- read_table2("data/locations_times.txt", col_names = FALSE)
colnames(df) <- c("taxa","date","country","location")
N  <- 4733
df$lon <- rep(0,N)
df$lat <- rep(0,N)
for (n in 1:N) {
  geo_tibble <- geocode(paste(df$country[n],df$location[n])) # uncomment to run
  df$lon[n] <- as.numeric(geo_tibble$lon)
  df$lat[n] <- as.numeric(geo_tibble$lat)
}
df <- df[1:4733,]
#write.csv(df, file="coordinates_and_times.txt",col.names = FALSE)

df$x <- rep(0,N)
df$y <- rep(0,N)
df$z <- rep(0,N)

for (n in 1:N) {
  df[n,7:9] <- latlong_to_xyz(lat=df$lat[n], lon=df$lon[n])
}
write.csv(df, file="data/coordinates_and_times.txt",col.names = FALSE,quote = FALSE,row.names = FALSE)

