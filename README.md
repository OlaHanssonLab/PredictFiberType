# PredictFiberType
In this repository we upload codes to use for predicting skeletal muscle fibertype composition using bulk RNAseq data

The main script is PredictFiberType.R which accepts a matrix of skeletal muscles bulk RNAseq expression and estimates fibertype (type 1 vs. type 2) composition for each sample.

Run this script as: Rscript PredictFiberType.R bulk_expr.txt true_type1.txt,

where:
bulk_expr.txt is a normalized bulk RNAseq expression matrix with columns as samples and rows as gene symbols (convert Ensembl IDs to gene symbols)
true_type1.txt is a column of true fractions of type1 fibers (rows are sample IDs that will be matched with the RNAseq sample IDs)
