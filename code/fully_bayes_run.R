setwd("~/FluHawkes/")

library(hpHawkes)


##################################################################################
df <- readr::read_csv("data/coordinates_and_times.txt")

df <- df[1:1370,] # h1n1
#df <- df[1371:(1370+1389),] # h3n2
#df <- df[(1370+1389+1):(1370+1389+1393),] # vic
#df <- df[(1370+1389+1393+1):dim(df)[1],] # yam

df <- df[order(df$date),]

X <- as.matrix(df[,7:9])
times <- df$date
times <- times - min(times)


Max <- 500000
burn <- 50000
set.seed(666)

res <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res2 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res3 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res4 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)

# res$samples <- res$samples[,50000:19000]
# res2$samples <- res2$samples[,50000:19000]
# res3$samples <- res3$samples[,50000:19000]
# res4$samples <- res4$samples[,50000:19000]


samps <- cbind(res$samples,res2$samples,res3$samples,res4$samples)
#samps <- samps[c(1,4,5,6),] # remove background rate lengthscales (fixed)
samps[1,] <- 1/samps[1,]
samps[2,] <- 1/samps[2,]
samps[3,] <- 1/samps[3,]
samps[4,] <- 1/samps[4,]
rownames(samps) <- c("se_spat_length","bg_spat_length","bg_temp_length","se_temp_length", "se_weight","back_weight")



png(filename = "figures/naive_h1n1.png", width = 7, height = 10, units = 'in', res = 300)
par(mfrow=c(3,2))

# spatial lengthscale
plot(1/res$samples[1,],type="l",ylab="Spatial lengthscale (km)",main = "Self-excitatory",
     ylim = c(min(samps[1,]),max(samps[1,])))
lines(1/res2$samples[1,],col="red")
lines(1/res3$samples[1,],col="green")
lines(1/res4$samples[1,],col="blue")
abline(h=median(c(1/res$samples[1,],1/res2$samples[1,],1/res3$samples[1,],1/res4$samples[1,])),lwd=4)

plot(1/res$samples[2,],type="l",main="Background",ylab = "",
     ylim = c(min(samps[2,]),max(samps[2,])))
lines(1/res2$samples[2,],col="red")
lines(1/res3$samples[2,],col="green")
lines(1/res4$samples[2,],col="blue")
abline(h=median(c(1/res$samples[2,],1/res2$samples[2,],1/res3$samples[2,],1/res4$samples[2,])),lwd=4)

plot(1/res$samples[4,],type="l",ylab="Temporal lengthscale (years)",
     ylim = c(min(samps[4,]),max(samps[4,])))
lines(1/res2$samples[4,],col="red")
lines(1/res3$samples[4,],col="green")
lines(1/res4$samples[4,],col="blue")
abline(h=median(c(1/res$samples[4,],1/res2$samples[4,],1/res3$samples[4,],1/res4$samples[4,])),lwd=4)


plot(1/res$samples[3,],type="l",ylab = "",
     ylim = c(min(samps[3,]),max(samps[3,])))
lines(1/res2$samples[3,],col="red")
lines(1/res3$samples[3,],col="green")
lines(1/res4$samples[3,],col="blue")
abline(h=median(c(1/res$samples[3,],1/res2$samples[3,],1/res3$samples[3,],1/res4$samples[3,])),lwd=4)



plot(res$samples[5,],type="l",ylab="Weight",
     ylim = c(min(samps[5,]),max(samps[5,])))
lines(res2$samples[5,],col="red")
lines(res3$samples[5,],col="green")
lines(res4$samples[5,],col="blue")
abline(h=median(c(res$samples[5,],res2$samples[5,],res3$samples[5,],res4$samples[5,])),lwd=4)


plot(res$samples[6,],type="l",ylab = "",
     ylim = c(min(samps[6,]),max(samps[6,])))
lines(res2$samples[6,],col="red")
lines(res3$samples[6,],col="green")
lines(res4$samples[6,],col="blue")
abline(h=median(c(res$samples[6,],res2$samples[6,],res3$samples[6,],res4$samples[6,])),lwd=4)

dev.off()

saveRDS(samps,file = "output/mcmc_samples_naive/naive_h1n1.rds")




##################################################################################
df <- readr::read_csv("data/coordinates_and_times.txt")

#df <- df[1:1370,] # h1n1
df <- df[1371:(1370+1389),] # h3n2
#df <- df[(1370+1389+1):(1370+1389+1393),] # vic
#df <- df[(1370+1389+1393+1):dim(df)[1],] # yam

df <- df[order(df$date),]

X <- as.matrix(df[,7:9])
times <- df$date
times <- times - min(times)


Max <- 500000
burn <- 50000
set.seed(666)

res <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res2 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res3 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res4 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)

# res$samples <- res$samples[,50000:19000]
# res2$samples <- res2$samples[,50000:19000]
# res3$samples <- res3$samples[,50000:19000]
# res4$samples <- res4$samples[,50000:19000]


samps <- cbind(res$samples,res2$samples,res3$samples,res4$samples)
#samps <- samps[c(1,4,5,6),] # remove background rate lengthscales (fixed)
samps[1,] <- 1/samps[1,]
samps[2,] <- 1/samps[2,]
samps[3,] <- 1/samps[3,]
samps[4,] <- 1/samps[4,]
rownames(samps) <- c("se_spat_length","bg_spat_length","bg_temp_length","se_temp_length", "se_weight","back_weight")



png(filename = "figures/naive_h3n2.png", width = 7, height = 10, units = 'in', res = 300)
par(mfrow=c(3,2))

# spatial lengthscale
plot(1/res$samples[1,],type="l",ylab="Spatial lengthscale (km)",main = "Self-excitatory",
     ylim = c(min(samps[1,]),max(samps[1,])))
lines(1/res2$samples[1,],col="red")
lines(1/res3$samples[1,],col="green")
lines(1/res4$samples[1,],col="blue")
abline(h=median(c(1/res$samples[1,],1/res2$samples[1,],1/res3$samples[1,],1/res4$samples[1,])),lwd=4)

plot(1/res$samples[2,],type="l",main="Background",ylab = "",
     ylim = c(min(samps[2,]),max(samps[2,])))
lines(1/res2$samples[2,],col="red")
lines(1/res3$samples[2,],col="green")
lines(1/res4$samples[2,],col="blue")
abline(h=median(c(1/res$samples[2,],1/res2$samples[2,],1/res3$samples[2,],1/res4$samples[2,])),lwd=4)

plot(1/res$samples[4,],type="l",ylab="Temporal lengthscale (years)",
     ylim = c(min(samps[4,]),max(samps[4,])))
lines(1/res2$samples[4,],col="red")
lines(1/res3$samples[4,],col="green")
lines(1/res4$samples[4,],col="blue")
abline(h=median(c(1/res$samples[4,],1/res2$samples[4,],1/res3$samples[4,],1/res4$samples[4,])),lwd=4)


plot(1/res$samples[3,],type="l",ylab = "",
     ylim = c(min(samps[3,]),max(samps[3,])))
lines(1/res2$samples[3,],col="red")
lines(1/res3$samples[3,],col="green")
lines(1/res4$samples[3,],col="blue")
abline(h=median(c(1/res$samples[3,],1/res2$samples[3,],1/res3$samples[3,],1/res4$samples[3,])),lwd=4)



plot(res$samples[5,],type="l",ylab="Weight",
     ylim = c(min(samps[5,]),max(samps[5,])))
lines(res2$samples[5,],col="red")
lines(res3$samples[5,],col="green")
lines(res4$samples[5,],col="blue")
abline(h=median(c(res$samples[5,],res2$samples[5,],res3$samples[5,],res4$samples[5,])),lwd=4)


plot(res$samples[6,],type="l",ylab = "",
     ylim = c(min(samps[6,]),max(samps[6,])))
lines(res2$samples[6,],col="red")
lines(res3$samples[6,],col="green")
lines(res4$samples[6,],col="blue")
abline(h=median(c(res$samples[6,],res2$samples[6,],res3$samples[6,],res4$samples[6,])),lwd=4)

dev.off()

saveRDS(samps,file = "output/mcmc_samples_naive/naive_h3n2.rds")




##################################################################################
df <- readr::read_csv("data/coordinates_and_times.txt")

#df <- df[1:1370,] # h1n1
#df <- df[1371:(1370+1389),] # h3n2
df <- df[(1370+1389+1):(1370+1389+1393),] # vic
#df <- df[(1370+1389+1393+1):dim(df)[1],] # yam

df <- df[order(df$date),]

X <- as.matrix(df[,7:9])
times <- df$date
times <- times - min(times)


Max <- 500000
burn <- 50000
set.seed(666)

res <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res2 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res3 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)
res4 <- sampler(n_iter=Max,burnIn=burn,locations = X,
                params = c(1/1000,1/1000,1,1,1,1),
                times=times,gpu=2,radius=0.1,latentDimension = 3)

# res$samples <- res$samples[,50000:19000]
# res2$samples <- res2$samples[,50000:19000]
# res3$samples <- res3$samples[,50000:19000]
# res4$samples <- res4$samples[,50000:19000]


samps <- cbind(res$samples,res2$samples,res3$samples,res4$samples)
#samps <- samps[c(1,4,5,6),] # remove background rate lengthscales (fixed)
samps[1,] <- 1/samps[1,]
samps[2,] <- 1/samps[2,]
samps[3,] <- 1/samps[3,]
samps[4,] <- 1/samps[4,]
rownames(samps) <- c("se_spat_length","bg_spat_length","bg_temp_length","se_temp_length", "se_weight","back_weight")



png(filename = "figures/naive_vic.png", width = 7, height = 10, units = 'in', res = 300)
par(mfrow=c(3,2))

# spatial lengthscale
plot(1/res$samples[1,],type="l",ylab="Spatial lengthscale (km)",main = "Self-excitatory",
     ylim = c(min(samps[1,]),max(samps[1,])))
lines(1/res2$samples[1,],col="red")
lines(1/res3$samples[1,],col="green")
lines(1/res4$samples[1,],col="blue")
abline(h=median(c(1/res$samples[1,],1/res2$samples[1,],1/res3$samples[1,],1/res4$samples[1,])),lwd=4)

plot(1/res$samples[2,],type="l",main="Background",ylab = "",
     ylim = c(min(samps[2,]),max(samps[2,])))
lines(1/res2$samples[2,],col="red")
lines(1/res3$samples[2,],col="green")
lines(1/res4$samples[2,],col="blue")
abline(h=median(c(1/res$samples[2,],1/res2$samples[2,],1/res3$samples[2,],1/res4$samples[2,])),lwd=4)

plot(1/res$samples[4,],type="l",ylab="Temporal lengthscale (years)",
     ylim = c(min(samps[4,]),max(samps[4,])))
lines(1/res2$samples[4,],col="red")
lines(1/res3$samples[4,],col="green")
lines(1/res4$samples[4,],col="blue")
abline(h=median(c(1/res$samples[4,],1/res2$samples[4,],1/res3$samples[4,],1/res4$samples[4,])),lwd=4)


plot(1/res$samples[3,],type="l",ylab = "",
     ylim = c(min(samps[3,]),max(samps[3,])))
lines(1/res2$samples[3,],col="red")
lines(1/res3$samples[3,],col="green")
lines(1/res4$samples[3,],col="blue")
abline(h=median(c(1/res$samples[3,],1/res2$samples[3,],1/res3$samples[3,],1/res4$samples[3,])),lwd=4)



plot(res$samples[5,],type="l",ylab="Weight",
     ylim = c(min(samps[5,]),max(samps[5,])))
lines(res2$samples[5,],col="red")
lines(res3$samples[5,],col="green")
lines(res4$samples[5,],col="blue")
abline(h=median(c(res$samples[5,],res2$samples[5,],res3$samples[5,],res4$samples[5,])),lwd=4)


plot(res$samples[6,],type="l",ylab = "",
     ylim = c(min(samps[6,]),max(samps[6,])))
lines(res2$samples[6,],col="red")
lines(res3$samples[6,],col="green")
lines(res4$samples[6,],col="blue")
abline(h=median(c(res$samples[6,],res2$samples[6,],res3$samples[6,],res4$samples[6,])),lwd=4)

dev.off()

saveRDS(samps,file = "output/mcmc_samples_naive/naive_vic.rds")





##################################################################################
df <- readr::read_csv("data/coordinates_and_times.txt")

#df <- df[1:1370,] # h1n1
#df <- df[1371:(1370+1389),] # h3n2
#df <- df[(1370+1389+1):(1370+1389+1393),] # vic
df <- df[(1370+1389+1393+1):dim(df)[1],] # yam

df <- df[order(df$date),]

X <- as.matrix(df[,7:9])
times <- df$date
times <- times - min(times)


Max <- 500000
burn <- 50000
set.seed(666)

res <- sampler(n_iter=Max,burnIn=burn,locations = X,
           params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res2 <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res3 <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)
res4 <- sampler(n_iter=Max,burnIn=burn,locations = X,
               params = c(1/1000,1/1000,1,1,1,1),
               times=times,gpu=2,radius=0.1,latentDimension = 3)

# res$samples <- res$samples[,50000:19000]
# res2$samples <- res2$samples[,50000:19000]
# res3$samples <- res3$samples[,50000:19000]
# res4$samples <- res4$samples[,50000:19000]


samps <- cbind(res$samples,res2$samples,res3$samples,res4$samples)
#samps <- samps[c(1,4,5,6),] # remove background rate lengthscales (fixed)
samps[1,] <- 1/samps[1,]
samps[2,] <- 1/samps[2,]
samps[3,] <- 1/samps[3,]
samps[4,] <- 1/samps[4,]
rownames(samps) <- c("se_spat_length","bg_spat_length","bg_temp_length","se_temp_length", "se_weight","back_weight")



png(filename = "figures/naive_yam.png", width = 7, height = 10, units = 'in', res = 300)
par(mfrow=c(3,2))

# spatial lengthscale
plot(1/res$samples[1,],type="l",ylab="Spatial lengthscale (km)",main = "Self-excitatory",
     ylim = c(min(samps[1,]),max(samps[1,])))
lines(1/res2$samples[1,],col="red")
lines(1/res3$samples[1,],col="green")
lines(1/res4$samples[1,],col="blue")
abline(h=median(c(1/res$samples[1,],1/res2$samples[1,],1/res3$samples[1,],1/res4$samples[1,])),lwd=4)

plot(1/res$samples[2,],type="l",main="Background",ylab = "",
     ylim = c(min(samps[2,]),max(samps[2,])))
lines(1/res2$samples[2,],col="red")
lines(1/res3$samples[2,],col="green")
lines(1/res4$samples[2,],col="blue")
abline(h=median(c(1/res$samples[2,],1/res2$samples[2,],1/res3$samples[2,],1/res4$samples[2,])),lwd=4)

plot(1/res$samples[4,],type="l",ylab="Temporal lengthscale (years)",
     ylim = c(min(samps[4,]),max(samps[4,])))
lines(1/res2$samples[4,],col="red")
lines(1/res3$samples[4,],col="green")
lines(1/res4$samples[4,],col="blue")
abline(h=median(c(1/res$samples[4,],1/res2$samples[4,],1/res3$samples[4,],1/res4$samples[4,])),lwd=4)


plot(1/res$samples[3,],type="l",ylab = "",
     ylim = c(min(samps[3,]),max(samps[3,])))
lines(1/res2$samples[3,],col="red")
lines(1/res3$samples[3,],col="green")
lines(1/res4$samples[3,],col="blue")
abline(h=median(c(1/res$samples[3,],1/res2$samples[3,],1/res3$samples[3,],1/res4$samples[3,])),lwd=4)



plot(res$samples[5,],type="l",ylab="Weight",
     ylim = c(min(samps[5,]),max(samps[5,])))
lines(res2$samples[5,],col="red")
lines(res3$samples[5,],col="green")
lines(res4$samples[5,],col="blue")
abline(h=median(c(res$samples[5,],res2$samples[5,],res3$samples[5,],res4$samples[5,])),lwd=4)


plot(res$samples[6,],type="l",ylab = "",
     ylim = c(min(samps[6,]),max(samps[6,])))
lines(res2$samples[6,],col="red")
lines(res3$samples[6,],col="green")
lines(res4$samples[6,],col="blue")
abline(h=median(c(res$samples[6,],res2$samples[6,],res3$samples[6,],res4$samples[6,])),lwd=4)

dev.off()

saveRDS(samps,file = "output/mcmc_samples_naive/naive_yam.rds")


