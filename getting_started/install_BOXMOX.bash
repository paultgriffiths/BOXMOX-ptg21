#!/bin/bash

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# BOXMOX extensions to KPP - installation script
#
# execute as
# me@mymachine> bash install_BOXMOX.bash
#
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
#
# 1.0 Christoph Knote - NCAR/ACD - knote@ucar.edu - 06/2014
# 1.1 Christoph Knote - NCAR/ACD - knote@ucar.edu - 07/2014
#     updates to the MOZART mechanism
# 1.2 Christoph Knote - LMU - christoph.knote@lmu.de - 08/2015
#     various updates to BOXMOX
# 1.3 Christoph Knote - LMU - christoph.knote@lmu.de - 11/2015
#     new Namelist feature, various code updates
# 1.4 Christoph Knote - LMU - christoph.knote@lmu.de - 09/2016
#     included MCM and other mechanisms, code updates
# 1.5 Christoph Knote - LMU - christoph.knote@lmu.de - 11/2016
#     new commands included for simplified usage, code updates
# 1.6 Christoph Knote - LMU - christoph.knote@lmu.de - 02/2017
#     ability to create adjoint using prepare_BOXMOX_mechanism
# 1.6.1 Christoph Knote - LMU - christoph.knote@lmu.de - 02/2017
#     bugfix release
# 1.7 Christoph Knote - LMU - christoph.knote@lmu.de - 12/2017
#     new file format, heterogeneous reactions/aerosol, dilution
#
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# USER SECTION

# This is where your BOXMOX will be
boxmoxDir=$HOME/boxmox

# your C compiler - gcc should be fine on most systems
CC=gcc

# the FLEX lexical analyzer - check via "which flex"
FLEX=/usr/bin/flex

# the FLEX library directory - on Linux try via "type -a libfl.a",
# if this fails it is usually somewhere close to the binary (e.g. in ../lib)
FLEX_LIB_DIR=/usr/lib

# your C compiler flags (if any). Note: separate multiple arguments by spaces and enclose in quotation marks.
CC_FLAGS=-g

# standard headers
INCLUDE_DIR=/usr/include

# possibly working configuration with Mac OS X Sierra (10.12),
# flex installed via homebrew, and Xcode (and developer command line tools)
# installed:
# CC=gcc
# FLEX=/usr/local/opt/flex/bin/flex
# FLEX_LIB_DIR=/usr/local/opt/flex/lib
# CC_FLAGS="-g -I/usr/include/malloc/ -D_FORTIFY_SOURCE=0"
# INCLUDE_DIR=/usr/include

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# nothing to be changed beyond this point...

boxmoxVersion=1.7

# see if we have everything we need
hash wget >/dev/null 2>&1     || { echo "BOXMOX installer needs 'wget'"; exit 1; }
hash tar >/dev/null 2>&1      || { echo "BOXMOX installer needs 'tar'"; exit 1; }
hash patch >/dev/null 2>&1    || { echo "BOXMOX installer needs 'patch'"; exit 1; }
hash sed >/dev/null 2>&1      || { echo "BOXMOX installer needs 'sed'"; exit 1; }
hash make >/dev/null 2>&1     || { echo "BOXMOX installer needs 'make'"; exit 1; }

# see if the given options make sense
hash $CC >/dev/null 2>&1      || { echo "C compiler $CC unknown"; exit 1; }
[ -f $FLEX ]                  || { echo "No FLEX executable found at $FLEX"; exit 1; }
[ -f $FLEX_LIB_DIR/libfl.a ]  || { echo "No FLEX library found in $FLEX_LIB_DIR"; exit 1; }
[ -d $INCLUDE_DIR ]           || { echo "No include directory found at $INCLUDE_DIR"; exit 1; }

#[ -d $boxmoxDir ]             && { echo "BOXMOX directory $boxmoxDir already exists"; exit 1; }

hash gfortran >/dev/null 2>&1 || { echo "Note: BOXMOX will need 'gfortran' or another Fortran compiler.";  }

# current KPP version
kppURL=http://people.cs.vt.edu/~asandu/Software/Kpp/Download/kpp-2.2.3_Nov.2012.tar.gz

# current BOXMOX patch
boxmoxURL=https://boxmodeling.meteo.physik.uni-muenchen.de/downloads/boxmox_${boxmoxVersion}_2.2.3.patch

# let's go - describe what's gonna happen
echo " "
echo "BOXMOX extension to KPP (${boxmoxVersion})"
echo " "
echo "Output directory: $boxmoxDir"
echo "C compiler:       $CC"
echo "C compiler flags: $CFLAGS"
echo "FLEX binary:      $FLEX"
echo "FLEX library:     $FLEX_LIB_DIR/libfl.a"
echo " "

[ -z $KPP_HOME ] || { echo "The KPP_HOME variable is set (to '${KPP_HOME}'), it seems there is already another KPP/BOXMOX installation. Make sure to update your \$KPP_HOME and \$PATH variables after this new installation."; echo ""; }

mkdir -p $boxmoxDir || { echo "Could not create BOXMOX directory $boxmoxDir"; exit 1; }

cd $boxmoxDir

echo "Downloading BOXMOX"
#wget --no-check-certificate -o boxmox_download.log -O boxmox.patch $boxmoxURL || { echo "Could not download BOXMOX patch"; exit 1; }

echo "Downloading KPP"
#wget --no-check-certificate -o kpp_download.log -O kpp.tar.gz $kppURL || { echo "Could not download KPP"; exit 1; }


echo "Unpacking KPP"
tar xzf kpp.tar.gz || { echo "Could not unpack KPP"; exit 1; }

# get KPP out of its subfolder and add bin directory
subfolder=$(tar tf kpp.tar.gz)
subfolder=( $subfolder )
subfolder=${subfolder[0]}
mv $subfolder/* .
rm -r $subfolder
mkdir -p bin

echo "Patching KPP"
patch -p1 < boxmox.patch > kpp_patch.log || { echo "Could not patch KPP"; exit 1; }

mv Makefile.defs Makefile.defs.BACK

sed "s|CC=.*|CC=$CC|;s|CC_FLAGS=.*|CC_FLAGS=$CC_FLAGS|;s|FLEX=.*|FLEX=$FLEX|;s|FLEX_LIB_DIR=.*|FLEX_LIB_DIR=$FLEX_LIB_DIR|;s|INCLUDE_DIR = .*|INCLUDE_DIR = $INCLUDE_DIR|" Makefile.defs.BACK > Makefile.defs
[[ $? ]] || { echo "Could not patch Makefile.defs"; exit 1; }

echo "Compiling KPP"
make &> kpp_compile.log
[ -f bin/kpp ] || { echo "Could not compile KPP - see kpp_compile.log"; exit 1; }

echo "Exchanging models and examples directories with BOXMOX-ready mechanisms"
mv examples examples_original; ln -s boxmox/examples examples
mv models models_original;     ln -s boxmox/models   models

echo "Setting the execute bit for user commands"
chmod +x $boxmoxDir/boxmox/bin/*

if hash pdflatex >/dev/null 2>&1
then
  echo "Tex'ing BOXMOX readme (boxmox/README.pdf)"
  cd $boxmoxDir/boxmox
  pdflatex README.tex > ../readme_texing.log
  pdflatex README.tex > ../readme_texing.log
fi

echo " "
echo " --- YOU ARE GOOD TO GO ---"
echo " "
echo "Remember to copy the following lines into"
echo "your .bashrc (a hidden file in your home directory)"
echo "so they are executed upon login:"
echo " "
echo "export KPP_HOME=$boxmoxDir"
echo "export PATH=\$KPP_HOME/bin:\$KPP_HOME/boxmox/bin:\$PATH"
echo " "
