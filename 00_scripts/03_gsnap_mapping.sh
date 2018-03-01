#!/bin/bash
#PBS -N gsnap.__BASE__
#PBS -o gsnap.__BASE__.err
#PBS -l walltime=23:00:00
#PBS -l mem=30g
#####PBS -m ea
#PBS -l ncpus=12
#PBS -q omp
#PBS -r n




# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="03_trimmed"

# For genome
GENOMEFOLDER="P_margaritifera"
GENOME="indexed_genome"
platform="Illumina"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__

    # Align reads
    echo "Aligning $base"
 gsnap --gunzip -t "$NCPUS" -A sam --min-coverage=0.5 \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
       	--max-mismatches=5 --novelsplicing=1 \
	--split-output="$DATAOUTPUT"/"$base" \
	--read-group-id="$base" \
	--read-group-platform="$platform" \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

# concatenate sam
	samtools view -b "$DATAOUTPUT"/"$base".concordant_uniq >"$DATAOUTPUT"/"$base".concordant_uniq.bam
	 samtools view -b "$DATAOUTPUT"/"$base".paired_uniq_inv >"$DATAOUTPUT"/"$base".paired_uniq_inv.bam
	 samtools view -b "$DATAOUTPUT"/"$base".paired_uniq_long >"$DATAOUTPUT"/"$base".paired_uniq_long.bam
    
    	samtools merge "$DATAOUTPUT"/"$base".bam "$DATAOUTPUT"/"$base".concordant_uniq.bam "$DATAOUTPUT"/"$base".paired_uniq_inv.bam "$DATAOUTPUT"/"$base".paired_uniq_long.bam
# name sorting bam
	echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".bam -o "$DATAOUTPUT"/"$base".sorted.bam
    	samtools index "$DATAOUTPUT"/"$base".sorted.bam    
# Clean up
    echo "Removing "$TMP"/"$base".sam"
    echo "Removing "$TMP"/"$base".bam"

   	rm "$DATAOUTPUT"/"$base".sam
    	rm "$DATAOUTPUT"/"$base".bam
