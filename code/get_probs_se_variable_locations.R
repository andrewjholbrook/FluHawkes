setwd("~/FluHawkes/")

library(hpHawkes)
library(readr)
library(plyr)
library(reshape2)

latent_dim <- 2

# get coordinates and times
h1_locations <- read_table2("output/h1_locations.log", 
                            skip = 3)
h3_locations <- read_table2("output/h3_locations.log", 
                            skip = 3)
vic_locations <- read_table2("output/vic_locations.log", 
                             skip = 3)
yam_locations <- read_table2("output/yam_locations.log", 
                             skip = 3)
parameters <- read_delim("output/parameters.log", 
                         "\t", escape_double = FALSE, trim_ws = TRUE, 
                         skip = 3)

df <- readr::read_csv("data/coordinates_and_times.txt")
df$strain <- c( rep("h1n1",1370),
                rep("h3n2",1389),
                rep("vic",1393),
                rep("yam",1240) )

# remove burnin and remove state counts
S             <- dim(h1_locations)[1]
h1_locations  <- h1_locations[ceiling(S*.1):S,-1]
h3_locations  <- h3_locations[ceiling(S*.1):S,-1]
yam_locations <- yam_locations[ceiling(S*.1):S,-1]
vic_locations <- vic_locations[ceiling(S*.1):S,-1]
parameters    <- parameters[ceiling(S*.1):S,-1]

# get list of locations matrices
S <- dim(h1_locations)[1]
h1_locs <- list()
for(i in 1:S) {
  h1_locs[[i]] <- matrix(h1_locations[i,],nrow=1370,ncol = latent_dim, byrow=TRUE)
}

h3_locs <- list()
for(i in 1:S) {
  h3_locs[[i]] <- matrix(h3_locations[i,],nrow=1389,ncol = latent_dim, byrow=TRUE)
}

yam_locs <- list()
for(i in 1:S) {
  yam_locs[[i]] <- matrix(yam_locations[i,],nrow=1240,ncol = latent_dim, byrow=TRUE)
}

vic_locs <- list()
for(i in 1:S) {
  vic_locs[[i]] <- matrix(vic_locations[i,],nrow=1393,ncol = latent_dim, byrow=TRUE)
}

df2 <- df[df$strain=="h1n1",]
df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
pst <- t(as.matrix(parameters[,2:7]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(h1_locs[[i]])), 1370, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child[order(df2$X1),],file = "output/post_processed/h1n1_probs_se.rds")




df2 <- df[df$strain=="h3n2",]
df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,8:13]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(h3_locs[[i]])), 1389, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child[order(df2$X1),],file = "output/post_processed/h3n2_probs_se.rds")

df2 <- df[df$strain=="vic",]
df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,20:25]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(vic_locs[[i]])), 1393, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child[order(df2$X1),],file = "output/post_processed/vic_probs_se.rds")

df2 <- df[df$strain=="yam",]
df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,14:19]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(yam_locs[[i]])), 1240, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child[order(df2$X1),],file = "output/post_processed/yam_probs_se.rds")


