#!/usr/bin/env r --slave -f

prices <- read.csv("data/prices.tsv", sep="	")
png("out/pricesmooth.png", width=640, height=480)
plot(prices[,1])
