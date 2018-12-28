library(dplyr)
library(data.table)
library(gridExtra)
library(ggplot2)

# font type
windowsFonts(BL = windowsFont("微軟正黑體"))

# file path
setwd('C:\\Users\\Emily\\Desktop\\code\\CPBL')

# input data
data_b <- fread('CPBL_batter_2018.csv', header = T)
data_p <- fread('CPBL_pitcher_2018.csv', header = T)

# remove special characters
data_b$NAME <- lapply(data_b$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)
data_p$NAME <- lapply(data_p$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)

#outlier
data_b <- data_b[data_b$G >= 8]
data_p <- data_p[data_p$G >= 8]

# batter
# https://www.fangraphs.com/library/offense/woba/
# wOBA
data_b$uBB <- data_b$BB  
data_b$wOBA <- (0.69*data_b$uBB + 0.7*data_b$HBP + 
                 0.79*data_b$`1B` + 1.08*data_b$`2B` + 1.39*data_b$`3B` + 
                 1.76*data_b$HR) / (data_b$AB + data_b$uBB + data_b$SF + data_b$HBP)
# wRAA
league_wOBA <- mean(data_b$wOBA)
data_b$wRAA <- (data_b$wOBA - league_wOBA)*data_b$PA

# https://www.fangraphs.com/library/pitching/babip/
# BABIP
data_b$BABIP = (data_b$H - data_b$HR) / (data_b$AB - data_b$SO- data_b$HR + data_b$SF)

# batter
# https://www.fangraphs.com/library/offense/rate-stats/
# K%
data_b$kpercent <- data_b$SO / data_b$PA
# BB%
data_b$bpercent <- data_b$BB / data_b$PA

# scatterplot
team_colour = c('yellow', 'sky blue', 'purple', 'orange')  # scale_color_manual(values = team_colour)
# wOBA vs. PA
omap <- ggplot(data_b, aes(x = PA, y = wOBA, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3), show.legend = FALSE) + 
         geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
         ggtitle('wOBA vs. PA') + theme(text = element_text(size = 16,  family = 'BL')) + 
         scale_shape_identity()
print(omap)

# K% vs. PA
kmap <- ggplot(data_b, aes(x = PA, y = kpercent, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3), show.legend = FALSE) + 
         geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
         xlab('PA') + ylab('K%') + 
         ggtitle('K% vs. PA') + theme(text = element_text(size = 16,  family = 'BL')) + 
         scale_shape_identity()
print(kmap)

# K% vs. BB%
kbmap <- ggplot(data_b, aes(x = kpercent, y = bpercent, colour = team, shape = 20, label = NAME)) +
          geom_point(aes(size = 0.3), show.legend = FALSE) + 
          geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
          xlab('K%') + ylab('BB%') + 
          ggtitle('K% vs. BB%') + theme(text = element_text(size = 16,  family = 'BL')) + 
          scale_shape_identity()
print(kbmap)

# BABIP vs. G
bgmap <- ggplot(data_b, aes(x = BABIP, y = G, colour = team, shape = 20, label = NAME)) +
          geom_point(aes(size = 0.3), show.legend = FALSE) + 
          geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
          xlab('BABIP') + ylab('出賽場數') + 
          ggtitle('BABIP vs. 出賽場數') + theme(text = element_text(size = 16,  family = 'BL')) + 
          scale_shape_identity()
print(bgmap)

# Boxplot
avgbox <- ggplot(data_b, aes(team, AVG, fill = team)) + 
           geom_boxplot() + 
           xlab('隊伍') + ylab('AVG') + 
           ggtitle('各隊AVG之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(avgbox)

obpbox <- ggplot(data_b, aes(team, OBP, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('OBP') + 
           ggtitle('各隊OBP之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(obpbox)

slgbox <- ggplot(data_b, aes(team, SLG, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('SLG') + 
           ggtitle('各隊SLG之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(slgbox)

kpercent_mean <- aggregate(kpercent ~  team, data_b, mean)
kbox <- ggplot(data_b, aes(team, kpercent, fill = team)) + 
         geom_boxplot() + 
         xlab('隊伍') + ylab('K%') + 
         ggtitle('各隊K%之比較') + theme(text = element_text(size = 16,  family = 'BL')) + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point') + 
         scale_fill_manual(values = team_colour)
print(kbox)

bpercent_mean <- aggregate(bpercent ~  team, data_b, mean)
bbox <- ggplot(data_b, aes(team, bpercent, fill = team)) + 
         geom_boxplot() + 
         xlab('隊伍') + ylab('BB%') + 
         ggtitle('各隊BB%之比較') + theme(text = element_text(size = 16,  family = 'BL')) + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point') +
         scale_fill_manual(values = team_colour)
print(bbox)

grid.arrange(avgbox, obpbox, slgbox, ncol = 3) 
grid.arrange(kbox, bbox, ncol = 2)

# filter
# wOBA < 0.29: poor
QQ <- data_b$NAME[data_b$wOBA <= 0.29 & data_b$G > 30]
# wOBA > 0.33 ~ 0.36: above average ~ great
wow <- data_b$NAME[data_b$wOBA >= 0.33 & data_b$G < 60]

# pitcher
# https://www.fangraphs.com/library/pitching/fip/
# FIP
fip_c = 3.1
data_p$FIP = ((13*data_p$HR + 3*(data_p$BB + data_p$IBB + data_p$HBP) - 2*data_p$SO) / (data_p$IP)) + fip_c

# https://www.fangraphs.com/library/pitching/rate-stats/
# K/9
data_p$k9 = data_p$SO*9 / data_p$IP
# BB/9
data_p$b9 = data_p$BB*9 / data_p$IP

# scatterplot
# FIP vs. ERA
fmap <- ggplot(data_p, aes(x = ERA, y = FIP, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3), show.legend = FALSE) + 
         geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
         xlab('ERA') + ylab('FIP') + 
         ggtitle('ERA vs. FIP') + theme(text = element_text(size = 16,  family = 'BL')) + 
         scale_shape_identity()
print(fmap)

# FIP vs. K/9
fk9map <- ggplot(data_p, aes(x = k9, y = FIP, colour = team, shape = 20, label = NAME)) +
           geom_point(aes(size = 0.3), show.legend = FALSE) + 
           geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
           xlab('K/9') + ylab('FIP') + 
           ggtitle('K/9 vs. FIP') + theme(text = element_text(size = 16,  family = 'BL')) + 
           scale_shape_identity()
print(fk9map)

# K/9 vs. BB/9
kb9map <- ggplot(data_p, aes(x = k9, y = b9, colour = team, shape = 20, label = NAME)) +
           geom_point(aes(size = 0.3), show.legend = FALSE) + 
           geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
           xlab('K/9') + ylab('BB/9') + 
           ggtitle('K/9 vs. BB/9') + theme(text = element_text(size = 16,  family = 'BL')) + 
           scale_shape_identity()
print(kb9map)

# Boxplot
fipbox <- ggplot(data_p, aes(team, FIP, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('FIP') + 
           ggtitle('各隊FIP之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(fipbox)

k9box <- ggplot(data_p, aes(team, k9, fill = team)) +
          geom_boxplot() + 
          xlab('隊伍') + ylab('K/9') + 
          ggtitle('各隊K/9之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
          scale_fill_manual(values = team_colour)
print(k9box)

b9box <- ggplot(data_p, aes(team, b9, fill = team)) +
          geom_boxplot() + 
          xlab('隊伍') + ylab('BB/9') + 
          ggtitle('各隊BB/9之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
          scale_fill_manual(values = team_colour)
print(b9box)

grid.arrange(k9box, b9box, ncol = 2)
