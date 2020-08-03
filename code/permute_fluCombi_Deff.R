rm(list=ls())  # clean up workspace

setwd("~/FluHawkes/")

flu.combi <- read.csv("data/fluCombi_Deff.txt", header=FALSE, skip=1, sep="\t")
rownames(flu.combi) <- flu.combi[, 1]
flu.combi <- flu.combi[, -1]
colnames(flu.combi) <- rownames(flu.combi)
names <- scan("data/names.txt", what = character(), sep = "\t")
new.col.names <- c(names, colnames(flu.combi)[-(1:5392)])
flu.combi <- flu.combi[, new.col.names]
flu.combi <- flu.combi[new.col.names, ]
write.table(flu.combi, "/Users/xji3/Downloads/fluCombi_Deff_reordered.txt", sep = "\t")