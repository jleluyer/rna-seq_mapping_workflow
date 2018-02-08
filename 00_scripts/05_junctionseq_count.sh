#!/usr/bin/env bash
#PBS -N jctseq.__BASE__
#PBS -o 98_log_files/log-jctseq.__BASE__.err
#PBS -l walltime=02:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=30g
#PBS -r n

. /appli/bioinfo/samtools/latest/env.sh

# Move to present working dir
cd $PBS_O_WORKDIR


GTF="/home1/datawork/jleluyer/00_ressources/genomes/P_margaritifera/indexed_genome.gtf"
GENOME="/home1/datawork/jleluyer/00_ressources/genomes/P_margaritifera/Pmarg_trimmed.fasta"
base=__BASE__

# sort bam
#samtools view -Sb -f 0x2 04_mapped/"$base".sorted.bam >04_mapped/"$base".proppaired.bam

#samtools sort -n 04_mapped/"$base".proppaired.bam -o 04_mapped/"$base".namesorted.bam

samtools view -Sh 04_mapped/"$base".namesorted.bam | awk -F "\t" '($7=="=")' >04_mapped/context."$base".sam

samtools view -Sh 04_mapped/"$base".namesorted.bam | grep ^@ >04_mapped/header."$base".sam

cat 04_mapped/header."$base".sam 04_mapped/context."$base".sam > 04_mapped/"$base".sam

rm 04_mapped/header."$base".sam
#rm 04_mapped/context."$base".sam

samtools view -Sb 04_mapped/"$base".sam >04_mapped/"$base".name.sorted.bam


#bamtools filter -in 04_mapped/"$base".namesorted.bam -out 04_mapped/"$base".name.sorted.bam \
#		-isProperPair "true" \
#		-insertSize 1000 \
#		-isMateMapped "true" \
#		-isPaired "true" \
#		-isMateReverseStrand "true" \
#		-forceCompression

# launch 
java -jar -Xmx25g /home1/datahome/jleluyer/softwares/QoRTs-STABLE.jar QC \
		--stranded \
		--nameSorted \
		--minMAPQ 30 \
		--maxReadLength 100 \
		--genomeFA "$GENOME" --keepMultiMapped \
		--runFunctions writeKnownSplices,writeNovelSplices,writeSpliceExon \
		04_mapped/"$base".name.sorted.bam \
		$GTF \
		05_count_jctseq/"$base"_jctseq/

# Clean up
#rm 04_mapped/"$base".proppaired.bam
