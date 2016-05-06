#!/bin/bash
#PBS -A userID
#PBS -N STAR_index
#PBS -o STAR_index.out
#PBS -e STAR_index.err
#PBS -l walltime=24:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/blat/36
module load mugqic/star/2.5.0a

PWD="__PWD__"

cd $PWD

mkdir 02-data/genome_star_dir

STAR --runThreadN 1 \
          --runMode genomeGenerate \
	  --genomeDir 02-data/genome_star_dir \
    	  --genomeFastaFiles  \
          --sjdbOverhang 99 \
          --genomeChrBinNbits 10 \
          --limitGenomeGenerateRAM 20000000000
