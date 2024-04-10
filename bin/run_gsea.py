#!/usr/bin/env python3

import pandas as pd
import decoupler as dc
import sys

geneset_file = sys.argv[1] 
pseudobulk_file = sys.argv[2]  # csv pseudobulk file
dataset_name = sys.argv[3]

ps_data = pd.read_csv(pseudobulk_file, index_col = 0)
reactome = pd.read_csv(geneset_file)

# add column with cell type information
ps_data['group'] = ps_data.index.str.rsplit('_', n=1).str.get(-1)

# let's run gsea for the sum of gene expression values each cell type
print("Running GSEA for sum of cell types")

sum_scores, sum_norm, sum_pvals = dc.run_gsea(
    mat = ps_data.groupby('group').sum(), 
    net=reactome,
    source="SetName",
    target="Gene",
)

# let's run gsea for all samples x cell_type
print("Running GSEA for each pseudobulk sample")

scores, norm, pvals = dc.run_gsea(
    mat = ps_data.drop(['group'], axis=1),
    net=reactome,
    source="SetName",
    target="Gene",
)

pd.concat([sum_scores, scores]).to_csv(f"{dataset_name}_gsea_scores.csv")
pd.concat([sum_norm, norm]).to_csv(f"{dataset_name}_gsea_norm.csv")
pd.concat([sum_pvals, pvals]).to_csv(f"{dataset_name}_gsea_pvals.csv")
