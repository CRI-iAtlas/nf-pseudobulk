process run_pseudobulk {
  input:
  val(h5ad)
  tuple val(inputs)  

  output:
  path "*.csv"

  script:
  """
  run_pseudobulk.py ${h5ad} ${inputs.sample_id} ${inputs.cell_type_id} ${inputs.counts_layer} ${inputs.dataset}
  """
}