library(plyr)
library(ggplot2)
obs=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/weather station aspa jan2015-12jan20172.csv')
obs$Time <- as.POSIXct(obs$TIMESTAMP, format = "%d/%m/%Y %H:%M")
obs$TIMESTAMP <- NULL
# obs <-
#   subset(
#     obs,
#     obs$TIMESTAMP >= as.POSIXct("2016-12-03 23:59") &
#       +obs$TIMESTAMP <= as.POSIXct("2016-12-14 23:59")
#   )
isop.dec=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/Isoprene_OilPalm_dec16.csv')
isop.dec <- data.frame(isop.dec$Date.Time,isop.dec$Isoprene.mixing.ratio)
names(isop.dec) <- c("Time","Isoprene")
isop.dec$Time <- as.POSIXct(isop.dec$Time, format = "%d/%m/%Y %H:%M")

isop.jan=read.csv('/Users/ptg21/projects/boxmox/bin/pbl_isoprene/data/Isoprene_OilPalm_jan16.csv')
isop.jan <- data.frame(isop.jan$Date.Time,isop.jan$Isoprene.mixing.ratio)
names(isop.jan) <- c("Time","Isoprene")
isop.jan$Time <- as.POSIXct(isop.jan$Time, format = "%d/%m/%Y %H:%M")


isop <- rbind(isop.dec,isop.jan)
all <- merge(isop,obs, by="Time")
fit <- lm(all$Isoprene ~ all$LogrTmpC_Max + all$WindDir_Avg, data=all)
min_temp <- min(all$LogrTmpC_Max, na.rm=TRUE)
max_temp <- max(all$LogrTmpC_Max, na.rm=TRUE)

min_wind <- min(all$WindDir_Avg, na.rm=TRUE)
max_wind <- max(all$WindDir_Avg, na.rm=TRUE)

isopemiss <- function(temp,winddir) {
return (-20.7+0.82*temp+0.005*winddir)
}
pt1 <- isopemiss(min_temp,min_wind)
pt2 <- isopemiss(max_temp,max_wind)


plot(all$AirTempC_Avg,all$Isoprene, pch=19, col='red', ylab='Isoprene mixing ratio / ppbv', xlab='Temp / degrees C')
lines(c(min_temp,max_temp),c(pt1,pt2),lw=2,lty=3)

