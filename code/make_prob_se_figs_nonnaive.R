setwd("~/FluHawkes/")

library(ggplot2)
library(maps)
library(ggmap)
library(dplyr)
library(grid)
register_google(key = "AIzaSyDzICiKTM1TA0Ux4bcBXFiwd1_1OMbizcg")

set.seed(1)

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

df <- readr::read_csv("data/coordinates_and_times.txt")
h1n1 <- readRDS(file = "output/post_processed/h1n1_probs_se_6.rds")
h3n2 <- readRDS(file = "output/post_processed/h3n2_probs_se_6.rds")
yam <- readRDS(file = "output/post_processed/yam_probs_se_6.rds")
vic <- readRDS(file = "output/post_processed/vic_probs_se_6.rds")
h1n1[h1n1==100] <- NA
h3n2[h3n2==100] <- NA
yam[yam==100] <- NA
vic[vic==100] <- NA
# h1n1[is.nan(h1n1)] <- NA
# h3n2[is.nan(h3n2)] <- NA
# yam[is.nan(yam)] <- NA
# vic[is.nan(vic)] <- NA


Probs <- c( rowMeans(h1n1,na.rm = TRUE),
            rowMeans(h3n2,na.rm = TRUE),
            rowMeans(vic,na.rm = TRUE),
            rowMeans(yam,na.rm = TRUE) )
# Probs[Probs=="NaN"] <- 0
df$Probs <- Probs
df <- df[,c(2,5,6,10)]
colnames(df) <- c("Year","long", "lat", "Posterior\nmean\nprobability")
df <- df[order(df$`Posterior
mean
probability`,decreasing = TRUE),]

# df$strain <- c( rep("h1n1",1161),
#                 rep("h3n2",1341),
#                 rep("vic",1195),
#                 rep("yam",1036) )
# 
# df <- df[df$strain!="vic",]

world <- map_data('world') %>% filter(region != "Antarctica") %>% fortify
gg    <- ggplot(data=world,aes(x=long,y=lat,group=group)) +
  geom_polygon(fill="white",color="black",size=0.2) + theme_void() +
  geom_jitter(data = df, aes(x=long,y=lat,color=`Posterior\nmean\nprobability`),inherit.aes = FALSE,width=3,height = 3,size=0.5,alpha=0.8) +
  scale_colour_distiller(palette="Spectral") +
  #scale_alpha_continuous(range = c(1,0.8),guide=FALSE) +
  #labs(x=NULL,y=NULL) +
  #   ggtitle("Event specific probabilities self-excitatory: BMDS-Hawkes") +
  annotate(geom="label", x=-70,y=75,color="black",label="Event specific probabilities self-excitatory: BMDS-Hawkes") +
  theme(legend.position = c(0.92, 0.65),
        legend.background = element_rect(size=0.2, linetype="solid",
                                         colour ="white",fill="white"))
gg

colors <- RColorBrewer::brewer.pal(9,"Spectral")[9:1]

gg2 <- ggplot(data = df,aes(x=`Posterior\nmean\nprobability`)) +
  #geom_density(fill=df$`Posterior\nmean\nprobability`)+
  #scale_colour_distiller(palette="Spectral") +
  geom_histogram(fill=colors,bins = 9,alpha=0.8)+ xlab("")+
  ylab("Counts") +
  theme_classic()
gg2

gg3 <- gg + inset(ggplotGrob(gg2), xmin = -190, xmax = -90, ymin = -60, ymax = 0)
gg3

ggsave(filename="world_map.pdf",plot=gg3,device="pdf",path="figures/",dpi="retina",
       width = 8,height = 4)

system2(command = "pdfcrop", 
        args    = c("~/FluHawkes/figures/world_map.pdf", 
                    "~/FluHawkes/figures/world_map.pdf") 
)

# 
# #
# ###########
# ####################
# ###########
# # dates and self excite probs
# 
# load("data/dates_and_self_excit_probs.Rdata")
# library(scales)
# library(RColorBrewer)
# library(grid)
# library(gridExtra)
# 
# gg <- ggplot(data = df2, aes(x=Date)) +
#   stat_smooth(aes(x=Date,y=Probabilities),se=FALSE,color=brewer.pal(11,"Spectral")[2]) +
#   stat_density(geom="line",aes(y=..density..*1000),adjust=2,size=1,color=brewer.pal(11,"Spectral")[10]) +
#   scale_x_date(date_breaks = "2 year",
#                labels = date_format("%Y")) +
#   xlab("Year") + ylab("") +
#   annotate(geom="text", x=df2$Date[38000],y=0.075,color=brewer.pal(11,"Spectral")[2],label="Self-excitatory probabilities") +
#   annotate(geom="segment", x=df2$Date[12000],xend =df2$Date[22000],y=0.075,yend=0.075,color=brewer.pal(11,"Spectral")[2],size=1.5) +
#   annotate(geom="text", x=df2$Date[37500],y=0.06,color=brewer.pal(11,"Spectral")[10],label="Gunshot density (x1000)") +
#   annotate(geom="segment", x=df2$Date[12000],xend =df2$Date[22000],y=0.06,yend=0.06,color=brewer.pal(11,"Spectral")[10],size=1.5) +
#   theme_classic()
# 
# gg

# ggsave(plot=gg, filename = "year_se_probs",device = "pdf",path="figures/")
# 
# 
# 
# ggsave(filename = "combined_year_map.png", grid.arrange(dcMap,gg,ncol=2),
#        device = "png",path="figures/" ,width = 9,height = 4,dpi="retina")
# 
# 
# 
# 
# 
# 




