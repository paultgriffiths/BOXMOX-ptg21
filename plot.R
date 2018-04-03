#******************************************************************************
# BOXMOX PBL diurnal cycle case
# Christoph Knote - 11/2015
#******************************************************************************

# plots results from the PBL diurnal evolution simulation

dat <- read.csv("MOZART_4.conc", header=TRUE, sep="")
emi <- read.csv("Emissions.csv", header=TRUE, sep="", skip=3)
pht <- read.csv("PhotolysisRates.csv", header=TRUE, sep="", skip=3)
env <- read.csv("Environment.csv", header=TRUE, sep="", skip=3)

speccols <- c(O3="black", "Ox"="purple", NOx="red", CH2O="green", HNO3="ISOP", N2O5="pink")

dat[names(dat) != "time"] <- dat[names(dat) != "time"] * 1e3

png(file="pbl_diurnal_cycle.png", width=7, height=4, units="in", res=144)
par(mar=c(4,2.75,2.5,2.75), mgp=c(2,1,0))
plot(dat$time, dat$O3, type="l", ylim=c(0, max(dat$O3)*500.), xlab="time (h)",
    ylab="", xaxs="i", yaxs="i", axes=FALSE, col=speccols["O3"],
    main="PBL diurnal evolution")
grid(lwd=0.4)
nox <- dat$NO + dat$NO2
ox <- dat$O3 + dat$NO2
scaler <- 19+1/3
lines(dat$time, ox, col=speccols["Ox"], lty=3, lw=2)
lines(dat$time, nox*scaler, col=speccols["NOx"])
lines(dat$time, dat$CH2O*scaler, col=speccols["CH2O"])
#lines(dat$time, dat$N2O5*scaler, col=speccols["N2O5"])
lines(dat$time, dat$ISOP*scaler, col=speccols["ISOP"])
lines(env$time, env$PBLH/1e2, lwd=4, col=rgb(0,0,1, alpha=0.3))

simhours <- 1:max(floor(dat$time))
lines(simhours, rep(emi$NO/max(emi$NO)*0.75*par("usr")[4], length.out=length(simhours)),
        col="grey", lty=2)

lines(simhours, rep(pht$no2/max(pht$no2)*0.8*par("usr")[4], length.out=length(simhours)),
    col="yellow", lty=3, lwd=2)


legend("top", cex=0.8, legend=c(
        expression(c(O[3])),
        expression(c(O[x])),
        expression(c(NO[x])),
        expression(c(CH[2]*O)),
#        expression(c(N[2]*O[5])),
        expression(c(ISOP)),
        expression(NO[x]~emissions),
        expression(J[NO[2]]),
"PBL HT / m "
),
        lty=c(1,3,1,1,1,1,2,1),
        lwd=c(1,2,1,1,1,1,1,3),
    col=c(speccols[c("O3", "Ox", "NOx", "CH2O", "N2O5", "ISOP")], "grey",  rgb(0,0,1, alpha=0.3)), bty="n",
    ncol=4, xpd=NA, inset=-0.0)

mtext(side=3, line=0.25, adj=-0.1, text=expression(O[3]/O[x]~(ppbv)))
mtext(side=3, line=0.25, adj=1.1,  text=expression(others~(ppbv)))

for(var in seq(0,4)){
x0 <- var*24-3
x1 <- var*24+6
y0 <- 0
y1 <- 55
rect(x0,y0,x1,y1, col= rgb(0,0,0,alpha=0.4), lty=0)
}
axis(1, at=seq(0, max(dat$time), by=6))
axis(2, las=2)
axis(side=4, at=axTicks(2), labels=axTicks(2)/scaler, las=2)

dev.off()
png(file="pbl_diurnal_height.png", width=7, height=4, units="in", res=144)
plot(simhours, rep(env$PBLH, length.out=length(simhours)),
      col="red", lty=1, lwd=3, "l", xlab="time (h)", ylab="PBL height / m", ylim = c(0,2000))

for(var in seq(0,4)){
  x0 <- var*24-3
  x1 <- var*24+6
  y0 <- 0
  y1 <- 2.5e3
  rect(x0,y0,x1,y1, col= rgb(0,0,0,alpha=0.4), lty=0)
}
dev.off()
