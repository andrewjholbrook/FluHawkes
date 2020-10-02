setwd("~/FluHawkes/")
library(readr)
library(plyr)
library(reshape2)
library(coda)
library(ggplot2)
library(grid)
library(gridExtra)
library(gtable)
library(cowplot)

colors <- RColorBrewer::brewer.pal(11,"Spectral")[11:1]

# se weights fig
h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1 <- h1n1[5,] / (h1n1[5,] + h1n1[6,])
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2 <- h3n2[5,] / (h3n2[5,] + h3n2[6,])
yam <- readRDS("output/yam_thinned.rds")
yam <- yam[5,] / (yam[5,] + yam[6,])
vic <- readRDS("output/vic_thinned.rds")
vic <- vic[5,] / (vic[5,] + vic[6,])

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                          rep("H3N2",length(h3n2)),
                          rep("YAM",length(yam)),
                          rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

# gg <- ggplot(df,aes(x=Weight,fill=Virus)) +
#   geom_density(alpha = 0.6,size=0.5) +
#   theme_classic() +
#   theme(legend.key.size = unit(1.3, "cm") )+
#   ylab('Posterior density') +
#   xlab('Self-excitatory weight') #+
#   #ggtitle("Spatially naive model")
# gg
# gg0 <- cowplot::get_legend(gg)

gg <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5,adjust=2) +
  scale_fill_manual(values = colors[c(2,4,8,10)])+
  theme_classic() +
  ylab('Posterior density') +
  xlab('Normalized self-excitatory weight') +
  theme(legend.key.size = unit(.8, "cm") )+
  #theme(legend.position = "none")#+
   ggtitle("BMDS-Hawkes model with 6 latent dimensions")
gg

# temp lengthscales fig
h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1 <- 1/(h1n1[4,] + h1n1[3,])
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2 <- 1/(h3n2[4,] + h3n2[3,])
yam <- readRDS("output/yam_thinned.rds")
yam <- 1/(yam[4,] + yam[3,])
vic <- readRDS("output/vic_thinned.rds")
vic <- 1/(vic[4,] + vic[3,])

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg2 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5,adjust=2) +
  scale_fill_manual(values = colors[c(2,4,8,10)])+
  theme_classic() +
  ylab('Posterior density') +
  xlab('Self-excitatory temporal lengthscale (yrs)')  +
  theme(legend.position = "none")
gg2

# spatial lengthscales fig
h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1 <- 1/(h1n1[1,] + h1n1[2,])
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2 <- 1/(h3n2[1,] + h3n2[2,])
yam <- readRDS("output/yam_thinned.rds")
yam <- 1/(yam[1,] + yam[2,])
vic <- readRDS("output/vic_thinned.rds")
vic <- 1/(vic[1,] + vic[2,])

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg3 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5,adjust=2) +
  scale_fill_manual(values = colors[c(2,4,8,10)])+
  theme_classic() +
  ylab('Posterior density') +
  xlab('Self-excitatory spatial lengthscale (network units)')  +
  theme(legend.position = "none")
gg3
#ggsave('figures/DiffusionDensities.pdf',gg,device='pdf',width = 4,height = 3)


# spatial lengthscales fig
h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1 <- 1/h1n1[2,]
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2 <- 1/h3n2[2,] 
yam <- readRDS("output/yam_thinned.rds")
yam <- 1/yam[2,]
vic <- readRDS("output/vic_thinned.rds")
vic <- 1/vic[2,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg4 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5,adjust=2) +
  scale_fill_manual(values = colors[c(2,4,8,10)])+
  theme_classic() +
  ylab('') +
  xlab('Background spatial lengthscale (network units)')  +
  theme(legend.position = "none")
gg4

# temporal lengthscales fig
h1n1 <- readRDS("output/h1n1_thinned.rds")
h1n1 <- 1/h1n1[3,]
h3n2 <- readRDS("output/h3n2_thinned.rds")
h3n2 <- 1/h3n2[3,] 
yam <- readRDS("output/yam_thinned.rds")
yam <- 1/yam[3,]
vic <- readRDS("output/vic_thinned.rds")
vic <- 1/vic[3,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg5 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5,adjust=2) +
  scale_fill_manual(values = colors[c(2,4,8,10)])+
  theme_classic() +
  ylab('') +
  xlim(c(0,50))+
  xlab('Background temporal lengthscale (yrs)')  +
  theme(legend.position = "none")
gg5

ggsave(filename = "BMDSHawkesPostDensities.pdf",path="figures/",
       plot = grid.arrange(gg,gg2,gg5,gg3,gg4,ncol=2,
                           layout_matrix = cbind(c(1,2,4), c(1,3,5))))








