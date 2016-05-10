#!/bin/bash
#PBS -A ihv-653-ab
#PBS -N gsnap__LIST__
#PBS -o gsnap__LIST__.out
#PBS -e gsnap__LIST__.err
#PBS -l walltime=24:00:00
#PBS -M jeremy.le-luyer.1@ulaval.ca
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n


module load apps/gmap/2015-12-31.v9


# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="03_trimmed"
GENOMEFOLDER="/rap/ihv-653-ab/jeremy_leluyer/Database/Okisutch"
GENOME="gmap_coho"
PWD="__PWD__"
cd $PWD

base=__BASE__


    # Align reads
    echo "Aligning $file"

    gsnap --gunzip -t 8 -A sam \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base".sam \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

    # Create bam file
    echo "Creating bam for $file"

    samtools view -Sb -q 1 -F 4 -F 1797 \
        $DATAOUTPUT/"$base".sam >  $DATAOUTPUT/"$base".bam

    # Clean up
    echo "Removing $file"

    rm $DATAOUTPUT/"$base".sam


done
