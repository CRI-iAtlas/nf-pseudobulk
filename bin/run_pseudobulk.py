#!/usr/bin/env python3

import decoupler as dc
import scanpy as sc
import pandas as pd
import sys

adata_syn = sys.argv[1]
biospecimen_col = sys.argv[2] 
cell_type_col = sys.argv[3] 
counts_layer = sys.argv[4]
dataset_name = sys.argv[5]

adata = sc.read_h5ad(adata_syn)

pdata = dc.get_pseudobulk(
    adata, 
    sample_col = biospecimen_col, 
    groups_col = cell_type_col, 
    layer= counts_layer, 
    mode='sum')

pseudobulkResults = (
    pdata.to_df(layer = "psbulk_props"))

pdata.to_df(
    layer = "psbulk_props").to_csv(
        'pseudobulk_results_%s.csv' 
        % dataset_name)
