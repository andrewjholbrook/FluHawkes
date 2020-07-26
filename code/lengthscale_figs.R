setwd("~/FluHawkes/")

library(ggplot2)
library(reshape2)

h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- t(h1n1)
df   <- melt(h1n1)
df   <- df[,2:3]
colnames(df) <- c("Parameter", "Value")
df$Parameter <- factor(df$Parameter)


gg <- ggplot(data.frame(x=c(0,100)),aes(x=x)) +
  stat_function(fun = dexp, args = list(rate = 1/df$Value[df$Parameter=="se_spat_length"]), aes(colour = "0.5"))