setwd("~/FluHawkes/")

h1n1 <- readRDS("data/mcmc_samples/naive_h1n1.rds")
N <- dim(h1n1)[2]
Sequ <- seq.int(from=1,to=N,by=1000)
h1n1_thinned <- h1n1[,Sequ]
saveRDS(h1n1_thinned,file = "data/mcmc_samples/naive_h1n1_thinned.rds")

h3n2 <- readRDS("data/mcmc_samples/naive_h3n2.rds")
h3n2_thinned <- h3n2[,Sequ]
saveRDS(h3n2_thinned,file = "data/mcmc_samples/naive_h3n2_thinned.rds")

yam <- readRDS("data/mcmc_samples/naive_yam.rds")
yam_thinned <- yam[,Sequ]
saveRDS(yam_thinned,file = "data/mcmc_samples/naive_yam_thinned.rds")

vic <- readRDS("data/mcmc_samples/naive_vic.rds")
vic_thinned <- vic[,Sequ]
saveRDS(vic_thinned,file = "data/mcmc_samples/naive_vic_thinned.rds")