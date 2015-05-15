#!/bin/bash

module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/blat/36
module load mugqic/star/2.4.0k

base=__BASE__

STAR --runThreadN 8 \
	--genomeDir genomeDirChr \
	--readFilesIn "$base"R1.paired.fastq.gz "$base"R2.paired.fastq.gz \
	--readFilesCommand zcat \
	--sjdbGTFfile genome_annot.gff \
	--outFileNamePrefix STAR_alignChr_"$base"

