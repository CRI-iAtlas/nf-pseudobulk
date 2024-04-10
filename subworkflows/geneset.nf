include { geneset } from "../modules/geneset.nf"

workflow GENESET {
  take:
  geneset_url

  main:
  geneset_file = geneset( geneset_url)

  emit:
  geneset_file
}
