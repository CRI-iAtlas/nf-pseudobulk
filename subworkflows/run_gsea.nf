include { run_gsea } from "../modules/run_gsea.nf"

workflow RUN_GSEA {
  take:
  geneset_file
  psresults
  inputs

  main:
  scores = run_gsea( geneset_file, psresults, inputs)

}

