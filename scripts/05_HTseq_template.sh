#!/bin/bash

module load compilers/gcc/4.8  apps/mugqic_pipeline/2.1.1
module load mugqic/tophat/2.0.14
module load mugqic/bowtie2/2.2.5
module load mugqic/samtools/1.2

base=__BASE__

# Note: need to install HTSeq locally

# Note: -s no for non-stranded
# Note: -t (for feature) ideally 'exon' but here changed for 'mRNA'
# Note: -i (id_gene) changed for 'mRNA' 

#HTSeq-count for STAR

HTSeq-0.6.1/build/scripts-2.7/htseq-count -f bam -s no -t mRNA -i mRNA STAR_"$base"NamesSorted.bam genome_annot.gff >> output_mRNA_HTseq-count_STAR_"$base".txt

#HTSeq-count pour TopHat

HTSeq-0.6.1/build/scripts-2.7/htseq-count -f bam -s no -t mRNA -i mRNA tophat_out_"$base"/tophat_"$base"NamesSorted.bam genome_annot.gff >> output_mRNA_tophat_HTseq-count_"$base".txt
