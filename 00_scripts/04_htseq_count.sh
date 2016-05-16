#!/bin/bash
#PBS -A ihv-653-ab
#PBS -N HTseq-countmRNA
#PBS -o HTseq-countmRNA.out
#PBS -e HTseq-countmRNA.err
#PBS -l walltime=24:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

#pre-requis
module load compilers/gcc/4.8.5  apps/mugqic_pipeline/2.1.1
module load mugqic/htslib/1.2.1

#Global variables
DATAINPUT="04_mapped"
DATAOUTPUT="05_count"

#move to present working dir
cd $PBS_O_WORKDIR

for i in $(ls 04_mapped/*sorted.bam)
do
base="$(basename $i)"

htseq-count -f bam -s no -r pos -i mRNA \
 "$DATAINPUT"/"$base".sorted.bam >> "$DATAOUTPUT"/htseq-count_"$base".txt

done 2>&1 | tee 98_log_files/"$TIMESTAMP"_htseq.log
