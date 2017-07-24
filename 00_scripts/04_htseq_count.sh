#!/usr/bin/env bash
#PBS -N htseq_index
#PBS -o htseq_index.err
#PBS -l walltime=24:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=30g
#PBS -r n


# Move to present working dir
cd $PBS_O_WORKDIR

# install htseq
. /appli/bioinfo/htseq/0.6.1/env.sh

#Global variables
DATAINPUT="04_mapped"
DATAOUTPUT="05_count"
GFF_FOLDER="/home1/datawork/jleluyer/00_ressources/transcriptomes/P_margaritifera"
GFF_FILE="Trinity.0.5.210717.gff"

#launch script
for i in $(ls 04_mapped/*sorted.bam)
do
base="$(basename $i)"

htseq-count --format='bam' --stranded='yes' --order='name' --type='CDS' --idattr='Name' "$DATAINPUT"/"$base" "$GFF_FOLDER"/"$GFF_FILE" \
 "$DATAINPUT"/"$base" "$GFF_FOLDER"/"$GFF_FILE" >> "$DATAOUTPUT"/htseq-count_"$base".txt

done 2>&1 | tee 98_log_files/"$TIMESTAMP"_htseq.log
