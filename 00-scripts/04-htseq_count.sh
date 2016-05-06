#!/bin/bash
#PBS -A ihv-653-ab_
#PBS -N HTseq-countmRNA__BASE__
#PBS -o HTseq-countmRNA__BASE__.out
#PBS -e HTseq-countmRNA__BASE__.err
#PBS -l walltime=24:00:00
#PBS -M jeremy.le-luyer.1@ulaval.ca
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n


#pre-requis
module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/bowtie2/2.2.5
module load mugqic/samtools/1.2

#variables
PWD="__PWD__"
base=__BASE__

htseq-count -f bam -s no -t mRNA -i mRNA \
 02-data/star_"$base".sorted.bam >> 02-data/htseq-count_"$base".txt

