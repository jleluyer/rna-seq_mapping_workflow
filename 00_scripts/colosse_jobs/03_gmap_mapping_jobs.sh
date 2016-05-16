#!/bin/bash

ID="ihv-653-ab"
email="jeremy.le-luyer.1@ulaval.ca"

# launch scripts for Colosse

for file in $(ls 03_trimmed/*paired*.f*q.gz|perl -pe 's/.R[12].paired.fastq.gz//')
do

base=$(basename "$file")

	toEval="cat 00_scripts/03_gsnap_mapping.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/colosse_jobs/GSNAP_$base.sh
done


#change colosse headers
for i in $(ls 00_scripts/colosse_jobs/GSNAP*sh); do sed -i -e "s/userID/$ID/g" -e "s/userEmail/$email/g" $i;done

#Submit jobs
for i in $(ls 00_scripts/colosse_jobs/GSNAP*sh); do msub $i; done


