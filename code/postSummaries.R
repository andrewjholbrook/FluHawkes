setwd("~/FluHawkes/")

library(coda)

h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1[5,] <- h1n1[5,] / (h1n1[5,] + h1n1[6,])
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2[5,] <- h3n2[5,] / (h3n2[5,] + h3n2[6,])
yam <- readRDS("output/yam_thinned.rds")
yam[5,] <- yam[5,] / (yam[5,] + yam[6,])
vic <- readRDS("output/vic_thinned.rds")
vic[5,] <- vic[5,] / (vic[5,] + vic[6,])

h1n1[4,] <- 1/(h1n1[4,] + h1n1[3,])
h3n2[4,] <- 1/(h3n2[4,] + h3n2[3,])
yam[4,] <- 1/(yam[4,] + yam[3,])
vic[4,] <- 1/(vic[4,] + vic[3,])

h1n1[1,] <- 1/(h1n1[1,] + h1n1[2,])
h3n2[1,] <- 1/(h3n2[1,] + h3n2[2,])
yam[1,] <- 1/(yam[1,] + yam[2,])
vic[1,] <- 1/(vic[1,] + vic[2,])

h1n1[3,] <- 1/h1n1[3,]
h3n2[3,] <- 1/h3n2[3,]
yam[3,] <- 1/yam[3,]
vic[3,] <- 1/vic[3,]

h1n1[2,] <- 1/h1n1[2,]
h3n2[2,] <- 1/h3n2[2,]
yam[2,] <- 1/yam[2,]
vic[2,] <- 1/vic[2,]

h1n1 <- as.mcmc(t(h1n1)[,-6])
h3n2 <- as.mcmc(t(h3n2)[,-6])
yam <- as.mcmc(t(yam)[,-6])
vic <- as.mcmc(t(vic)[,-6])

summary(h1n1)[[2]][,c(3,1,5)]

summary(h3n2)[[2]][,c(3,1,5)]

summary(yam)[[2]][,c(3,1,5)]

summary(vic)[[2]][,c(3,1,5)]

