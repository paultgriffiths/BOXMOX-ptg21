#!/bin/bash


source /Users/ptg21/anaconda3/envs/basemap/bin/activate basemap

zzRoot=/Users/ptg21/projects/boxmox/bin/pbl_temp_dep/
zzModelDir=${zzRoot}model/

zzOrigDir=`pwd`
zzDataDir=${zzOrigDir}/data

pwd
for zzTemp in  298 328 338 348 358 368;do
    echo ${zzTemp}
    sed "s/TEMPK/${zzTemp}/g" Environment.inp.keepme > Environment.csv
    ./MOZART_4.exe
    cp MOZART_4.conc MOZART_4_${zzTemp}.csv 
    mv MOZART_4_${zzTemp}.csv ${zzDataDir}
done
