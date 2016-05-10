#!/bin/bash
#PBS -A userID
#PBS -N gmap_index
#PBS -o gmap_index_.out
#PBS -e gsnap_index.err
#PBS -l walltime=24:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n


module load apps/gmap/2015-12-31.v9

# Global variables
DATAFOLDER="03_trimmed"
GENOMEFOLDER="/rap/userID/jeremy_leluyer/Database/Okisutch"
FASTA="/rap/userID/jeremy_leluyer/Database/Okisutch/okis_uvic.scf.fasta"
GENOME="gmap_coho"
PWD="__PWD__"
cd $PWD

#prepare the genome
gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME"
