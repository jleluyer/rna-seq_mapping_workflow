#!/bin/bash
#PBS -N gsnap__BASE__
#PBS -o gsnap__BASE__.out
#PBS -e gsnap__BASE__.err
#PBS -l walltime=10:00:00
#PBS -m ea 
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n


# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="03_trimmed"

GENOMEFOLDER="/home1/datawork/jleluyer/00_ressources/transcriptomes/P_margaritifera"
GENOME="gmap_pmargaritifera"

platform="Illumina"
#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 8 -A sam --min-coverage=0.90 \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base".sam \
	--read-group-id="$base" \
	 --read-group-platform="$platform" \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

    # Create bam file
    echo "Creating bam for $base"

    samtools view -Sb -q 5 -F 4 -F 256 \
        $DATAOUTPUT/"$base".sam >$DATAOUTPUT/"$base".bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".bam -o "$DATAOUTPUT"/"$base".sorted.bam
    	samtools index "$DATAOUTPUT"/"$base".sorted.bam

    # Clean up
    echo "Removing "$DATAOUTPUT"/"$base".sam"
    echo "Removing "$DATAOUTPUT"/"$base".bam"

   	#rm $DATAOUTPUT/"$base".sam
    	#rm $DATAOUTPUT/"$base".bam
