# nf-pseudobulk

nf-pseudobulk is a Nextflow pipeline used to perform Gene Set Enrichment Analysis (GSEA) on pseudobulk data.

- Runs pseudobulk aggregation on scRNA-seq h5ad files by summing expresesion values per patient and per cell type
- Runs GSEA for the sum of cell types and for each resulting pseudobulk sample

### h5ad Preprocessing

### Usage

Before executing the workflow, create a Nextflow secret called `SYNAPSE_AUTH_TOKEN` using a Synapse Personal Access Token.

To run the pipeline with docker use:

```
nextflow run CRI-iAtlas/nf-pseudobulk --input <path/to/input.csv> -profile docker
```

### Input Samplesheet
The input to this pipeline is a CSV samplesheet specified with the `--input` parameter

An example input sheet can be found at [data/test_samplesheet.csv](https://github.com/CRI-iAtlas/nf-pseudobulk/blob/main/data/test_samplesheet.csv)

#### Samplesheet requirements:

- `dataset`: Name of dataset
- `h5ad`: Synapse ID of input h5ad file to process
- `upload_folder`: Synapse ID of directory to store outputs
- `counts_layer`: Name of layer in h5ad with raw counts (default: `counts`)
- `sample_id`: Name in obs component of h5ad with Sample IDs
- `cell_type_id`: Name in obs component of h5ad with Cell Type ID

### Outputs

Output CSV files will be stored in Synapse in the directory specified by the `upload_folder` parameter

Output files:
- `gsea_pvals.csv` : p-value for the enrichment test
- `gsea_scores.csv` : enrichment scores
- `gsea_norm.csv` : normalized enrichment scores

