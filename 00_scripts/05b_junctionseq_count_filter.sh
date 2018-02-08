#!/usr/bin/env bash
#PBS -N filt.jctseq
#PBS -o 98_log_folder/filt.jctseq.err
#PBS -l walltime=02:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=25g
#PBS -r n

# Move to present working dir
cd $PBS_O_WORKDIR


java -jar -Xmx20g /home1/datahome/jleluyer/softwares/QoRTs-STABLE.jar \
		mergeNovelSplices \
		--minCount 6 \
		--stranded \
		05_count_jctseq/ \
		01_info_files/decoder.file.txt \
		/home1/datawork/jleluyer/01_projects/transcriptome_assembly/gawn/04_annotation/indexed_genome.gtf \
		05_count_jctseq/
