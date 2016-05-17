#!/bin/bash
#PBS -A userID
#PBS -N transdecoder_orf
#PBS -o transdecoder_orf.out
#PBS -e transdecoder_orf.err
#PBS -l walltime=20:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Move to job submission directory
cd $PBS_O_WORKDIR

#Global variables
INPUT="/path/to/transcriptome/ref.fasta"

./00_scripts/transdecoder_utils/TransDecoder.LongOrfs -t $INPUT 2>&1 | tee 98_log_files/"$TIMESTAMP"_transdecoder_getorf.log 
