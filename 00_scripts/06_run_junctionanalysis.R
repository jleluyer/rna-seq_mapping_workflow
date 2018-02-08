#!/usr/bin/Rscript


setwd("/home1/datawork/jleluyer/01_projects/poche_qualite/rna-seq_mapping_workflow/")


# load lib
library(JunctionSeq)

decoder<-read.table("01_info_files/decoder.file.txt",header=T)

countFiles=c("05_count_jctseq/HI.4287.003.Index_10.M5_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_11.B1_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_1.M1_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_20.B2_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_21.B5_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_22.B3_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_25.B4_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_3.M2_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_8.M4_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz",
"05_count_jctseq/HI.4287.003.Index_9.M3_jctseq/QC.spliceJunctionAndExonCounts.withNovel.forJunctionSeq.txt.gz")

# Run basic analysis
jscs <- runJunctionSeqAnalyses(sample.files = countFiles,
	sample.names = decoder$sample.ID,
	condition=factor(decoder$group.ID),
	flat.gff.file = "05_count_jctseq/withNovel.forJunctionSeq.gff.gz",
	nCores = 10,
	analysis.type = "junctionsAndExons");

save(jscs,file="07_results_jctseq/jscs.rda")


# Plots
buildAllPlots(jscs=jscs,
outfile.prefix = "07_results_jctseq/plots_jctseq/",
use.plotting.device = "png",
FDR.threshold = 0.01);
