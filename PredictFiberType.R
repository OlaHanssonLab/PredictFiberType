#Author: Nikolay Oskolkov, NBIS SciLifeLab, nikolay.oskolkov@scilifelab.se
#Run this script as: Rscript PredictFiberType.R bulk_expr.txt true_type1.txt, 
#bulk_expr.txt is a normalized bulk RNAseq expression matrix with columns as samples and rows as gene symbols (convert Ensembl IDs to gene symbols)
#true_type1.txt is a column of true fractions of type1 fibers (rows are sample IDs that will be matched with the RNAseq sample IDs)

args = commandArgs(trailingOnly=TRUE)

#Read matrix of fibertype signatures (that was build from type1 and type2 cluster gene markers based on snRNAseq data from skeletal muscles)
print("READING MATRIX OF SIGNATURES")
signatures<-read.delim("signatures_matrix.txt",header=TRUE,check.names=FALSE,row.names=1,sep="\t")
signatures

#Read normalized and batch-corrected expression matrix from a bulk RNAseq experiment from skeletal muscles
#Here columns are samples and rows are gene names (please convert Ensembl IDs into gene names with e.g. biomart prior to running it)
print("READING BULK EXPRESSION MATRIX")
bulk_expr<-read.delim(args[1],header=TRUE,row.names=1,check.names=FALSE,sep="\t")
bulk_expr[1:5,1:5]
dim(bulk_expr)

#Performing deconvolution analysis (to run this, DeconRNASeq R package must be installed) and writing the results of prediction
print("PERFORMING DECONVOLUTION ANALYSIS")
library("DeconRNASeq")
result<-DeconRNASeq(bulk_expr, signatures, use.scale = TRUE)
final_result<-result$out.all
rownames(final_result)<-colnames(bulk_expr)
final_result
write.table(final_result,file="deconv_prediction.txt",col.names=TRUE,row.names=TRUE,quote=FALSE,sep="\t")


if(length(args)==2) 
{
#Comparing predicted fraction of slow twitch (type1) with true values measured via e.g. fibertyping
print("COMPARING TRUE VS. PREDICTED RESULTS")
true_type1<-read.delim(args[2],header=TRUE,row.names=1,sep="\t")
head(true_type1)
merged<-merge(true_type1,final_result,by="row.names",all=TRUE)
merged

#Plot the results of comparison
print("PLOTTING TRUE VS. PREDICTED RESULTS")
pdf("predict_vs_true.pdf")
plot(as.numeric(merged$slow_twitch)~as.numeric(merged$TRUE_SLOW_TWITCH_TYPE_I),
     xlab="TRUE TYPE1 FRACTION",ylab="PREDICTED TYPE1 FRACTION",main="COMPARISON PREDICTED VS. TRUE TYPE 1 FRACTION")
summary(lm(as.numeric(merged$slow_twitch)~as.numeric(merged$TRUE_SLOW_TWITCH_TYPE_I)))
abline(lm(as.numeric(merged$slow_twitch)~as.numeric(merged$TRUE_SLOW_TWITCH_TYPE_I)))
cor_res<-cor.test(as.numeric(merged$slow_twitch),as.numeric(merged$TRUE_SLOW_TWITCH_TYPE_I),method="spearman")
cor_res
mtext(paste0("n = ",dim(na.omit(merged))[1],", Spearman correlation: rho = ",round(as.numeric(cor_res$estimate),2),", p-value = ",cor_res$p.value,""))
dev.off()
}
