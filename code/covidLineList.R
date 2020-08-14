setwd("~/FluHawkes/")

library(readr)

latestdata <- read_csv("data/latestdata.csv")

latestdata$date_char <- as.character(latestdata$date_confirmation)
latestdata$date_confirmation <- as.Date(latestdata$date_char, "%d.%m.%Y")

latestdata$date <- difftime(latestdata$date_confirmation,
                            as.Date("2019-12-31"),
                            units = "days")
latestdata$date <- as.numeric(latestdata$date)
latestdata <- latestdata[order(latestdata$date),]

sum(latestdata$date<34,na.rm = TRUE)
latestdata <- latestdata[latestdata$date < 34,]
View(cbind(latestdata$date,latestdata$date_char))

latestdata <- latestdata[,c("longitude","latitude","date","country","province","city")]
# remove NAs for long lat and date

latestdata <- latestdata[!is.na(latestdata$latitude),]



