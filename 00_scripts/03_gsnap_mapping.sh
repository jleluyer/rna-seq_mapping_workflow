#!/bin/bash
#PBS -N gsnap.__BASE__
#PBS -o gsnap.__BASE__.err
#PBS -l walltime=10:00:00
#PBS -l mem=100g
#####PBS -m ea
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n


# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="../transcriptome_assembly/03_trimmed"

GENOMEFOLDER="/home1/datawork/jleluyer/00_ressources/transcriptomes/P_margaritifera"
GENOME="gmap_pmargaritifera"

platform="Illumina"

TMP="/home1/scratch/jleluyer"


#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 8 -A sam --min-coverage=0.90 \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$TMP"/"$base".sam \
	--read-group-id="$base" \
	 --read-group-platform="$platform" \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

    # Create bam file
    echo "Creating bam for $base"

    samtools view -Sb -q 5 -F 4 -F 256 \
        "$TMP"/"$base".sam >"$TMP"/"$base".bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$TMP"/"$base".bam -o "$DATAOUTPUT"/"$base".sorted.bam
    	samtools index "$TMP"/"$base".sorted.bam

    # Clean up
    echo "Removing "$TMP"/"$base".sam"
    echo "Removing "$TMP"/"$base".bam"

   	rm "$TMP"/"$base".sam
    	rm "$TMP"/"$base".bam
