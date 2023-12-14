#!/usr/bin/env nextflow

//to run in the command line: nextflow run nextflow_test.nf

params.h5ad_files = "https://github.com/CRI-iAtlas/nf-htan-scripts/blob/main/data/input_data_v1.csv"
params.geneset_file = "syn52138713"

Channel
  .fromPath(params.h5ad_files)
  .splitCsv( header: true, sep: ',')
  .map{row -> tuple(row.dataset, row.synapse_input_file_id, row.upload_folder, row.counts_layer, row.sample_id, row.cell_type_id)}
  .set{sample_run_ch}

process runPseudobulk {
  tag "$dataset Pseudobulk"

  input:
  tuple val(dataset), val(synapse_input_file_id), val(upload_folder), val(counts_layer), val(sample_id), val(cell_type_id)  //from sample_run_ch
  
  output:
  path 'pseudobulk_results.csv'

  script:
  """
  python nf_run_pseudobulk.py ${synapse_input_file_id} ${sample_id} ${cell_type_id} ${counts_layer}
  """
}

process runPseudobulkGSEA {
  tag "$dataset GSEA"
  input:
    path pseudobulkResults
    val genesetFile
    tuple val(dataset), val(synapse_input_file_id), val(upload_folder), val(counts_layer), val(sample_id), val(cell_type_id) 
  // output:
    // path 'gsea_scores.csv'

  script:
  """
  python nf_run_scrna_pseudobulk_gsea.py ${pseudobulkResults} ${genesetFile} ${dataset} ${upload_folder}

  """
}

workflow {

    pseudobulk = runPseudobulk(sample_run_ch)
    runPseudobulkGSEA(pseudobulk, params.geneset_file, sample_run_ch)

}
