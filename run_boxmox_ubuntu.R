
# read in CSV data with space as separators and ignore the first two lines
env.data <- read.csv('input_data/Environment.csv', skip=3, header=TRUE, sep=' ')

init.PBL <- 1500.
# run the box model with initial conditions generated using a script
#init.temp <- 303.

for (init.temp in seq(298., 313., 5.)) {
  # create the environment data to be written
  env.data$PBLH <- init.PBL
  env.data$TEMP <- init.temp
  # write the output to a file #####
  # we first write the data that BOXMOX requires
  # note boxmox has special requirements for the first few lines, then the data come after that
  
  header = "2\n0\n0"
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
  
  #rerun me with right init cond 
  output.file <- paste("MOZART_4.0ppb_NOx","_Temp_", init.temp, sep = '')
  #output.file <- paste("MOZART_120ppb_NOx","_Temp_", init.temp, sep = '')
  
  switch(Sys.info()[['sysname']],
       Windows = {
         # run a cygwin command from within R - shouldn't be possible, and yet...
         
         bash_cmd <- "C:\\Windows\\System32\\bash.exe -c"
         
         win_user='pt_gr' # amend this, could also do the same with model etc
         
         # boxmox exprt name
         expt <- 'pbl_diurnal_cycle'
         
         # name of box model mechanism
         model <- 'MOZART_4'
         
         # move the data out of the way
         # where are the original model output
         output.dir.win <- paste('/mnt/c/Users/',
                                 win_user,
                                 '/Dropbox/projects/UKM/UKM_boxmox_PTG_version/',
                                 sep='')
         
         output.file.win <- output.file
         
         system(paste(bash_cmd,
                      '"',
                      '/home/ptg21/do_model_run.sh',
                      expt,
                      model,
                      output.dir.win,
                      output.file.win,
                      '"',
                      sep=' '))
         
       }
)

}
