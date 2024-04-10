process run_gsea {
  input:
    val(geneset_file)
    val(psresults)
    tuple val(inputs)
  
  output:
    path "*.csv", emit: gsea_scores
    path "*.csv", emit: gsea_norm
    path "*.csv", emit: gsea_pvals

  script:
  """
  run_gsea.py ${geneset_file} ${psresults} ${inputs.dataset}
  """
}