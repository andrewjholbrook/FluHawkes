setwd("~/FluHawkes/")
library(readr)
library(plyr)
library(reshape2)
library(coda)
library(ggplot2)
library(ggforce)

h1_locations <- read_table2("output/h1_locations_2.log", 
                                   skip = 3)
h3_locations <- read_table2("output/h3_locations_2.log", 
                              skip = 3)
vic_locations <- read_table2("output/vic_locations_2.log", 
                              skip = 3)
yam_locations <- read_table2("output/yam_locations_2.log", 
                               skip = 3)
countries <- read_table2("output/countries_small_geo_BMDS_Hawkes_Country.locations.log", 
                         skip = 3)

# remove burnin
S <- min(dim(h1_locations)[1],dim(h3_locations)[1] ,dim(yam_locations)[1],dim(vic_locations)[1]  ,dim(countries)[1] )
h1_locations <- h1_locations[ceiling(S*.1):S,]
h3_locations <- h3_locations[ceiling(S*.1):S,]
yam_locations <- yam_locations[ceiling(S*.1):S,]
vic_locations <- vic_locations[ceiling(S*.1):S,]
#c <- dim(countries)[1]
countries <- countries[ceiling(S*.1):S,]

# take first row 
h1_locations <- h1_locations[2,-1]
h3_locations <- h3_locations[2,-1]
yam_locations <- yam_locations[2,-1]
vic_locations <- vic_locations[2,-1]

countries <- countries[2,]
countries <- countries[,-1]

dat1 <- h1_locations
dat2 <- h3_locations
dat3 <- yam_locations
dat4 <- vic_locations

# get names
#locs <- unlist(read.csv(file="~/FluMDS/locationNamesCombined.txt", header = FALSE))
locs <- scan("data/names.txt", what = character(), sep = "\t")

#locs <- gsub('.{1}$', '',x=locs)
locs2 <- gsub('.{1}$', '',x=colnames(countries)[-1])
locs2 <- unique(locs2)
#locs2[locs2=="DE"] <- "GR"
locs <- factor(locs)
locs2 <- factor(locs2)

dat <- cbind(as.matrix(dat1),
             as.matrix(dat2),
             as.matrix(dat3),
             as.matrix(dat4))
d  <- 2 # dimension
S  <- dim(dat)[1]

#dat <- split(dat, seq(nrow(dat)))
dat <- matrix(dat,ncol=d,byrow=TRUE)
row.names(dat) <- locs

cont <- matrix(unlist(countries),
             ncol=d,byrow=TRUE)
row.names(cont) <- locs2
cont <- as.data.frame(cont)


# # vector of strains IDs
# Strain <- c( rep('h1',dim(dat1)[2]/2-.5),
#             rep('h3',dim(dat2)[2]/2-.5),
#             rep('yam',dim(dat3)[2]/2-.5),
#             rep('vic',dim(dat4)[2]/2-.5))
# for(i in 1:99){
#   dat[[i]]$Strain <- factor(Strain)
# }

# add probs_se
h1n1 <- readRDS(file = "output/post_processed/h1n1_probs_se.rds")
h3n2 <- readRDS(file = "output/post_processed/h3n2_probs_se.rds")
yam <- readRDS(file = "output/post_processed/yam_probs_se.rds")
vic <- readRDS(file = "output/post_processed/vic_probs_se.rds")
h1n1[h1n1==100] <- NA
h3n2[h3n2==100] <- NA
yam[yam==100] <- NA
vic[vic==100] <- NA
Probs <- c( rowMeans(h1n1,na.rm = TRUE),
            rowMeans(h3n2,na.rm = TRUE),
            rowMeans(vic,na.rm = TRUE),
            rowMeans(yam,na.rm = TRUE) )
`Posterior\nmean\nprobability` <- Probs

# prepare final data
df <- data.frame(X1=dat[,1],X2=dat[,2],`Posterior\nmean\nprobability`=`Posterior\nmean\nprobability`)
df <- df[order(Probs,decreasing = TRUE),]

gg <- ggplot(df, aes(x=X1,y=X2,color=`Posterior\nmean\nprobability`)) +
  geom_point(size=1,position = position_jitternormal(sd_x = 0.5,sd_y = 0.5)) +
  scale_colour_distiller(palette="Spectral") +
  geom_text(data=cont,
            mapping=aes(x=V1,y=V2,
                        label=as.character(locs2)),
            inherit.aes = FALSE,
            size=4,
            check_overlap = TRUE,
            fontface="bold") +
  ylab("Latent dimension 2") + xlab("Latent dimension 1") +
  ggtitle("Worldwide latent air traffic network")+
  theme_classic()
gg


ggsave(filename="latent_map.pdf",plot=gg,device="pdf",path="figures/",dpi="retina",
       width = 8,height = 4)

system2(command = "pdfcrop", 
        args    = c("~/FluHawkes/figures/latent_map.pdf", 
                    "~/FluHawkes/figures/latent_map.pdf") 
)
