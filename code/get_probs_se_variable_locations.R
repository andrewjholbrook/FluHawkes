setwd("~/FluHawkes/")

library(hpHawkes)
library(readr)
library(plyr)
library(reshape2)

latent_dim <- 6

# get coordinates and times
h1_locations <- read_table2(paste0("output/h1_locations_",latent_dim,".log"), 
                            skip = 3)
h3_locations <- read_table2(paste0("output/h3_locations_",latent_dim,".log"), 
                            skip = 3)
vic_locations <- read_table2(paste0("output/vic_locations_",latent_dim,".log"), 
                             skip = 3)
yam_locations <- read_table2(paste0("output/yam_locations_",latent_dim,".log"), 
                             skip = 3)
parameters <- read_delim(paste0("output/parameters",latent_dim,".log"), 
                         "\t", escape_double = FALSE, trim_ws = TRUE, 
                         skip = 3)

df <- readr::read_csv("data/coordinates_and_times.txt") 
# df$strain <- c( rep("h1n1",1370),
#                 rep("h3n2",1389),
#                 rep("vic",1393),
#                 rep("yam",1240) )

df$strain <- c( rep("h1n1",1161),
                rep("h3n2",1341),
                rep("vic",1195),
                rep("yam",1036) )

# remove burnin and remove state counts
S             <- dim(h1_locations)[1]
percBurn <- 0.9
h1_locations  <- h1_locations[round(seq.int(from=ceiling(S*percBurn),to=S,length.out=100)),-1]
h3_locations  <- h3_locations[round(seq.int(from=ceiling(S*percBurn),to=S,length.out=100)),-1]
yam_locations <- yam_locations[round(seq.int(from=ceiling(S*percBurn),to=S,length.out=100)),-1]
vic_locations <- vic_locations[round(seq.int(from=ceiling(S*percBurn),to=S,length.out=100)),-1]
parameters    <- parameters[round(seq.int(from=ceiling(S*percBurn),to=S,length.out=100)),-1]

# get list of locations matrices
S <- dim(h1_locations)[1]
h1_locs <- list()
for(i in 1:S) {
  h1_locs[[i]] <- matrix(h1_locations[i,],nrow=1161,ncol = latent_dim, byrow=TRUE)
}

h3_locs <- list()
for(i in 1:S) {
  h3_locs[[i]] <- matrix(h3_locations[i,],nrow=1341,ncol = latent_dim, byrow=TRUE)
}

yam_locs <- list()
for(i in 1:S) {
  yam_locs[[i]] <- matrix(yam_locations[i,],nrow=1036,ncol = latent_dim, byrow=TRUE)
}

vic_locs <- list()
for(i in 1:S) {
  vic_locs[[i]] <- matrix(vic_locations[i,],nrow=1195,ncol = latent_dim, byrow=TRUE)
}

df2 <- df[df$strain=="h1n1",]
#df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
pst <- t(as.matrix(parameters[,2:7]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(h1_locs[[i]])), 1161, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
#saveRDS(post_prob_child[order(df2$X1),],file = "output/post_processed/h1n1_probs_se.rds")
saveRDS(post_prob_child,file = paste0("output/post_processed/h1n1_probs_se_",latent_dim,".rds"))



df2 <- df[df$strain=="h3n2",]
#df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,8:13]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(h3_locs[[i]])), 1341, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child,file = paste0("output/post_processed/h3n2_probs_se_",latent_dim,".rds"))


df2 <- df[df$strain=="vic",]
#df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,20:25]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(vic_locs[[i]])), 1195, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child,file = paste0("output/post_processed/vic_probs_se_",latent_dim,".rds"))


df2 <- df[df$strain=="yam",]
#df2 <- df2[order(df2$date),]
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- t(as.matrix(parameters[,14:19]))
pst[1,] <- pst[1,] + pst[2,] # back transform
pst[4,] <- pst[3,] + pst[4,] # back transform

# get probability child
post_prob_child <- matrix(100,length(times),S)
for (i in 1:S) {
  X <- matrix(as.numeric(unlist(yam_locs[[i]])), 1036, latent_dim)
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=latent_dim)
}
saveRDS(post_prob_child,file = paste0("output/post_processed/yam_probs_se_",latent_dim,".rds"))


