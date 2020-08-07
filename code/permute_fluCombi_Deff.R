rm(list=ls())  # clean up workspace

setwd("~/FluHawkes/")

flu.combi <- read.csv("data/testFold5.txt", header=FALSE, skip=1, sep="\t")
rownames(flu.combi) <- flu.combi[, 1]
flu.combi <- flu.combi[, -1]
colnames(flu.combi) <- rownames(flu.combi)
names <- scan("data/names.txt", what = character(), sep = "\t")
new.col.names <- c(names, colnames(flu.combi)[-(1:5392)])
flu.combi <- flu.combi[, new.col.names]
flu.combi <- flu.combi[new.col.names, ]
#flu.combi <- flu.combi[1:5392,1:5392]
write.table(flu.combi, "data/testFold5.txt", sep = "\t",quote = FALSE)
# add TAXA\t as first element of dataset sometimes