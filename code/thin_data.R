setwd("~/FluHawkes/")

h1n1 <- readRDS("output/mcmc_samples_naive/naive_h1n1.rds")
N <- dim(h1n1)[2]
Sequ <- seq.int(from=1,to=N,by=1000)
h1n1_thinned <- h1n1[,Sequ]
saveRDS(h1n1_thinned,file = "output/mcmc_samples_naive/naive_h1n1_thinned.rds")

h3n2 <- readRDS("output/mcmc_samples_naive/naive_h3n2.rds")
h3n2_thinned <- h3n2[,Sequ]
saveRDS(h3n2_thinned,file = "output/mcmc_samples_naive/naive_h3n2_thinned.rds")

yam <- readRDS("output/mcmc_samples_naive/naive_yam.rds")
yam_thinned <- yam[,Sequ]
saveRDS(yam_thinned,file = "output/mcmc_samples_naive/naive_yam_thinned.rds")

vic <- readRDS("output/mcmc_samples_naive/naive_vic.rds")
vic_thinned <- vic[,Sequ]
saveRDS(vic_thinned,file = "output/mcmc_samples_naive/naive_vic_thinned.rds")