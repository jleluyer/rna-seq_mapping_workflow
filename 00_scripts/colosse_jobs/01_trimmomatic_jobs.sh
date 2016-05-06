#!/bin/bash

# launch scripts for Colosse

for file in $(ls 02-data/*.f*q.gz|perl -pe 's/_R[12].f(ast)?q.gz//')
do

base=$(basename "$file")

	toEval="cat 00-scripts/01-trimmomatic.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00-scripts/colosse_jobs/TRIM_$base.sh
done

 #set working directory

PWD=$(pwd)

sed -i "s#__PWD__#$(pwd)#g" 00-scripts/colosse_jobs/TRIM*sh 

#Submit jobs

for i in $(ls 00-scripts/colosse_jobs/TRIM*sh); do msub $i; done

