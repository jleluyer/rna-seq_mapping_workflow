#!/bin/bash
#PBS -A userID
#PBS -N HTseq-countmRNA__BASE__
#PBS -o HTseq-countmRNA__BASE__.out
#PBS -e HTseq-countmRNA__BASE__.err
#PBS -l walltime=24:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n


#pre-requis
module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/bowtie2/2.2.5
module load mugqic/samtools/1.2

#Global variables
base=__BASE__
DATAINPUT="04_mapped"
DATAOUTPUT="05_count"

#move to present working dir
cd $PBS_O_WORKDIR

htseq-count -f bam -s no -t mRNA -i mRNA \
 "$DATAINPUT"/"$base".sorted.bam >> "$DATAOUTPUT"/htseq-count_"$base".txt

