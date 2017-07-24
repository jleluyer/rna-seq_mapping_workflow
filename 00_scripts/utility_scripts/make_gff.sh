#!/bin/bash
#PBS -A userID
#PBS -N makegff
#PBS -o makegff.out
#PBS -e makegff.err
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
chado_test/chado/bin/gmod_fasta2gff3.pl --fasta_dir Trinity.0.5.210717.fasta --gfffilename Trinity.0.5.210717.gff --type CDS --nosequence

