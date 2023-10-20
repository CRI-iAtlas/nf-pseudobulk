#!/usr/bin/env python3
import sys
import pandas as pd
import decoupler as dc

import synapseclient
from synapseclient import File

def file_upload(syn, table, dataset_name, export_name, upload_location):
    upload_name = "_".join([dataset_name,export_name])
    table.to_csv(upload_name)
    file_entity = synapseclient.File(upload_name, parent = upload_location)
    syn.store(file_entity)

def main():

    syn = synapseclient.login()
	#arguments
    pseudobulk_file = sys.argv[1]  # syn52118084 csv pseudobulk file
    geneset_file = sys.argv[2] # syn52138713
    dataset_name = sys.argv[3]
    upload_location = sys.argv[4]  # syn52142300
#
    #load data
    print("Downloading data...")
    adata_synapse = syn.get(pseudobulk_file)
    geneset_synapse = syn.get(geneset_file)
    
    print("Loading data...")
    ps_data = pd.read_csv(adata_synapse.path, index_col = 0)
    reactome = pd.read_csv(geneset_synapse.path)

    #adding col with cell type information
    ps_data['group'] = ps_data.index.str.rsplit('_', 1).str.get(-1)

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

    print("Done! Saving and uploading files...")
    file_upload(syn, pd.concat([sum_scores, scores]), dataset_name, "gsea_scores.csv", upload_location)
    file_upload(syn, pd.concat([sum_norm, norm]),  dataset_name, "gsea_norm.csv", upload_location)
    file_upload(syn, pd.concat([sum_pvals, pvals]),  dataset_name, "gsea_pvals.csv", upload_location)
    
       
if __name__ == '__main__':
	main()
