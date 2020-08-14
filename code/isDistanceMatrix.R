setwd('~/FluHawkes')

set.seed(666)

library(readr)

dat <- read_table2("data/fluCombi_Deff_reordered_no0s.txt", col_names = FALSE)

dat <- dat[-1,-1]
N <- dim(dat)[1]
dat <- as.matrix(dat)
dat <- matrix(as.numeric(dat),N,N)

dat <- dat^2
ones <- rep(1,N)
centering <- diag(N) - ones%*%t(ones)/N

samp_cov <- centering %*% dat %*% centering

eigs <- eigen(samp_cov,symmetric = TRUE)
