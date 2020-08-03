setwd('~/FluHawkes')

set.seed(666)

library(readr)

dat <- read_table2("data/fluCombi_Deff_reordered.txt", col_names = FALSE)
dat <- dat[-1,-1]
dat <- as.matrix(dat)

N <- dim(dat)[1]
 vdat <- as.vector(dat)
 vdat <- as.numeric(vdat)
m <- as.numeric(min(vdat[vdat>0]))
m <- 1.0082
 
for(i in 3199:N){
  for(j in 3828:N){
    if(i!=j & dat[i,j] == 0){
      dat[i,j] <- m/2
    }
  }
}

write.table(dat, file="data/fluCombi_Deff_reordered_no0s.txt",
            quote=FALSE,eol="\n",sep='\t',
            row.names = FALSE,col.names = FALSE)