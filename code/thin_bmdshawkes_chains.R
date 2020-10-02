setwd("~/FluHawkes/")

library(readr)
df <- read_table2("~/FluHawkes/output/parameters6.log", 
                           skip = 3)

df <- df[df$state>=40000000,]
df <- df[floor(seq(from=1,to=dim(df)[1],length.out = 1000)),]

h1n1_thinned <- df[,3:8]
saveRDS(t(h1n1_thinned),file = "output/h1n1_thinned.rds")

h3n2_thinned <- df[,9:14]
saveRDS(t(h3n2_thinned),file = "output/h3n2_thinned.rds")

yam_thinned <- df[,15:20]
saveRDS(t(yam_thinned),file = "output/yam_thinned.rds")

vic_thinned <- df[,21:26]
saveRDS(t(vic_thinned),file = "output/vic_thinned.rds")