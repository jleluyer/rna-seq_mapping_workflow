#!/usr/bin/env bash
#PBS -N htseq__BASE__
#PBS -o htseq__BASE__.err
#PBS -l walltime=02:00:00
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
GFF_FILE="Trinity.0.5.210717.gff3"

#launch script
base=__BASE__

htseq-count -f 'bam' -s 'no' -r 'pos' -t 'CDS' -i 'Name' "$DATAINPUT"/"$base".sorted.bam "$GFF_FOLDER"/"$GFF_FILE" >>"$DATAOUTPUT"/htseq-count_"$base".txt

