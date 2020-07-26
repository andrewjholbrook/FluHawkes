setwd('~/FluHawkes/')

library(readr)
library(maps)
data(world.cities)

library(rworldmap)
data(countryExData)
countries <- countryExData[, 2]

df <- read_csv("code/coordinates_and_times.txt")

sum(df$country==df$location) # 1706 country specific

df <- df[df$country!=df$location,] # remove country specific entries

# but what about England vs great britain
sum(df$location %in% countries) # 11 (1706+11=1717)
df <- df[!df$location %in% countries,]

sum(df$location %in% world.cities$name) # 1769 cities (at least)
df <- df[!df$location %in% world.cities$name,]

# check against other city list
library(mdsr)
data(WorldCities)
sum(df$location %in% WorldCities$name) # 172 (172 + 1769 = 1941)
df <- df[!df$location %in% WorldCities$name,]


# 1734 potential regions data
sum(df$location=="Lisboa") # plus 41 for cities (1941+41=1982)
df <- df[df$location!="Lisboa",]

sum(df$location=="DistrictOfColumbia") # plus 4 for cities (1982+4=1986)
df <- df[df$location!="DistrictOfColumbia",]
