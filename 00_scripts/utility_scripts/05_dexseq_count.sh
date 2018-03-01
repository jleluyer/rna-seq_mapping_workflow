#!/usr/bin/env bash
#PBS -N dxseq__BASE__
#PBS -o dxseq__BASE__.err
#PBS -l walltime=02:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=50g
#PBS -r n


# Move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__

source activate test && python /dexseq_count.py -f bam /indexed_genome.gff 04_mapped/"$base".sorted.genome.bam 05_count_dexseq/"$base".dexseq.txt
