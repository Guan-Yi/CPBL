library(dplyr)
library(ggplot2)
library(gridExtra)
library(data.table)

# file path
setwd('C:\\Users\\Emily\\Desktop\\code\\CPBL')

# input data
data_b <- fread('CPBL_batter_2018.csv', header = T)
data_p <- fread('CPBL_pitcher_2018.csv', header = T)

# remove special characters
data_b$NAME <- lapply(data_b$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)
data_p$NAME <- lapply(data_p$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)

# batter
# https://www.fangraphs.com/library/offense/woba/
# wOBA
data_b$uBB <- data_b$BB  
data_b$wOBA <- (0.69*data_b$uBB + 0.722*data_b$HBP + 
                 0.888*data_b$`1B` + 1.271*data_b$`2B` + 1.616*data_b$`3B` + 
                 2.101*data_b$HR) / (data_b$AB + data_b$uBB + data_b$SF + data_b$HBP)
# wRAA
league_wOBA <- mean(data_b$wOBA)
data_b$wRAA <- (data_b$wOBA - league_wOBA)*data_b$PA

# batter
# https://www.fangraphs.com/library/offense/rate-stats/
# K%
data_b$kpercent <- data_b$SO / data_b$PA
# BB%
data_b$bpercent <- data_b$BB / data_b$PA

# https://www.fangraphs.com/library/pitching/babip/
# BABIP
data_b$BABIP = (data_b$H - data_b$HR) / (data_b$AB - data_b$SO- data_b$HR + data_b$SF)

#outlier
data_b <- data_b[data_b$G >= 10]
data_p <- data_p[data_p$G >= 5]

# scatterplot
# wOBA vs. PA
omap <- ggplot(data_b, aes(x = PA, y = wOBA, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1) +
         scale_shape_identity()
print(omap)

# K% vs. PA
kmap <- ggplot(data_b, aes(x = PA, y = kpercent, colour = team, shape = 20, label = NAME)) + 
         geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME, hjust = 1.1, vjust = 1.1)) +
         scale_shape_identity()
print(kmap)

# BABIP vs. G
bamap <- ggplot(data_b, aes(x = G, y = BABIP, colour = team, shape = 20, label = NAME)) + 
          geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME, hjust = 1.1, vjust = 1.1)) +
          scale_shape_identity()
print(bamap)

# Boxplot
team_colour = c('yellow', 'sky blue', 'purple', 'orange')
avgbox <- ggplot(data_b, aes(team, AVG, fill = team)) + geom_boxplot()
print(avgbox + scale_fill_manual(values = team_colour))

obpbox <- ggplot(data_b, aes(team, OBP, fill = team)) + geom_boxplot()
print(obpbox + scale_fill_manual(values = team_colour))

slgbox <- ggplot(data_b, aes(team, SLG, fill = team)) + geom_boxplot()
print(slgbox + scale_fill_manual(values = team_colour))

kpercent_mean <- aggregate(kpercent ~  team, data_b, mean)
kbox <- ggplot(data_b, aes(team, kpercent, fill = team)) + 
         geom_boxplot() + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point')
print(kbox + scale_fill_manual(values = team_colour))

bpercent_mean <- aggregate(bpercent ~  team, data_b, mean)
bbox <- ggplot(data_b, aes(team, bpercent, fill = team)) + 
         geom_boxplot() + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point')
print(bbox + scale_fill_manual(values = team_colour))

kb_mean <- left_join(kpercent_mean, bpercent_mean)
kb_mean <- grid.table(kb_mean)

grid.arrange(kbox, bbox, ncol = 2)

# filter
# wOBA < 0.29: poor
QQ <- data_b$NAME[data_b$wOBA <= 0.29 & data_b$G > 30]
# wOBA > 0.33 ~ 0.36: above average ~ great
wow <- data_b$NAME[data_b$wOBA >= 0.36 & data_b$G < 60]
wow <- data_b$NAME[data_b$wOBA >= 0.33 & data_b$G < 60]

# pitcher
# https://www.fangraphs.com/library/pitching/fip/
# FIP
fip_c = 3.1
data_p$FIP = ((13*data_p$HR + 3*(data_p$BB + data_p$IBB + data_p$HBP) - 2*data_p$SO) / (data_p$IP)) + fip_c

# https://www.fangraphs.com/library/pitching/rate-stats/
# K/9
data_p$k9 = data_p$SO*9 / data_p$IP

# W + SV
# experience (1/7)
data_p$WSV = (data_p$W + 0.15*data_p$SV)

# scatterplot
# FIP vs. ERA
fmap <- ggplot(data_p, aes(x = ERA, y = FIP, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1) +
         scale_shape_identity()
print(fmap)

# FIP vs. K/9 vs. IP
fk9map <- ggplot(data_p, aes(x = FIP, y = k9, colour = team, shape = 20, label = NAME)) +
           geom_point(aes(size = IP)) + geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1) +
           scale_shape_identity()
print(fk9map)

# K/9 vs. ERA
k9map <- ggplot(data_p, aes(x = ERA, y = k9, colour = team, shape = 20, label = NAME)) +
          geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1) +
          scale_shape_identity()
print(k9map)

# K/9 vs. IP
k9ipmap <- ggplot(data_p, aes(x = IP, y = k9, colour = team, shape = 20, label = NAME)) +
            geom_point(aes(size = 0.3)) + geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1) +
            scale_shape_identity()
print(k9ipmap)

# Boxplot
FIPbox <- ggplot(data_p, aes(team, FIP, fill = team)) + geom_boxplot()
print(FIPbox + scale_fill_manual(values = team_colour))
