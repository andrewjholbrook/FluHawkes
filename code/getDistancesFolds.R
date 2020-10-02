setwd('~/FluHawkes')

set.seed(666)

library(readr)
library(lavaan)
library(caret)

dat <- read_table2("data/newestDeffs.txt", col_names = TRUE)
vechDat <- as.numeric(lav_matrix_vech(as.matrix(dat[,-1]),
                                      diagonal = FALSE))
length(vechDat) == dim(dat[,-1])[1]*( dim(dat[,-1])-1)/2
foldsList <- createFolds(vechDat,returnTrain = TRUE,k=5) 

# construct k datasets
datSets <- list()
for(k in 1:5){
  # get train folds
  holder <- vechDat
  holder[-foldsList[[k]]] <- NA
  holder <- lav_matrix_vech_reverse(holder,diagonal = FALSE)
  dat[1:dim(dat)[1],2:dim(dat)[2]] <- holder
  write.table(dat, file=sprintf('folds/trainFold%d.txt',k),
              quote=FALSE,eol="\n",sep='\t',
            row.names = FALSE,col.names = TRUE)
  
  # get test folds
  holder <- vechDat
  holder[foldsList[[k]]] <- NA
  holder <- lav_matrix_vech_reverse(holder,diagonal = FALSE)
  dat[1:dim(dat)[1],2:dim(dat)[2]] <- holder
  write.table(dat, file=sprintf('folds/testFold%d.txt',k),
              quote=FALSE,eol="\n",sep='\t',
              row.names = FALSE,col.names = TRUE)
}
