#pipeline modified from: http://cgrlucb.wikispaces.com/edgeRWikiVersion
#helpful thread fro dispersion calculation: http://seqanswers.com/forums/showthread.php?t=5591

source("http://www.bioconductor.org/biocLite.R")
biocLite("edgeR")
library('edgeR')

#import csv
raw.data <- read.csv2("/Users/jeremyleluyer/Desktop/essai_HTseq/edgeR/dataset_STAT_def_recov_edgeR.csv",header=T, sep=";", dec=".", na.strings="NA")

#prepare dataset
counts <- raw.data[ , -c(1,ncol(raw.data)) ]
rownames( counts ) <- raw.data[ , 1 ] # gene names
colnames( counts ) <- paste(c(rep("def_R",3),rep("recov_R",3)),c(1:3,1:3),sep="") # sample names
head( counts )

#quick summaries
dim( counts )
colSums( counts )
colSums( counts ) / 1e06 #millions reads
table( rowSums( counts ) )[ 1:30 ] # Number of genes with low counts

#building edgeR object
group <- c(rep("def", 3) , rep("recov", 3))
cds <- DGEList( counts , group = group )
names( cds )
head(cds$counts)
cds$samples
sum( cds$all.zeros ) # How many genes have 0 counts across all samples

#filtering low count genes
cds <- cds[rowSums(1e+06 * cds$counts/expandAsMatrix(cds$samples$lib.size, dim(cds)) > 1) >= 3, ]
dim( cds )

#calculate normalization factor
cds <- calcNormFactors( cds )
cds$samples

#library size
cds$samples$lib.size*cds$samples$norm.factors

#plot
plotMDS( cds , main = "MDS Plot for Count Data", labels = colnames( cds$counts ) )

#estimating dispersion
cds <- estimateCommonDisp( cds )
names( cds )

#gene-wise dispersion
cds <- estimateTagwiseDisp( cds , prior.df = 12 ) #The amount of squeezing is governed by the paramter prior.df which by default is 10. The higher prior.df, the closer the estimates will be to the common dispersion. The recommended value is the nearest integer to 50/(#samples − #groups). For this data set that’s 50/(6 − 2) = 12.5, so it is equal to the default.

#Mean-variance plot
meanVarPlot <- plotMeanVar( cds ,show.raw.vars=TRUE , show.tagwise.vars=TRUE , show.binned.common.disp.vars=FALSE , show.ave.raw.vars=FALSE , dispersion.method = "qcml" , NBline = TRUE , nbins = 100 , #these are arguments about what is plotted
                            pch = 16 , xlab ="Mean Expression (Log10 Scale)" , ylab = "Variance (Log10 Scale)" , main = "Mean-Variance Plot" ) #these arguments are to make it look prettier

#testing #note that first group is the baseline for comparison ex: def vs recov
de.tgw <- exactTest( cds , dispersion="tagwise" , pair = c( "def" , "recov" ) ) ##single common dispersion across all genes

de.cmn <- exactTest( cds , dispersion="common" , pair = c( "def" , "recov" ) )

de.poi <- exactTest( cds , dispersion = 1e-06 , pair = c( "def" , "recov" ) ) #a poisson model (no dispersion)
Comparison of groups:  def - recov

#look at the objects
names( de.tgw )
de.tgw$comparison # which groups have been compared
head( de.tgw$table )
head( cds$counts )

# Top tags for tagwise analysis
options( digits = 3 ) # print only 3 digits
topTags( de.tgw , n = 20 , sort.by = "p.value" )

# Sort tagwise results by Fold-Change instead of p-value, and get all genes
resultsByFC.tgw <- topTags( de.tgw , n = nrow( de.tgw$table ) , sort.by = "logFC" )$table
head( resultsByFC.tgw )

# Store full topTags results table
resultsTbl.cmn <- topTags( de.cmn , n = nrow( de.cmn$table ) )$table
resultsTbl.tgw <- topTags( de.tgw , n = nrow( de.tgw$table ) )$table
resultsTbl.poi <- topTags( de.poi , n = nrow( de.poi$table ) )$table
head( resultsTbl.tgw )

# Names/IDs of DE genes
de.genes.cmn <- rownames( resultsTbl.cmn )[ resultsTbl.cmn$FDR <= 0.05 ]
de.genes.tgw <- rownames( resultsTbl.tgw )[ resultsTbl.tgw$FDR <= 0.05 ]
de.genes.poi <- rownames( resultsTbl.poi )[ resultsTbl.poi$FDR <= 0.05 ]

#look how many genes in each group
length( de.genes.tgw )
summary( decideTestsDGE( de.tgw , p.value = 0.05 ) )

#plot the results
par( mfrow=c(3 ,1) ) #makes 3 plots on same screen

hist(resultsTbl.poi[de.genes.poi[1:100],"logCPM"] , breaks=10 , xlab="Log Concentration" , col="red" , xlim=c(-18,-6) , ylim=c(0,0.4) , freq=FALSE , main="Poisson: Top 100" )
hist(resultsTbl.cmn[de.genes.cmn[1:100],"logCPM"] , breaks=25 , xlab="Log Concentration" , col="green" , xlim=c(-18,-6) , ylim=c(0,0.4) , freq=FALSE , main="Common: Top 100" )
hist( resultsTbl.tgw[de.genes.tgw[1:100],"logCPM"] , breaks=25 , xlab="Log Concentration" , col="blue" , xlim=c(-18,-6) , ylim=c(0,0.4) , freq=FALSE , main="Tagwise: Top 100" )

par( mfrow=c(1,1) ) #set back to default

#MA ####plot to modify####
par( mfrow=c(2,1) )

plotSmear(cds , de.tags=de.genes.poi , main="Poisson" , pair = c("def","recov") , cex = .35 , xlab="Log CPM" , ylab="Log Fold-Change" ) = c(-2, 2) , col = "dodgerblue" )
abline( h=c(-2,2) , col="dodgerblue" )

plotSmear( cds , de.tags=de.genes.tgw , main="Tagwise" , pair = c("def","recov") , cex = .35 , xlab="Log CPM" , ylab="Log Fold-Change" )
abline( h=c(-2,2) , col="dodgerblue" )

par( mfrow=c(1,1) )

#resume files
colnames( resultsTbl.cmn ) <- c( "logCPM" , "logFC" , "pValue.cmn" , "FDR.cmn" )
colnames( resultsTbl.tgw ) <- c( "logCPM" , "logFC" , "pValue.tgw" , "FDR.tgw" )
write.csv(resultsTbl.tgw, file="tagwise_edgeR_Results.csv", row.names = TRUE)
write.csv(resultsTbl.cmn, file="common_edgeR_Results.csv", row.names = TRUE)
