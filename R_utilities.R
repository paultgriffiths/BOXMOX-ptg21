# R for the R haters
# I also hate R
# but I also love it

# read in CSV data with space as separators and ignore the first two lines
env.data <- read.csv('Environment.csv', header=TRUE, skip = 3, sep=' ')

# function to generate a new temperature diurnal profile
temp.diurnal <- function(offset, amplitude, period, time){
  # this function works with an input vector (time)
  # ifelse uses condition, if condition met, if condition not met
  ifelse (time>6. & time < 18., offset+amplitude*sin(2*pi*(time-6)/(period)), offset)
}

# run the box model with initial conditions generated using a script
for (temp in seq(298., 338., 10.)) {
  # create the environment data to be written
  env.data$TEMP <-
    temp.diurnal(
      offset = temp,
      amplitude = 10.,
      period = 24.,
      env.data$time
    )
  
  
  # write the output to a file #####
  # we first write the data that BOXMOX requires
  # note boxmox has special requirements for the first few lines, then the data come after that
  
  header = "2\n0\n2"
  writeLines(header, "Environment.csv")
  
  # then append the data to this filebo
  write.table(
    env.data,
    file = "Environment.csv",
    row.names = FALSE,
    sep = " ",
    append = TRUE,
    quote = FALSE
  )
  
  switch(Sys.info()[['sysname']],
         Windows = {
           # run a cygwin command from within R - shouldn't be possible, and yet...
           
           # will use cygwin to run
           cmd <- 'c:\\cygwin64\\bin\\run.exe'
           
           # add a user variable
           user='pt_gr' # amend this, could also do the same with model etc
           
           # location of executables - won't work without this
           path <-  paste('/home/', user, '/boxmox/bin:/home/', user, '/boxmox/boxmox/bin:/usr/local/bin:/usr/bin:',sep='')
           
           # location of the box model
           model <- paste('/home/', user, '/boxmox/boxmox/bin/pbl_diurnal_cycle/MOZART_4.exe', sep='') 
           
           # run the model
           system(paste(cmd, "-p", path, model, "-wait", sep=' '))
           
           # filename to move the data to - change the directory
           output.file <- paste("/home/", user, "/boxmox/boxmox/bin/pbl_diurnal_cycle/MOZART_4.conc.temp_", temp, sep = '')
           
           # move the data out of the way
           cmd <- "c:\\cygwin64\\bin\\bash.exe -l -c 'mv"
           # where are the original model output
           data.file <- paste("/home/",user,"/boxmox/boxmox/bin/pbl_diurnal_cycle/MOZART_4.conc", sep='')
           
           # move the data to its new location using mv
           system(paste(cmd, data.file, output.file, "'", sep = ' '))
         },
         
         
         Darwin = {
           # run boxmox
           system("./MOZART_4.exe", wait = TRUE)
           
           # filename to move the data to
           outfile <- paste("MOZART_4.conc.temp_", temp, sep = '')
           
           # move the data out of the way
           system(paste("mv", "MOZART_4.conc", outfile, sep = ' '))
         })
  
  
}
