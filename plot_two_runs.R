library(ggplot2)

data.1 <- read.csv("MOZART_4.conc.NO_1_ISOP_0.1", header=TRUE, sep="")
data.2 <- read.csv("MOZART_4.conc.NO_2_ISOP_0.1", header=TRUE, sep="")
plot(data.1$NO, type='l', ylim=c(0,2))
points(data.2$NO)
data.1 <- read.csv("MOZART_4.conc.NO_1_ISOP_0.1", header=TRUE, sep="")
data.2 <- read.csv("MOZART_4.conc.NO_1_ISOP_0.5", header=TRUE, sep="")

ggplot(data.1,aes(x=data.1$time,y=data.1$ISOP))+geom_line(aes(color="ISOP_LOW"), size=4, alpha=0.8)+
  geom_line(data=data.2,aes(x=data.2$time,y=data.2$ISOP,color="ISOP HIGH"))+
  labs(color="Runs")
