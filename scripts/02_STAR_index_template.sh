#!/bin/bash


module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/blat/36
module load mugqic/star/2.4.0k


# Note: genomeDirChr needs to be empty prior to launch STAR index

mkdir /path/to/genomeDirChr

STAR --runThreadN 1 \
	--runMode genomeGenerate \
	--genomeDir /path/to/genomeDirChr \
	--genomeFastaFiles /path/to/genome.fa \
	--sjdbOverhang 99 \
	--genomeChrBinNbits 10 \
	--limitGenomeGenerateRAM 20000000000

