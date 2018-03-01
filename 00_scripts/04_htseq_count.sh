#!/usr/bin/env bash
#PBS -N htseq__BASE__
#PBS -o htseq__BASE__.err
#PBS -l walltime=02:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=50g
#PBS -r n


# Move to present working dir
cd $PBS_O_WORKDIR

# install htseq


#Global variables
DATAINPUT="04_mapped/transcriptome"
DATAOUTPUT="05_count"
DATAOUTPUT_SPLICE=""

GFF_FOLDER="P_margaritifera"
GFF_FILE="Trinity.100aaorf.minexpr0.5.gff3"

#launch script
base=__BASE__

# for gene expression
htseq-count -f="bam" -s="no" -r="pos" -t="CDS" -i="Name" --mode="union" "$DATAINPUT"/"$base".sorted.bam "$GFF_FOLDER"/"$GFF_FILE" >>"$DATAOUTPUT"/htseq-count_"$base".txt

# for splicing variations
#htseq-count -f="bam" -s="no" -r="pos" -t="exon" -i="gene" --mode="union" "$DATAINPUT"/"$base".sorted.bam "$GFF_FOLDER"/"$GFF_FILE" >>"$DATAOUTPUT_SLPICE"/htseq-count_"$base".txt
