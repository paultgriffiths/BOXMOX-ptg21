# R for the R haters
# I also hate R
# but I also love it

# read in CSV data with space as separators and ignore the first two lines
env.data <- read.csv('InitialConditions.csv.bk', skip=3, header=TRUE, sep=' ')
init.no <- 10e-3
init.isop <- 50e-3
# create the environment data to be written
env.data$NO <- init.no
env.data$ISOP <- init.isop

# write the output to a file #####
# we first write the data that BOXMOX requires
# note boxmox has special requirements for the first few lines, then the data come after that

header = "11\n0\n0"
writeLines(header, "InitialConditions.csv")

# then append the data to this filebo
write.table(
  env.data,
  file = "InitialConditions.csv",
  row.names = FALSE,
  sep = " ",
  append = TRUE,
  quote = FALSE
)
output.file <- paste("MOZART_4.conc.NO_", init.no,"_ISOP_", init.isop, sep = '')
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
  output.file <- paste("/home/", user, "/boxmox/boxmox/bin/pbl_diurnal_cycle/", output.file, sep = '')

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
    
    # move the data out of the way
    system(paste("mv", "MOZART_4.conc", output.file, sep = ' '))
    
  })