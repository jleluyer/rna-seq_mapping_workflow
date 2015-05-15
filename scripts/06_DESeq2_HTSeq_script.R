#pipeline adapted from: http://dwheelerau.com/2014/02/17/how-to-use-deseq2-to-analyse-rnaseq-data/

source("http://bioconductor.org/biocLite.R")
biocLite("DESeq2")
library('DESeq2')
#source("http://bioconductor.org/biocLite.R")
#biocLite("vsn")


directory<-"/Users/jeremyleluyer/Desktop/essai_HTseq/STAR"
sampleFiles <- grep("s27",list.files(directory),value=TRUE)
sampleFiles
sampleCondition<-c("def","def","def","recov","recov","recov")
sampleTable<-data.frame(sampleName=sampleFiles, fileName=sampleFiles, condition=sampleCondition)
ddsHTSeq<-DESeqDataSetFromHTSeqCount(sampleTable=sampleTable, directory=directory, design=~condition)
ddsHTSeq
colData(ddsHTSeq)$condition<-factor(colData(ddsHTSeq)$condition, levels=c("def","recov"))
#note important to put levels in the right order to logFC calculation

#value calculation
dds<-DESeq(ddsHTSeq)
res<-results(dds,alpha = 0.05)
res<-res[order(res$padj),]
summary(res, alpha =0.05)
head(res)

#MA plot
plotMA(dds,ylim=c(-2,2),main="DESeq2")
dev.copy(png,"deseq2_MAplot.png")
dev.off()

#to save the table 
mcols(res,use.names=TRUE)
write.csv(as.data.frame(res),file="sim_condition_def_results_deseq2.csv")

#transform the raw discretely distributed counts so that we can do clustering
rld <- rlogTransformation(dds, blind=TRUE)
vsd <- varianceStabilizingTransformation(dds, blind=TRUE)

#plot
par(mai=ifelse(1:4 <= 2, par("mai"), 0))
px     <- counts(dds)[,1] / sizeFactors(dds)[1]
ord    <- order(px)
ord    <- ord[px[ord] < 150]
ord    <- ord[seq(1, length(ord), length=50)]
last   <- ord[length(ord)]
vstcol <- c("blue", "black")
matplot(px[ord], cbind(assay(vsd)[, 1], log2(px))[ord, ], type="l", lty=1, col=vstcol, xlab="n", ylab="f(n)")
legend("bottomright", legend = c(expression("variance stabilizing transformation"), expression(log[2](n/s[1]))), fill=vstcol)
dev.copy(png,"DESeq2_VST_and_log2.png")
#The x axis is the square root of variance over the mean for all samples, so this will naturally included variance due to the treatment. The goal here is to flattern the curve so that there is consistent variance across the read counts, and that is what we got.
#install.packages("vsn")
library("vsn")
par(mfrow=c(1,3))
notAllZero <- (rowSums(counts(dds))>0)
meanSdPlot(log2(counts(dds,normalized=TRUE)[notAllZero,] + 1), ylim = c(0,2.5))
meanSdPlot(assay(rld[notAllZero,]), ylim = c(0,2.5))
meanSdPlot(assay(vsd[notAllZero,]), ylim = c(0,2.5))

#heatmap
library("RColorBrewer")
#install.packages("gplots")
library("gplots")
select <- order(rowMeans(counts(dds,normalized=TRUE)),decreasing=TRUE)[1:30]
hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(100)
heatmap.2(counts(dds,normalized=TRUE)[select,], col = hmcol,
          Rowv = FALSE, Colv = FALSE, scale="none",
          dendrogram="none", trace="none", margin=c(10,6))
dev.copy(png,"DESeq2_heatmap1")
dev.off()
heatmap.2(assay(rld)[select,], col = hmcol,
          Rowv = FALSE, Colv = FALSE, scale="none",
          dendrogram="none", trace="none", margin=c(10, 6))
dev.copy(png,"DESeq2_heatmap2")
dev.off()
heatmap.2(assay(vsd)[select,], col = hmcol,
          Rowv = FALSE, Colv = FALSE, scale="none",
          dendrogram="none", trace="none", margin=c(10, 6))
dev.copy(png,"DESeq2_heatmap3")
dev.off()

#dendogram
distsRL <- dist(t(assay(rld)))
mat <- as.matrix(distsRL)
rownames(mat) <- colnames(mat) <- with(colData(dds),
                                       paste(condition,sampleFiles , sep=" : "))

#updated in latest vignette (See comment by Michael Love)
#this line was incorrect
#heatmap.2(mat, trace="none", col = rev(hmcol), margin=c(16, 16))
#From the Apr 2015 vignette
hc <- hclust(distsRL)
heatmap.2(mat, Rowv=as.dendrogram(hc),
          symm=TRUE, trace="none",
          col = rev(hmcol), margin=c(13, 13))
dev.copy(png,"deseq2_heatmaps_samplebysample.png")
dev.off()

#PCA
print(plotPCA(rld, intgroup=c("condition")))
dev.copy(png,"deseq2_pca.png")
dev.off()
