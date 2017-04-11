#!/bin/bash
#PBS -N gzip
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR


# Optionnal gzip data
for i in $(ls 02_data/*.f*q)
do
gzip $i
done


