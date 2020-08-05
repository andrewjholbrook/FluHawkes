setwd('~/FluHawkes')

library(readr)

df <- read_table2("data/fluCombi_Deff_reordered.txt", col_names = FALSE)
dat <- df[-1,-1]
dat <- as.matrix(dat)

N <- dim(dat)[1]
 #vdat <- as.vector(dat)
 #vdat <- as.numeric(vdat)
#m <- as.numeric(min(vdat[vdat>0]))
#m <- 1.0082
 
for(i in 1:N){
  for(j in 1:N){
    if(i!=j & dat[i,j] == 0){
      dat[i,j] <- 1
    }
  }
}
df[2:(N+1),2:(N+1)] <- dat

write.table(df, file="data/fluCombi_Deff_reordered_low1.txt",
            quote=FALSE,eol="\n",sep='\t',
            row.names = FALSE,col.names = FALSE)