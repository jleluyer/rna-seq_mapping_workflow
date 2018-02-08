#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/GSNAPTR_*sh


# launch scripts for Colosse
for file in $(ls 03_trimmed/*paired*.f*q.gz|perl -pe 's/_R[12].paired.fastq.gz//'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/03_gsnap_mapping_transcriptome.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/GSNAPTR_$base.sh
done


#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/GSNAPTR*sh); do qsub $i; done


