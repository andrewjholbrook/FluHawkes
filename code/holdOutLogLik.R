setwd('~/FluHawkes')

set.seed(666)

library(readr)
#library(reshape2)
#library(plyr)
library(MassiveMDS)

# # remove diagonals
# removeDiag <- function(df){
#   df <- df[-which(df[,1]==df[,2]),]
#   return(df)
# }
# 
# # coerce columns from factor to string
# factToString <- function(df){
#   i <- sapply(df, is.factor)
#   df[i] <- lapply(df[i], as.character)
#   return(df)
# }
# 
# logLikFun <- function(df,sigma=1){ 
#   out <- -.5*sum((df[,3]-df[,4])^2)/sigma^2 #- sum(log(pnorm(df[,3]/sigma)))
#   return(out)
# }
# 
# truncTerm <- function(df, prec){
#   out <- - sum(log(pnorm(df[,3]*sqrt(prec))))
#   return(out)
# }
# 
# get_names <- function(dat,d){
#   locs <- unlist(names(dat)) # get location names
#   locs <- locs[-1]
#   locs <- locs[seq(from=d,to=length(locs),by=d)]
#   locs <- gsub('.{1}$', '',x=locs)
# #  if(d>9) locs <- gsub('.{1}$', '',x=locs)
#   return(locs)
#}

#############################################################################

# input dimension and fold (k)
argu <- as.numeric(commandArgs(TRUE))
d    <- argu[1]
k    <- argu[2]

# locs <- unlist(read.csv(file="locationNamesCombined.txt", header = FALSE))
# locs <- gsub('.{1}$', '',x=locs)
# locs <- factor(locs)

# get heldout distances and compute log likes
heldOut <- read_table2(sprintf('data/testFold%d.txt',k), col_names = TRUE)
#heldOut <- melt(heldOut,na.rm=TRUE) # turn to d+1 column df, remove NAs
#heldOut <- removeDiag(heldOut)
# remove rows that do not equal any in locs (output from beast)
#heldOut <- heldOut[heldOut$variable %in% locs,]
#heldOut <- data.table::setorder(heldOut)

#heldOut$pair <- paste(heldOut$locs,heldOut$variable)
#heldOut <- heldOut[,c(4,3)]



# get posterior samples
dat1  <- read_table2(sprintf("output/h1_locations_%s.log",
                            paste(d,k,sep="")),
                            skip = 3)
#sequ <- seq(from=11,to=101,by=20) # need to change
dat1  <- dat1[-1,-1]
dat2  <- read_table2(sprintf("output/h3_locations_%s.log",
                             paste(d,k,sep="")),
                     skip = 3)
dat2  <- dat2[-1,-1]
dat3  <- read_table2(sprintf("output/vic_locations_%s.log",
                             paste(d,k,sep="")),
                     skip = 3)
dat3  <- dat3[-1,-1]
dat4  <- read_table2(sprintf("output/yam_locations_%s.log",
                             paste(d,k,sep="")),
                     skip = 3)
dat4  <- dat4[-1,-1]

# turn to list
dat <- cbind(dat1,dat2,dat3,dat4)
remove(dat1)
remove(dat2)
remove(dat3)
remove(dat4)

# dat <- split(dat, seq(nrow(dat)))
# dat <- llply(dat,.fun=matrix,
#              ncol=d,byrow=TRUE)
# dat <- llply(dat,.fun=data.frame,row.names=locs)
# dat <- llply(dat,.fun = dist)
# dat <- llply(dat,.fun = as.matrix) # list of dist matrices
# dat <- llply(dat,.fun = as.data.frame)
# dat <- llply(dat,.fun = cbind,locs)
# dat <- llply(dat,.fun = melt)
# dat <- llply(dat,.fun = removeDiag)
# dat <- llply(dat,.fun = factToString)
# dat <- llply(dat,.fun = data.table::setorder)
# 
# for(i in 1:length(dat)){
#   j <- 1
#   while(j < dim(heldOut)[1] & dim(dat[[i]])[1]>dim(heldOut)[1]){
#     if(dat[[i]]$locs[j]!=heldOut$TAXA[j]){
#       dat[[i]] <- dat[[i]][-j,]
#     } else if(dat[[i]]$variable[j]!=heldOut$variable[j]) {
#       dat[[i]] <- dat[[i]][-j,]
#     } else {
#       j <- j+1
#     }
#   }
# }
# 
# # merge dfs
# combined   <- llply(dat, .fun=merge, heldOut, by=colnames(heldOut)[1:2])
# precs <- read_delim(sprintf("precision%s.log",
#                             paste(d,k,sep="")), 
#                     "\t",
#                     escape_double = FALSE,
#                     trim_ws = TRUE, 
#                     skip = 3)
# 
# # for each state, evaluate squared residual and multiply by precision
# logLiks <- unlist(llply(combined,.fun = logLikFun))*
#   precs$mds.residual.precision[1:length(precs$mds.residual.precision)] +
#   .5 * dim(combined[[1]])[1] * log(precs$mds.residual.precision[1:length(precs$mds.residual.precision)]) -
#   .5 * dim(combined[[1]])[1] * log(2*pi) 
#   
# for(j in 1:length(logLiks)){ # add truncations
#   logLiks[j] <- logLiks[j] + truncTerm(combined[[j]],precs$mds.residual.precision[j])
# }
#     
# 
#   


# take second half of samples
#logLiks <- logLiks[-(1:ceiling(length(logLiks)/2))]

precs <- read_delim(sprintf("output/precision%s.log",
                            paste(d,k,sep="")),
                    "\t",
                    escape_double = FALSE,
                    trim_ws = TRUE,
                    skip = 3)
precs <- unlist(precs[-1,-1])

heldOut[is.na(heldOut)] <- NaN
truncation <- TRUE
threads <- 1
simd <- 0
gpu <- 2
single <- 0
locationCount <- dim(dat)[2]/d
heldOut <- heldOut[,-1]
heldOut <- heldOut[1:locationCount,1:locationCount]
heldOut <- matrix(unlist(heldOut),locationCount,locationCount)

engine <- MassiveMDS::createEngine(d, locationCount, truncation, threads, simd,gpu,single)
engine <- MassiveMDS::setPairwiseData(engine, heldOut)

logLiks <- rep(0,dim(dat)[1])
for(i in ceiling(length(logLiks)/2):length(logLiks)){
  locations <- matrix(unlist(dat[i,]), byrow = TRUE, ncol = d)
  engine <- MassiveMDS::updateLocations(engine, locations)
  engine <- MassiveMDS::setPrecision(engine, precs[i])
  logLiks[i] <- MassiveMDS::getLogLikelihood(engine)
}


cat(d, ' ', k, ' ', mean(logLiks),'\n',
    file="output/kFoldResult.txt",append=TRUE)
