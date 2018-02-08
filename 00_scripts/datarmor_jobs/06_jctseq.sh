#!/bin/bash
#PBS -N R.jctseq
#PBS -o 98_log_files/log-jctseq_r.out
#PBS -l walltime=20:00:00
#PBS -l mem=20g
#PBS -r n
#PBS -l ncpus=10
#PBS -q omp

cd $PBS_O_WORKDIR

Rscript --vanilla 00_scripts/06_run_junctionanalysis.R

