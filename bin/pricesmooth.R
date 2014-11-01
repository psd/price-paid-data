#!/usr/bin/env r --slave -f

library(ggplot2)

prices <- read.csv("data/prices.tsv", sep="	")
#png("out/pricesmooth.png", width=640, height=480)
#plot(prices[,1], prices[2], ylim(0, 600000), col="#c8c8c8", span=0.5,)

ggplot(prices, aes(p[,1], p[,2])
