#!/bin/bash

module load compilers/gcc/4.8
module load apps/mugqic_pipeline/1.2
module load mugqic/java/jdk1.7.0_60
module load mugqic/trimmomatic/0.32

base=__BASE__

java -XX:ParallelGCThreads=1 -Xmx22G -cp $TRIMMOMATIC_JAR org.usadellab.trimmomatic.TrimmomaticPE \
        -phred33 \
        "$base"R1.fastq.gz \
        "$base"R2.fastq.gz \
        "$base"R1.paired.fastq.gz \
        "$base"R1.single.fastq.gz \
        "$base"R2.paired.fastq.gz \
        "$base"R2.single.fastq.gz \
        ILLUMINACLIP:/path/to/univec_trimmomatic.fasta:2:20:7 \
        LEADING:20 \
        TRAILING:20 \
        SLIDINGWINDOW:30:30 \
        MINLEN:60
