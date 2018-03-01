#!/bin/bash
#PBS -N gmap_index
#PBS -o gmap_index.out
#PBS -l walltime=24:00:00
#PBS -m ea 
#PBS -l ncpus=1
#PBS -l mem=30g
#PBS -r n

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Global variables
GENOMEFOLDER="P_margaritifera"
FASTA="Trinity.100aaorf.minexpr0.5.fa"
GENOME="gmap_0.5_pmargaritifera"

#move to present working dir
cd $PBS_O_WORKDIR

#

gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2> 98_log_files/log.index."$TIMESTAMP"
