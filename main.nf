#!/usr/bin/env nextflow

params.geneset_file = "syn53437619"

if (params.input) { 
  params.input = file(params.input) } else { 
    exit 1, 'Input samplesheet not specified' }


process runPseudobulk {
  // Process to sum counts across cells by sample

  tag "$dataset Pseudobulk"
  secret 'SYNAPSE_AUTH_TOKEN'

  input: //from sample_run_ch
  tuple val(dataset), 
    val(synapse_input_file_id), 
    val(upload_folder), 
    val(counts_layer), 
    val(sample_id), 
    val(cell_type_id)  
  
  output:
  path 'pseudobulk_results.csv'

  script:
  """
  nf_run_pseudobulk.py ${synapse_input_file_id} ${sample_id} ${cell_type_id} ${counts_layer}
  """
}


process runPseudobulkGSEA {

  tag "$dataset GSEA"
  secret 'SYNAPSE_AUTH_TOKEN'

  input:
    path pseudobulkResults
    val genesetFile
    tuple val(dataset), 
      val(synapse_input_file_id), 
      val(upload_folder), 
      val(counts_layer), 
      val(sample_id), 
      val(cell_type_id) 

  script:
  """
  nf_run_scrna_pseudobulk_gsea.py ${pseudobulkResults} ${genesetFile} ${dataset} ${upload_folder}
  """
}


workflow {

    // Parse input samplesheet
    Channel
    .fromPath( params.input )
    .splitCsv( header: true, sep: ',' )
    .map{ row -> tuple(
      row.dataset, 
      row.synapse_input_file_id, 
      row.upload_folder, 
      row.counts_layer, 
      row.sample_id, 
      row.cell_type_id )
    }
    .set{sample_run_ch}

    // Run pseudobulk analysis on individual h5ad files
    pseudobulk = runPseudobulk( sample_run_ch )

    // Run GSEA on pseudobulk output
    runPseudobulkGSEA( 
      pseudobulk, 
      params.geneset_file, 
      sample_run_ch 
    )

}
