include { run_pseudobulk } from "../modules/run_pseudobulk.nf"

workflow RUN_PSEUDOBULK {
  take:
  adata_name
  inputs

  main:
  psresults = run_pseudobulk(adata_name, inputs)

  emit:
  psresults
}