#!/bin/bash
#PBS -A ihv-653-ab
#PBS -N STAR_align__BASE__
#PBS -o STAR_align__BASE__.out
#PBS -e STAR_align__BASE__.err
#PBS -l walltime=24:00:00
#PBS -M jeremy.le-luyer.1@ulaval.ca
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

#pre-requis
module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/blat/36
module load mugqic/star/2.5.0a
module load mugqic/samtools/1.2


#variables
PWD="__PWD__"
base="__BASE__"
DATAGENOME=02_data
DATAINPUT=03_trimmed
DATAOUPUT=04_mapped


cd $PWD

        # aligning
echo "  aligning "$base""


	#variables
cpu="--runThreadN 4"											#threads
gendir="--genomeDir 02_data/genome_star.dir"							#genome directory
input="--readFilesIn 03_trimmed/"$base"_R1.paired.fastq.gz 03_trimmed/"$base"_R2.paired.fastq.gz"	#input files
com="--readFilesCommand zcat"										#option for compressed files
#gff="#--sjdbGTFfile /path/to/genome_annot.gff"								#add .gff file
#minintron="--alignIntronMin 20"										#minimum intron length
#maxintron="--alignIntronMax 1000000"                                                                    #maximum intron length
#maxgap="--alignMatesGapMax 1000000"									#maximum genomic distance between mates
#mism="--outFilterMismatchNmax 999"									#max number of mismatches per pair, large number switches off this filter
prefix="--outFileNamePrefix 04_mapped/"									#add prefix
#--genomeChrBinNbits 14 \
ram="--limitGenomeGenerateRAM 200000000"
buffer="--limitIObufferSize 8000000"
sparse="--genomeSAsparseD 2"
sjcollapsed="--limitOutSJcollapsed  100000"

STAR $cpu $gendir $input $com $gff $minintron $ram $sparse $sjcollapsed $buffer $maxintron $mism $maxgap $prefix


	# trimming and sorting
samtools view -Sb -q 1 "$DATAOUTPUT"/star_"$base".sam > "$DATAOUTPUT"/star_"$base".bam

samtools sort -n "$DATAOUTPUT"/star_"$base".bam "$DATAOUTPUT"/star_"$base".sorted.bam


	# Clean up
    echo "    Removing "$base" temp files"

rm "$DATAOUTPUt"/star_"$base".sam
rm "$DATAOUTPUT"/star_"$base".bam
