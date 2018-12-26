library(dplyr)
library(ggplot2)
library(gridExtra)
library(data.table)

# path
setwd('C:\\Users\\Emily\\Desktop\\code')

# input data
rawdata <- fread('CPBL.csv', header = T)

# remove special characters
rawdata$NAME <- lapply(rawdata$NAME, gsub, pattern = '?', replacement = '', fixed = TRUE)


# wOBA, wRAA
#https://www.fangraphs.com/library/offense/woba/
rawdata$uBB <- rawdata$BB - rawdata$IBB

rawdata$wOBA <- (0.69*rawdata$uBB + 0.722*rawdata$HBP + 
                 0.888*rawdata$`1B` + 1.271*rawdata$`2B` + 1.616*rawdata$`3B` + 
                 2.101*rawdata$HR) / (rawdata$AB + rawdata$uBB + rawdata$SF + rawdata$HBP)

league_wOBA <- mean(rawdata$wOBA)
rawdata$wRAA <- (rawdata$wOBA - league_wOBA)*rawdata$PA

# K%, BB%
#https://www.fangraphs.com/library/offense/rate-stats/
rawdata$kper <- rawdata$SO / rawdata$PA
rawdata$bbper <- rawdata$BB / rawdata$PA

#outlier
rawdata <- rawdata[rawdata$G > 5]

# scatterplot
omap <- ggplot(rawdata, aes(x = wRAA, y= wOBA, colour = G, shape = 20)) +
         geom_point() +
         scale_shape_identity()
print(omap)

k <- ggplot(rawdata, aes(x = kper, y = G, colour = team)) + 
      geom_point(aes(size = 0.3)) +
      scale_shape_identity()
print(k)

# Boxplot
team_colour = c('yellow', 'sky blue', 'purple', 'orange')
avgbox <- ggplot(rawdata, aes(team, AVG, fill = team)) + geom_boxplot()
print(avgbox + scale_fill_manual(values = team_colour))

obpbox <- ggplot(rawdata, aes(team, OBP, fill = team)) + geom_boxplot()
print(obpbox + scale_fill_manual(values = team_colour))

slgbox <- ggplot(rawdata, aes(team, SLG, fill = team)) + geom_boxplot()
print(slgbox + scale_fill_manual(values = team_colour))


k_mean <- aggregate(kper ~  team, rawdata, mean)
kbox <- ggplot(rawdata, aes(team, kper, fill = team)) + 
         geom_boxplot() + 
         stat_summary(fun.y = mean, colour = 'black', geom = 'point')
print(kbox + scale_fill_manual(values = team_colour))

BB_mean <- aggregate(bbper ~  team, rawdata, mean)
bbbox <- ggplot(rawdata, aes(team, bbper, fill = team)) + 
  geom_boxplot() + 
  stat_summary(fun.y = mean, colour = 'black', geom = 'point')
print(bbbox + scale_fill_manual(values = team_colour))

kb_mean <- left_join(k_mean, BB_mean)
kb_mean <- grid.table(kb_mean)

grid.arrange(avgbox, obpbox, slgbox, kbox, bbbox, nrow = 2)

# filter
QQ <- rawdata$NAME[rawdata$wOBA < 0.3 & rawdata$G > 40]
wow <- rawdata$NAME[rawdata$wOBA > 0.34 & rawdata$G < 60]



