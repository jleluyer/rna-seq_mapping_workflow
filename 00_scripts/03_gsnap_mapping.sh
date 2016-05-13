#!/bin/bash
#PBS -A userID
#PBS -N gsnap__BASE__
#PBS -o gsnap__BASE__.out
#PBS -e gsnap__BASE__.err
#PBS -l walltime=04:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

#module prerequis
module load apps/gmap/2015-12-31.v9

# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="03_trimmed"
GENOMEFOLDER="/rap/userID/jeremy_leluyer/Database/Okisutch"
GENOME="gmap_coho"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 8 -A sam \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base".sam \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

    # Create bam file
    echo "Creating bam for $base"

    samtools view -Sb -q 1 -F 4  \
        $DATAOUTPUT/"$base".sam >  $DATAOUTPUT/"$base".bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".bam "$DATAOUTPUT"/"$base".sorted.bam
    
    # Clean up
    echo "Removing "$DATAOUTPUT"/"$base".sam"
    echo "Removing "$DATAOUTPUT"/"$base".bam"

   	#rm $DATAOUTPUT/"$base".sam
    	#rm $DATAOUTPUT/"$base".bam
