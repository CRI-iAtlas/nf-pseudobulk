#!/usr/bin/env python3
import sys
import scanpy as sc
import pandas as pd
import decoupler as dc

import synapseclient
from synapseclient import File

#vals:
#synapse id for input h5ad file
#name in obs with sample id
#name in obs with cell type id
#name of layer with raw counts - default counts
#mode - default sum

#Example: python run_pseudobulk.py syn52118064 HTAN_Biospecimen_ID cell_type_broad counts mskCimmunecells_pseudobulk_iatlas.csv syn52077539

def syn_login():
    syn = synapseclient.Synapse()
    syn.login()
    return syn

def main():

    syn = synapseclient.login()
	#arguments
    h5ad_file = sys.argv[1]  # "syn52087127" h5ad file with preprocessed data
    biospecimen_col = sys.argv[2] #HTAN_Biospecimen_ID
    cell_type_col = sys.argv[3] #cell_type_broad
    counts_layer = sys.argv[4]
    
    #load data
    print("Downloading data...")
    adata_synapse = syn.get(h5ad_file)
    #print("Loading data...")
    adata = sc.read_h5ad(adata_synapse.path)

	#Run pseudobulk
    print("Running pseudobulk...")
    pdata = dc.get_pseudobulk(adata, sample_col = biospecimen_col, groups_col = cell_type_col, layer= counts_layer, mode='sum')
    
    pseudobulkResults = (pdata.to_df(layer = "psbulk_props"))
    pdata.to_df(layer = "psbulk_props").to_csv('pseudobulk_results.csv')

       
if __name__ == '__main__':
	main()
