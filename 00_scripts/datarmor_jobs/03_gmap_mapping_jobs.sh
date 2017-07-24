#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/GSNAP_*sh


# launch scripts for Colosse
for file in $(ls /scratch/home1/jleluyer/juv_couleur/03_trimmed/*paired*.f*q.gz|perl -pe 's/_R[12].paired.fastq.gz//'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/03_gsnap_mapping.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/GSNAP_$base.sh
done


#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/GSNAP*sh); do qsub $i; done


