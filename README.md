# PredictFiberType
In this repository we upload the algorithm for predicting skeletal muscle fibertype composition from bulk RNAseq data.

The main script is PredictFiberType.R which accepts a **normalized** and **batch-corrected** matrix of skeletal muscles bulk RNAseq expression values and estimates fibertype (type 1 vs. type 2) composition for each sample. The script uses the **signature matrix** that was computed from snRNAseq on skeletal muscle fibers and contains cluster gene markers for type 1 and type 2 nuclei.

Run this script as: **Rscript PredictFiberType.R bulk_expr.txt true_type1.txt**,

where:
bulk_expr.txt is a normalized bulk RNAseq expression matrix with columns as samples and rows as gene symbols (convert Ensembl IDs to gene symbols)
true_type1.txt is a column of true fractions of type1 fibers (rows are sample IDs that will be matched with the RNAseq sample IDs)
