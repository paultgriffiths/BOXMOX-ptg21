library(ggplot2)

# make an empty data frame to hold the data
res <- data.frame(NA,NA)
names(res) <-  c("temp", "MAX_O3_PPB")

# these should match the temperature range used in the simulations
temps = c(298,328,338,348,358,368)

# read in each data file and find the max O3
for (temp in temps) {
  print(temp)
  filename <- paste("data/MOZART_4_",temp,".csv", sep='')
  data.tmp <- read.csv(filename, header=TRUE, sep="")
  o3max.tmp <- max(data.tmp$O3)*1000.
  tmp.df <- data.frame(temp, o3max.tmp)
  names(tmp.df) <- c("temp", "MAX_O3_PPB")
  res <- rbind(res, tmp.df)
}

# subset the results dataframe to remove the first line which 
# doesn't plot readily
res <- res[2:length(temps),]

# now plot - using ggplot as it makes nicer plots
temp.plot <- ggplot(data = res, 
                    mapping = aes(x = temp, y = MAX_O3_PPB)) +
  theme_linedraw(base_size = 16) +
  geom_point(size=3.5) + 
  geom_line(size=1.1) + 
  xlab('Temperature / K')+
  ylab('Max O3 on day 4 / ppbv')

print(temp.plot)
