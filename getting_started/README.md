# boxmox_getting_started

Welcome to the world of box modelling
=====================================

It will require you to learn a bit of UNIX, but not too much.  It'll also require you to do data analysis with csv files.

The professionals will use R to do this.  I think you'll like R, as it can do loads of stuff.  Take a look at

http://davidcarslaw.github.io/openair/

and imagine making your own awesome plots, like

http://davidcarslaw.github.io/openair/reference/polarPlot.html

In fact, here is a plot I made of Shahrul's ozone data

![alt text](https://github.com/ptg21/boxmox-isoprene/blob/master/getting_started/Rplot.png)


SETUP
=====

We'll use a Cygwin UNIX environment for our work.  This has standard unix tools, loads of install options and will run on windows

Best of all, you can always delete the whole cygwin directory and start again.

install R and Rstudio if you like https://download1.rstudio.org/RStudio-1.1.442.exe 

and 

https://cran.rstudio.com/bin/windows/base/R-3.4.4-win.exe



install cygwin from http://www.cygwin.com

install notepad++

FIRST TIME WITH CYGWIN
======================

copy the setup.exe to c:\cygwin_setup

Double click on setup.

I use c:\cygwin for the main directory and c:\cygwin_downloads for the cygwin_downloads

Optional packages required for boxmox

byacc
bison
wget
gfortran
make
patch
flex

COPYING THE FILES YOU NEED
==========================

Open windows explorer, go to c:\cygwin64

In c:\cygwin64 there are a bunch of directories

Go to home/ and then into the user directory, and copy the [bashrc](../blob/master/bashrc)
and install_boxmox.bash file to there.

Start cygwin

Move the bashrc file to .bashrc by typing

```mv bashrc .bashrc```

Make sure it's picked up by typing

```bash```

Now make the boxmox install script executable by typing

```chmod +x install_BOXMOX.bash```

Now run the install script by typing

```./install_BOXMOX.bash```

Hopefully things will happen, and at the end it'll say Good to go.

RUNNING A BOX MODEL
===================

```cd boxmox/bin```

```bash prepare_BOXMOX_mechanism MOZART_4```

```bash new_BOXMOX_experiment_from_example pbl_diurnal_cycle```

```./MOZART_4.exe```

VISUALISING THE DATA
====================

You can use RStudio for this.

Open RStudio, go to the boxmox/boxmox/bin/pbl_diurnal_cycle directory and then open the plot.R file

NONE OF THIS IS MY WORK AND YOU SHOULD CREDIT THE ORIGINAL AUTHORS NOT ME!
==========================================================================

REMEMBER THAT BOXMOX IS THE WORK of Christoph Knote (LMU Munich, Germany) / Jérôme Barré (ECMWF, UK).
Register via 

https://boxmodeling.meteo.physik.uni-muenchen.de/descriptions/boxmox.html

and download via the webform to let them know you're using it.

Also, any publications arising from BOXMOX should be credited using

Main BOXMOX reference:
Knote, C., Tuccella, P., Curci, G., Emmons, L., Orlando, J. J., Madronich, S., Baro, R., Jimenez-Guerrero, P., Luecken, D., Hogrefe, C., Forkel, R., Werhahn, J., Hirtl, M., Perez, J. L., San Jose, R., Giordano, L., Brunner, D., Yahya, K., and Zhang, Y.: Influence of the choice of gas-phase mechanism on predictions of key gaseous pollutants during the AQMEII phase-2 intercomparison, Atmos. Environ., 115, 553– 568, doi:10.1016/j.atmosenv.2014.11.066, 2015.
