# R for the R haters
# I also hate R
# but I also love it

# read in CSV data with space as separators and ignore the first two lines
env.data <- read.csv('Environment.csv.bk', header=TRUE, skip = 3, sep=' ')

#
# for Dr Fatimah - not strictly relevant ####
#

# generate mean of columns
apply(env.data, MARGIN=2, FUN = mean)

# function to generate a new temperature diurnal profile
temp.diurnal <- function(offset, amplitude, period, time){
  # this function works with an input vector (time)
  # ifelse uses condition, if condition met, if condition not met
  ifelse (time>6. & time < 18., offset+amplitude*sin(2*pi*(time-6)/(period)), offset)
}

# nb that R has two ways of dealing with things
# 1. if the input is a vector - then use ifelse (anthing with dataframes)
# 2. if the input is a numeric

temp.diurnal.2 <- function(offset, amplitude, period, time){
  # this function works with an input value
  if (time>6. & time <18.){ 
    offset+amplitude*sin(2*pi*(time-6.)/(period))} else
    offset
}

#
# PLOT THE OUTPUT ####
# 

# this will work as the input (time) is a vector
plot(temp.diurnal(offset=298., amplitude = 10., period=24., env.data$time))

# the code below won't work because the input is a vector
# if you look at the error message if you do run it
# you'll see R can't cope ('only the first element will be used') 
# plot(temp.diurnal.2(offset=298., amplitude = 10., period=24., 1:24))

#
# generate the output data ####
#
# with 10 K amplitude
env.data$TEMP <- temp.diurnal(offset=298., amplitude = 10., period=24., env.data$time)

#or

# with constant T (ie amplitude = 0.)
env.data$TEMP <- temp.diurnal(offset=298., amplitude = 0., period=24., env.data$time)

#
# write the output to a file #####
# 
# we first write the data that BOXMOX requires
# note boxmox has special requirements for the first few lines, then the data come after that
header="2\n0\n2"
writeLines(header,"Environment.csv")
# then append the data to this file
write.table(env.data, file ="Environment.csv", row.names=FALSE, sep=" ", append=TRUE, quote = FALSE)
