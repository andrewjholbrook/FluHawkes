setwd("~/FluHawkes/")
library(stringr)

# locations_times <- read_table2("data/locations_times.txt", 
#                                col_names = FALSE)
# N <- dim(locations_times)[1]
# 
# # add decimals first
# times_as_chars <- as.character(locations_times$X2)
# times_as_chars <- str_remove_all(times_as_chars,"\\.")
# times_as_chars <- gsub('^(.{4})(.*)$', '\\1.\\2', times_as_chars)
# locations_times$X2 <- as.numeric(times_as_chars)
# 
# # remove year only data
# to_remove <- which(locations_times$X2 %% 1 ==0)
# names_to_remove <- locations_times$X1[locations_times$X2 %% 1 == 0]
# 
# #write.csv(to_remove,file = "data/xml_order_to_remove.csv",quote = FALSE,col.names = FALSE,row.names = FALSE)
# #write.csv(names_to_remove,file = "data/xml_names_to_remove.csv",quote = FALSE,col.names = FALSE,row.names = FALSE)
# 
# 
# locations_times <- locations_times[locations_times$X2 %% 1 !=0,]
# #write.table(locations_times,file = "data/locations_times.txt",quote=FALSE,row.names = FALSE,col.names = FALSE)
# 
# # remove items from deffs
# #read.csv("data/xml_names_to_remove.csv")
# flu.combi <- read.csv("data/newDeffs.txt", header=FALSE, skip=1, sep="\t")
# rownames(flu.combi) <- flu.combi[, 1]
# flu.combi <- flu.combi[, -1]
# colnames(flu.combi) <- rownames(flu.combi)
# 
# keepers <- ! colnames(flu.combi) %in% names_to_remove
# flu.combi <- flu.combi[keepers,keepers]
# 
# #write.table(flu.combi, "data/fluCombi_Deff_reordered_noyrs.txt", sep = "\t",quote = FALSE)
# 
# dim(flu.combi)
# 
# subtype <- c(rep("h1n1",1161),
#              rep("h3n2",1341),
#              rep("vic",1195),
#              rep("yam",1036))
# 
# df <- data.frame(taxa=colnames(flu.combi)[1:4733],subtype)
# 
# colnames(locations_times)[1] <- "taxa"
# df <- merge(df,locations_times,by="taxa")
# 
# df$type <- as.numeric(df$subtype)
# df <- df[order(df$type,df$X2),]
# write.table(df, "data/rereordered.txt", sep = "\t",quote = FALSE)
# 
# 
# names <- as.character(df$taxa)
# new.col.names <- c(names,colnames(flu.combi)[-(1:4733)])
# 
# flu.combi <- flu.combi[, new.col.names]
# flu.combi <- flu.combi[new.col.names, ]
# #flu.combi <- flu.combi[1:5392,1:5392]
# write.table(flu.combi, "data/rereorderedDeffs.txt", sep = "\t",quote = FALSE)

# one more try
Exper_names <- read_table2("data/Exper_names.txt", col_names = FALSE)
Exper_names <- as.character(Exper_names)

flu.combi <- read.csv("data/rereorderedDeffs.txt", header=FALSE, skip=1, sep="\t")
rownames(flu.combi) <- flu.combi[, 1]
flu.combi <- flu.combi[, -1]
colnames(flu.combi) <- rownames(flu.combi)
#names <- scan("data/names.txt", what = character(), sep = "\t")
#new.col.names <- c(names, colnames(flu.combi)[-(1:5392)])
flu.combi <- flu.combi[, Exper_names]
flu.combi <- flu.combi[Exper_names, ]
#flu.combi <- flu.combi[1:5392,1:5392]
write.table(flu.combi, "data/rerereorderedDeffs.txt", sep = "\t",quote = FALSE)

# update location_times
locations_times <- read_table2("data/locations_times.txt", col_names = FALSE)

row.names(locations_times) <- locations_times$X1
locations_times <- locations_times[Exper_names,]

write.table(locations_times,file = "data/locations_times.txt",quote=FALSE,row.names = FALSE,col.names = FALSE)

