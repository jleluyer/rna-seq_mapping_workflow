#!/bin/bash

module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/tophat/2.0.14
module load mugqic/bowtie2/2.2.5
module load mugqic/samtools/1.2


# sort with 'names' needed for HTseq-count step

base=__BASE__

samtools sort -n tophat_out_"$base"/accepted_hits.bam tophat_out_"$base"/tophat_"$base"NamesSorted

samtools view -bS STAR_alignChr_"$base"Aligned.out.sam | samtools sort -n - STAR_"$base"NamesSorted 


#alternative
#samtools view -bS sample1.sam > sample1
#samtools sort sample1.bam sample1_sorted.bam
