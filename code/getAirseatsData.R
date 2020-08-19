setwd("~/FluHawkes/")

library(readr)
library(ggmap)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")
library(stringr)

OAGa_Nodes <- read_delim("data/OAGa_Nodes.txt", 
                              "\t", escape_double = FALSE, col_names = FALSE, 
                              trim_ws = TRUE)

Countries <- str_extract(OAGa_Nodes$X3, "\\b[A-Z][A-Z]\\b")
counts <- table(Countries)

OAGa_Weight <- read_table2("data/OAGa_Weight.txt", 
                               col_names = FALSE)
N1 <- dim(OAGa_Weight)[1]
N2 <- dim(OAGa_Weight)[2]
OAGa_Weight <- OAGa_Weight[,-N2]
OAGa_Weight <- matrix(as.numeric(unlist(OAGa_Weight)),N1,N1)
uniq_countries <- unique(Countries) # 225

for(i in uniq_countries) {
  dummy <- which(Countries == i)
  if(length(dummy)>1){
    output <- dummy[1]
    OAGa_Weight[output,] <- colSums(OAGa_Weight[dummy,])
    dummy <- dummy[-1]
    OAGa_Weight[dummy,] <- 0
  }
}
OAGa_Weight <- t(OAGa_Weight)
for(i in uniq_countries) {
  dummy <- which(Countries == i)
  if(length(dummy)>1){
    output <- dummy[1]
    OAGa_Weight[output,] <- colSums(OAGa_Weight[dummy,])
    dummy <- dummy[-1]
    OAGa_Weight[dummy,] <- 0
  }
}
OAGa_Weight <- OAGa_Weight[rowSums(OAGa_Weight)>0,]
OAGa_Weight <- OAGa_Weight[,colSums(OAGa_Weight)>0]
colnames(OAGa_Weight) <- uniq_countries
row.names(OAGa_Weight) <- uniq_countries
for(i in 1:225){
  eff_airport <- sqrt(counts[names(counts)==uniq_countries[i]])
  if(eff_airport==1){
    OAGa_Weight[i,i] <- 0
  } else {
    OAGa_Weight[i,i] <- OAGa_Weight[i,i] / eff_airport / 2
  }
}

tots <- diag(1/(sqrt(colSums(OAGa_Weight))))
P <- tots %*% OAGa_Weight %*% tots# need probability matrix
Deffs <- - log(P)
Deffs[Deffs==Inf] <- 0
row.names(Deffs) <- uniq_countries
colnames(Deffs) <- uniq_countries

# get shortest paths when not present
#meltDeffs <- reshape2::melt(Deffs)
library(igraph)
gDeffs <- graph_from_adjacency_matrix(Deffs,mode = "undirected",weighted = TRUE)
sp <- shortest.paths(gDeffs)
Deffs[Deffs==0] <- sp[Deffs==0]

#
### create larger file
#
flu.combi <- read.csv("data/rerereorderedDeffs.txt", header=TRUE, skip=0, sep="\t")
locations_times <- read_table2("data/locations_times.txt", 
                                    col_names = FALSE)
locations_times$X3 <- str_replace(locations_times$X3,"([a-z])([A-Z])","\\1 \\2")

library(countrycode)
locations_times$codes <- countrycode(locations_times$X3,origin = "country.name",destination = "iso2c")
# locations_times$codes <- str_replace(locations_times$codes,
#                                      ".([a-z]+)","\\1")
# locations_times$codes <- toupper(locations_times$codes)

sum(uniq_countries %in% locations_times$codes) # 64 as should be


# flu.combi <- flu.combi[,-1]
# row.names(flu.combi) <- colnames(flu.combi)
# #fix problem with . instead of /s in row/column names
# locations_times$X1 <- gsub("/",".",locations_times$X1,fixed = TRUE)
# locations_times$X1 <- gsub("_",".",locations_times$X1,fixed = TRUE)
# locations_times$X1 <- gsub("-",".",locations_times$X1,fixed = TRUE)
names <- as.character(flu.combi[,1])
N <- dim(flu.combi)[1]
data <- matrix(0,N,N)
row.names(Deffs)[157] <- "NAm"
colnames(Deffs)[157] <- "NAm"

remove(OAGa_Weight)
remove(flu.combi)
remove(gDeffs)
remove(OAGa_Nodes)
remove(P)
remove(sp)
remove(tots)
remove(Countries)

for(i in 1:N){
  for(j in (i+1):N){
    if(i <= 4733 & j <= 4733){
      data[i,j] <- Deffs[paste0(locations_times$codes[locations_times$X1==names[i]]),
                              paste0(locations_times$codes[locations_times$X1==names[j]])] 
    # } else if(i>5392 & j<=5392) {
    #   data[i,j] <- Deffs[paste0(names[i]),
    #                           paste0(locations_times$codes[locations_times$X1==names[j]])]
    } else if(i<=4733 & j>4733) {
      data[i,j] <- Deffs[paste0(locations_times$codes[locations_times$X1==names[i]]),
                              paste0(names[j])]
    } else {
      data[i,j] <- Deffs[paste0(names[i]),
                              paste0(names[j])]
    }
    data[j,i] <- data[i,j]
  }
  if(i %% 10 == 0) print(i)
}

colnames(data) <- names
row.names(data) <- names
  
write.table(data, "data/newestDeffs.txt", sep = "\t",quote = FALSE)

  
  

