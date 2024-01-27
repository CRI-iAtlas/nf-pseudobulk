#!/usr/bin/env python3

import sys
import scanpy as sc
import pandas as pd
import decoupler as dc

import synapseclient
from synapseclient import File


def main():

    syn = synapseclient.Synapse()
    syn.login()

	#arguments
    h5ad_file = sys.argv[1]  #  h5ad file with preprocessed data
    biospecimen_col = sys.argv[2] 
    cell_type_col = sys.argv[3] 
    counts_layer = sys.argv[4]
    
    #load data
    print("Downloading data...")
    adata_synapse = syn.get(h5ad_file)

    print("Loading data...")
    adata = sc.read_h5ad(adata_synapse.path)

	#Run pseudobulk
    print("Running pseudobulk...")
    pdata = dc.get_pseudobulk(
        adata, 
        sample_col = biospecimen_col, 
        groups_col = cell_type_col, 
        layer= counts_layer, 
        mode='sum')
    
    pseudobulkResults = (pdata.to_df(layer = "psbulk_props"))
    pdata.to_df(layer = "psbulk_props").to_csv('pseudobulk_results.csv')

       
if __name__ == '__main__':
	main()
