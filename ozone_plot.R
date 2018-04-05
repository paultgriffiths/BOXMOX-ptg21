library(plyr)
library(ggplot2)
library(zoo)
library(openair)
met=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/weather station aspa jan2015-12jan20172.csv')
met$Time <- as.POSIXct(met$TIMESTAMP, format = "%d/%m/%Y %H:%M")
met$TIMESTAMP <- NULL

obs.isop.dec=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/Isoprene_OilPalm_dec16.csv')
obs.isop.dec <- data.frame(obs.isop.dec$Date.Time, obs.isop.dec$Isoprene.mixing.ratio)
names(obs.isop.dec) <- c("Time","Isoprene")
obs.isop.dec$Time <- as.POSIXct(obs.isop.dec$Time, format = "%d/%m/%Y %H:%M")

obs.isop.jan=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/Isoprene_OilPalm_jan16.csv')
obs.isop.jan <- data.frame(obs.isop.jan$Date.Time, obs.isop.jan$Isoprene.mixing.ratio)
names(obs.isop.jan) <- c("Time","Isoprene")
obs.isop.jan$Time <- as.POSIXct(obs.isop.jan$Time, format = "%d/%m/%Y %H:%M")

obs.o3 <- read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/O3_OilPalm_dec16.csv')
obs.o3 <- data.frame(obs.o3$Date.Time,obs.o3$Ozone.mixing.ratio)
names(obs.o3) <- c("Time","Ozone")
obs.o3$Time <- as.POSIXct(obs.o3$Time, format = "%d/%m/%Y %H:%M")

obs <- rbind(obs.isop.dec, obs.isop.jan)
all.isop <- merge(obs,met, by="Time")
all.o3 <- merge(obs.o3,met, by="Time")
polarPlot(all, pollutant = 'Ozone',wd='WindDir_Avg', x='WindSpd_ms_Avg',main='Ozone data')

