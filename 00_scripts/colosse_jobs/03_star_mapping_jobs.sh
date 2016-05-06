#!/bin/bash

# launch scripts for Colosse

for file in $(ls 02-data/*paired*.f*q.gz|perl -pe 's/.R[12].paired.fastq.gz//')
do

base=$(basename "$file")

	toEval="cat 00-scripts/03-star_mapping.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00-scripts/colosse_jobs/MAP_$base.sh
done

 #set working directory

PWD=$(pwd)

sed -i "s#__PWD__#$(pwd)#g" 00-scripts/colosse_jobs/MAP*sh 

#Submit jobs

for i in $(ls 00-scripts/colosse_jobs/MAP*sh); do msub $i; done

