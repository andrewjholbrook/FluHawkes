setwd("~/FluHawkes/")

library(hpHawkes)

df <- readr::read_csv("data/coordinates_and_times.txt")
df$strain <- c( rep("h1n1",1161),
                rep("h3n2",1341),
                rep("vic",1195),
                rep("yam",1036) )

df2 <- df[df$strain=="h1n1",]
#df2 <- df2[order(df2$date),]
X <- as.matrix(df2[,7:9])
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- readRDS("output/mcmc_samples_naive/naive_h1n1_thinned.rds")
pst[1:4,] <- 1/pst[1:4,] 
# get probability child
I <- dim(pst)[2]
post_prob_child <- matrix(100,length(times),I)
for (i in 1:I) {
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=3)
}
#post_prob_child <- readRDS(file = "data/mcmc_samples/naive_h1n1_probs_se.rds")
saveRDS(post_prob_child,file = "output/post_processed/naive_h1n1_probs_se.rds")

df2 <- df[df$strain=="h3n2",]
#df2 <- df2[order(df2$date),]
X <- as.matrix(df2[,7:9])
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- readRDS("output/mcmc_samples_naive/naive_h3n2_thinned.rds")
pst[1:4,] <- 1/pst[1:4,] 

# get probability child
I <- dim(pst)[2]
post_prob_child <- matrix(100,length(times),I)
for (i in 1:I) {
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=3)
}
#post_prob_child <- readRDS(file = "output/mcmc_samples_naive/naive_h3n2_probs_se.rds")
saveRDS(post_prob_child,file = "output/post_processed/naive_h3n2_probs_se.rds")

df2 <- df[df$strain=="vic",]
#df2 <- df2[order(df2$date),]
X <- as.matrix(df2[,7:9])
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- readRDS("output/mcmc_samples_naive/naive_vic_thinned.rds")
pst[1:4,] <- 1/pst[1:4,] 

# get probability child
I <- dim(pst)[2]
post_prob_child <- matrix(100,length(times),I)
for (i in 1:I) {
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=3)
}
#post_prob_child <- readRDS(file = "output/mcmc_samples_naive/naive_vic_probs_se.rds")
saveRDS(post_prob_child,file = "output/post_processed/naive_vic_probs_se.rds")

df2 <- df[df$strain=="yam",]
#df2 <- df2[order(df2$date),]
X <- as.matrix(df2[,7:9])
times <- df2$date - min(df2$date)
# get posterior samples means
pst <- readRDS("output/mcmc_samples_naive/naive_yam_thinned.rds")
pst[1:4,] <- 1/pst[1:4,] 


# get probability child
I <- dim(pst)[2]
post_prob_child <- matrix(100,length(times),I)
for (i in 1:I) {
  post_prob_child[,i] <- hpHawkes::probability_se(locations = X,
                                                  times = times,
                                                  params = pst[,i],
                                                  gpu = 2,dimension=3)
}
#post_prob_child <- readRDS(file = "data/mcmc_samples/naive_yam_probs_se.rds")
saveRDS(post_prob_child,file = "output/post_processed/naive_yam_probs_se.rds")


