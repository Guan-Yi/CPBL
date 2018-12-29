library(dplyr)
library(data.table)
library(gridExtra)
library(ggplot2)

# font type
windowsFonts(BL = windowsFont("微軟正黑體"))

# file path
setwd('C:\\Users\\Emily\\Desktop\\code\\CPBL')

# input data
data_b_2018 <- fread('CPBL_batter_2018.csv', header = T)
data_p_2018 <- fread('CPBL_pitcher_2018.csv', header = T)
data_b_2017 <- fread('CPBL_batter_2017.csv', header = T)

# remove special characters
data_b_2018$NAME <- lapply(data_b_2018$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)
data_p_2018$NAME <- lapply(data_p_2018$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)
data_b_2017$NAME <- lapply(data_b_2017$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)
data_b_2017$NAME <- lapply(data_b_2017$NAME, gsub, pattern = ' ', replacement = '', fixed = TRUE)

#outlier
data_b_2018 <- data_b_2018[data_b_2018$PA >= 50]
data_p_2018 <- data_p_2018[data_p_2018$IP >= 10]
data_b_2017 <- data_b_2017[data_b_2017$PA >= 50]

# batter
#OBP
data_b_2018$OPS <- data_b_2018$OBP + data_b_2018$SLG

# https://www.fangraphs.com/library/offense/woba/
# wOBA
data_b_2018$wOBA <- (0.69*data_b_2018$BB + 0.7*data_b_2018$HBP + 
                 0.79*data_b_2018$`1B` + 1.08*data_b_2018$`2B` + 1.39*data_b_2018$`3B` + 
                 1.76*data_b_2018$HR) / (data_b_2018$AB + data_b_2018$BB + data_b_2018$SF + data_b_2018$HBP)
# wRAA
league_wOBA <- mean(data_b_2018$wOBA)
data_b_2018$wRAA <- (data_b_2018$wOBA - league_wOBA)*data_b_2018$PA

# https://www.fangraphs.com/library/pitching/babip/
# BABIP
data_b_2018$BABIP = (data_b_2018$H - data_b_2018$HR) / (data_b_2018$AB - data_b_2018$SO- data_b_2018$HR + data_b_2018$SF)

# batter
# https://www.fangraphs.com/library/offense/rate-stats/
# K%
data_b_2018$kpercent <- data_b_2018$SO / data_b_2018$PA
# BB%
data_b_2018$bpercent <- data_b_2018$BB / data_b_2018$PA

# scatterplot
team_colour = c('yellow', 'sky blue', 'purple', 'orange')  # scale_color_manual(values = team_colour)
# wOBA vs. RBI
omap <- ggplot(data_b_2018, aes(x = RBI, y = wOBA, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3), show.legend = FALSE) + 
         geom_text(aes(label = NAME), hjust = 0.5, vjust = 1.6, size = 5, family = 'BL') +
         ggtitle('wOBA vs. RBI') + theme(text = element_text(size = 16,  family = 'BL')) + 
         scale_shape_identity()
print(omap)

# wRAA vs. G
wgmap <- ggplot(data_b_2018, aes(x = G, y = wRAA, colour = team, shape = 20, label = NAME)) +
          geom_point(aes(size = 0.3), show.legend = FALSE) + 
          geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
          xlab('G') + ylab('wRAA') + 
          ggtitle('wRAA vs. 出賽數') + theme(text = element_text(size = 16,  family = 'BL')) + 
          scale_shape_identity()
print(wgmap)

# BABIP vs. R
brmap <- ggplot(data_b_2018, aes(x = R, y = BABIP, colour = team, shape = 20, label = NAME)) +
          geom_point(aes(size = 0.3), show.legend = FALSE) + 
          geom_text(aes(label = NAME), hjust = 0.5, vjust = 1.6, size = 5, family = 'BL') +
          xlab('R') + ylab('BABIP') + 
          ggtitle('BABIP vs. R') + theme(text = element_text(size = 16,  family = 'BL')) + 
          scale_shape_identity()
print(brmap)

# Boxplot
avgbox <- ggplot(data_b_2018, aes(team, AVG, fill = team)) + 
           geom_boxplot() + 
           xlab('隊伍') + ylab('AVG') + 
           ggtitle('各隊AVG之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(avgbox)

obpbox <- ggplot(data_b_2018, aes(team, OBP, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('OBP') + 
           ggtitle('各隊OBP之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(obpbox)

slgbox <- ggplot(data_b_2018, aes(team, SLG, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('SLG') + 
           ggtitle('各隊SLG之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(slgbox)

kpercent_mean <- aggregate(kpercent ~  team, data_b_2018, mean)
kbox <- ggplot(data_b_2018, aes(team, kpercent, fill = team)) + 
         geom_boxplot() + 
         xlab('隊伍') + ylab('K%') + 
         ggtitle('各隊K%之比較') + theme(text = element_text(size = 16,  family = 'BL')) + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point') + 
         scale_fill_manual(values = team_colour)
print(kbox)

bpercent_mean <- aggregate(bpercent ~  team, data_b_2018, mean)
bbox <- ggplot(data_b_2018, aes(team, bpercent, fill = team)) + 
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
QQ <- data_b_2018$NAME[data_b_2018$wOBA <= 0.29 & data_b_2018$G > 30]
# wOBA > 0.33 ~ 0.36: above average ~ great
wow <- data_b_2018$NAME[data_b_2018$wOBA >= 0.33 & data_b_2018$G < 60]

# pitcher
# https://www.fangraphs.com/library/pitching/fip/
# FIP
fip_c = 3.1
data_p_2018$FIP = ((13*data_p_2018$HR + 3*(data_p_2018$BB + data_p_2018$IBB + data_p_2018$HBP) - 2*data_p_2018$SO) / (data_p_2018$IP)) + fip_c

#ERA+
league_ERA = mean(data_p_2018$ERA)
data_p_2018$ERAp = (league_ERA/data_p_2018$ERA)*100

# https://www.fangraphs.com/library/pitching/rate-stats/
# K/9
data_p_2018$k9 = data_p_2018$SO*9 / data_p_2018$IP
# BB/9
data_p_2018$b9 = data_p_2018$BB*9 / data_p_2018$IP

# scatterplot
# FIP vs. ERA
fmap <- ggplot(data_p_2018, aes(x = ERA, y = FIP, colour = team, shape = 20, label = NAME)) +
         geom_point(aes(size = 0.3), show.legend = FALSE) + 
         geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
         xlab('ERA') + ylab('FIP') + 
         ggtitle('FIP vs. ERA') + theme(text = element_text(size = 16,  family = 'BL')) + 
         scale_shape_identity()
print(fmap)

# FIP vs. ERA+
fepmap <- ggplot(data_p_2018, aes(x = ERAp, y = FIP, colour = team, shape = 20, label = NAME)) +
           geom_point(aes(size = 0.3), show.legend = FALSE) + 
           geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
           xlab('ERA+') + ylab('FIP') + 
           ggtitle('FIP vs. ERA+') + theme(text = element_text(size = 16,  family = 'BL')) + 
           scale_shape_identity()
print(fepmap)

# K/9 vs. BB/9
kb9map <- ggplot(data_p_2018, aes(x = k9, y = b9, colour = team, shape = 20, label = NAME)) +
           geom_point(aes(size = 0.3), show.legend = FALSE) + 
           geom_text(aes(label = NAME), hjust = 1.1, vjust = 1.1, size = 5, family = 'BL') +
           xlab('K/9') + ylab('BB/9') + 
           ggtitle('K/9 vs. BB/9') + theme(text = element_text(size = 16,  family = 'BL')) + 
           scale_shape_identity()
print(kb9map)

# Boxplot
# FIP
fipbox <- ggplot(data_p_2018, aes(team, FIP, fill = team)) +
           geom_boxplot() + 
           xlab('隊伍') + ylab('FIP') + 
           ggtitle('各隊FIP之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
           scale_fill_manual(values = team_colour)
print(fipbox)

# K/9
k9box <- ggplot(data_p_2018, aes(team, k9, fill = team)) +
          geom_boxplot() + 
          xlab('隊伍') + ylab('K/9') + 
          ggtitle('各隊K/9之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
          scale_fill_manual(values = team_colour)
print(k9box)

# BB/9
b9box <- ggplot(data_p_2018, aes(team, b9, fill = team)) +
          geom_boxplot() + 
          xlab('隊伍') + ylab('BB/9') + 
          ggtitle('各隊BB/9之比較') + theme(text = element_text(size = 16,  family = 'BL')) +
          scale_fill_manual(values = team_colour)
print(b9box)

grid.arrange(fipbox, k9box, b9box, ncol = 3)

# 2018 vs. 2017
temp_2018 <- data_b_2018[,c(2,16:18,33)]
colnames(temp_2018) <- c('NAME', 'OBP_2018', 'SLG_2018', 'AVG_2018', 'team')
temp_2017 <- data_b_2017[,c(2,16:18)]
colnames(temp_2017) <- c('NAME', 'OBP_2017', 'SLG_2017', 'AVG_2017')
temp_2018$NAME <- unlist(temp_2018$NAME)  # list -> chr
temp_2017$NAME <- unlist(temp_2017$NAME)  # list -> chr
df_bat_1718 <- left_join(temp_2018, temp_2017)
df_bat_1718 <- na.omit(df_bat_1718)

# scatter plot
avgmap <- ggplot(df_bat_1718, aes(x = AVG_2018, y = AVG_2017, shape = 20)) +
  geom_point(aes(size = 0.3), show.legend = FALSE) + 
  ggtitle('AVG: 2017 vs. 2018') + theme(text = element_text(size = 16,  family = 'BL')) + 
  scale_shape_identity() +
  geom_smooth(method = 'glm')
print(avgmap)

slgmap <- ggplot(df_bat_1718, aes(x = SLG_2018, y = SLG_2017, shape = 20)) +
  geom_point(aes(size = 0.3), show.legend = FALSE) + 
  ggtitle('SLG: 2017 vs. 2018') + theme(text = element_text(size = 16,  family = 'BL')) + 
  scale_shape_identity() +
  geom_smooth(method = 'glm')
print(slgmap)

obpmap <- ggplot(df_bat_1718, aes(x = OBP_2018, y = OBP_2017, shape = 20)) +
  geom_point(aes(size = 0.3), show.legend = FALSE) + 
  ggtitle('OBP: 2017 vs. 2018') + theme(text = element_text(size = 16,  family = 'BL')) + 
  scale_shape_identity() +
  geom_smooth(method = 'glm')
print(obpmap)

grid.arrange(avgmap, slgmap, obpmap, ncol = 2)
