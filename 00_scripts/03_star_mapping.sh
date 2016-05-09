#!/bin/bash
#PBS -A userID
#PBS -N STAR_align__BASE__
#PBS -o STAR_align__BASE__.out
#PBS -e STAR_align__BASE__.err
#PBS -l walltime=24:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

#pre-requis
module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/blat/36
module load mugqic/star/2.4.0k
module laod mugqic/samtools/1.2


#variables
PWD="__PWD__"
base="__BASE__"
DATAINPUT="03_trimmed"
DATAOUPUT="04_mapped"


cd $PWD

        # aligning
echo '  aligning "$base"'

STAR --runThreadN 8 \
  --genomeDir "$DATAINPUT"/genome_star_dir \
    --readFilesIn "$DATAINPUT"/"$base".R1.paired.fastq.gz "$DATAINPUT"/"$base".R2.paired.fastq.gz \
    --readFilesCommand zcat \
    #--sjdbGTFfile /path/to/genome_annot.gff \
    --outFileNamePrefix "$DATAOUTPUT"/star_"$base"

        # trimming and sorting
samtools view -Sb -q 1 "$DATAOUTPUT"/star_"$base".sam > "$DATAOUTPUT"/star_"$base".bam

samtools sort -n "$DATAOUTPUT"/star_"$base".bam "$DATAOUTPUT"/star_"$base".sorted.bam


  # Clean up
    echo '      Removing "$base" temp files'

rm "$DATAOUTPUt"/star_"$(base)".sam
rm "$DATAOUTPUT"/star_"$(base)".bam
