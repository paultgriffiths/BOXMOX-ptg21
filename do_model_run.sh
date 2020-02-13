#!/bin/bash
# this should be put in the home directory on the Ubuntu machine

boxmox=/home/ptg21/boxmox/boxmox/bin/
expt=$1
model=$2
win_dir=$3
output_concs=$4

echo "COPY ACROSS FILES"
sleep 5
cp ${win_dir}/BOXMOX.nml ${boxmox}/${expt}/
cp ${win_dir}/InitialConditions.csv ${boxmox}/${expt}/
cp ${win_dir}/Background.csv ${boxmox}/${expt}/
cp ${win_dir}/Environment.csv ${boxmox}/${expt}/
cd  ${boxmox}/${expt}/
echo "RUN MODEL"
sleep 5
./${model}.exe
echo "COPY BACK OUTPUT"
sleep 5
mv ${model}.conc ${win_dir}/${output_concs}
