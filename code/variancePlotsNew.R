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

# se weights fig
h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- h1n1[5,] / (h1n1[5,] + h1n1[6,])
h3n2 <- readRDS("data/mcmc_samples/naive_h3n2_thinned.rds")
h3n2 <- h3n2[5,] / (h3n2[5,] + h3n2[6,])
yam <- readRDS("data/mcmc_samples/naive_yam_thinned.rds")
yam <- yam[5,] / (yam[5,] + yam[6,])
vic <- readRDS("data/mcmc_samples/naive_vic_thinned.rds")
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
  geom_density(alpha = 0.6,size=0.5) +
  theme_classic() +
  ylab('Posterior density') +
  xlab('Self-excitatory weight') +
  theme(legend.key.size = unit(.8, "cm") )+
  #theme(legend.position = "none")#+
   ggtitle("Spatially naive model")
gg

# temp lengthscales fig
h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- h1n1[4,]
h3n2 <- readRDS("data/mcmc_samples/naive_h3n2_thinned.rds")
h3n2 <- h3n2[4,] 
yam <- readRDS("data/mcmc_samples/naive_yam_thinned.rds")
yam <- yam[4,]
vic <- readRDS("data/mcmc_samples/naive_vic_thinned.rds")
vic <- vic[4,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg2 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5) +
  theme_classic() +
  ylab('Posterior density') +
  xlab('Self-excitatory temporal lengthscale (yrs)')  +
  theme(legend.position = "none")
gg2

# spatial lengthscales fig
h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- h1n1[1,]
h3n2 <- readRDS("data/mcmc_samples/naive_h3n2_thinned.rds")
h3n2 <- h3n2[1,] 
yam <- readRDS("data/mcmc_samples/naive_yam_thinned.rds")
yam <- yam[1,]
vic <- readRDS("data/mcmc_samples/naive_vic_thinned.rds")
vic <- vic[1,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg3 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5) +
  theme_classic() +
  ylab('Posterior density') +
  xlab('Self-excitatory spatial lengthscale (km)')  +
  theme(legend.position = "none")
gg3
#ggsave('figures/DiffusionDensities.pdf',gg,device='pdf',width = 4,height = 3)


# spatial lengthscales fig
h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- h1n1[2,]
h3n2 <- readRDS("data/mcmc_samples/naive_h3n2_thinned.rds")
h3n2 <- h3n2[2,] 
yam <- readRDS("data/mcmc_samples/naive_yam_thinned.rds")
yam <- yam[2,]
vic <- readRDS("data/mcmc_samples/naive_vic_thinned.rds")
vic <- vic[2,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg4 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5) +
  theme_classic() +
  ylab('') +
  xlab('Background spatial lengthscale (km)')  +
  theme(legend.position = "none")
gg4

# temporal lengthscales fig
h1n1 <- readRDS("data/mcmc_samples/naive_h1n1_thinned.rds")
h1n1 <- h1n1[3,]
h3n2 <- readRDS("data/mcmc_samples/naive_h3n2_thinned.rds")
h3n2 <- h3n2[3,] 
yam <- readRDS("data/mcmc_samples/naive_yam_thinned.rds")
yam <- yam[3,]
vic <- readRDS("data/mcmc_samples/naive_vic_thinned.rds")
vic <- vic[3,] 

df <- data.frame(Virus=c(rep("H1N1",length(h1n1)),
                         rep("H3N2",length(h3n2)),
                         rep("YAM",length(yam)),
                         rep("VIC",length(vic))),
                 Weight=c(h1n1,h3n2,yam,vic))

df$Virus <- factor(df$Virus)

gg5 <- ggplot(df,aes(x=Weight,fill=Virus)) +
  geom_density(alpha = 0.6,size=0.5) +
  theme_classic() +
  ylab('') +
  xlab('Background temporal lengthscale (yrs)')  +
  theme(legend.position = "none")
gg5

ggsave(filename = "NaivePostDensities.pdf",path="figures/",
       plot = grid.arrange(gg,gg2,gg5,gg3,gg4,ncol=2,
                           layout_matrix = cbind(c(1,2,4), c(1,3,5))))








