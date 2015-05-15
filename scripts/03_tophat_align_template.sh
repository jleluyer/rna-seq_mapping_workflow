#!/bin/bash


base=__BASE__

module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/tophat/2.0.14
module load mugqic/bowtie2/2.2.5
module load mugqic/samtools/1.2

tophat -o tophat_out_"$base" -G genome_annot.gff -p 8 genome_b2.ref "$base"R1.paired.fastq.gz "$base"R2.paired.fastq.gz
