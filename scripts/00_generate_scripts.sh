#!/bin/bash

#create base list
# e.g. for Samples1_R1.paired.fastq.gz, Samples1_R2.paired.fastq.gz, Samples2_R1.paired.fastq.gz,....

ls *.paired*|sed 's/.R[12].paired.gz//g'|sort -u > base_list.txt

#create script for each sample

for base in $(cat base_list.txt); do toEval="cat trinity_template.sh | sed 's/__BASE__/$base/g'"; eval $toEval > scriptsNames_$base.sh;done
