#!/usr/bin/env nextflow

params.geneset_file = "https://raw.githubusercontent.com/CRI-iAtlas/nf-pseudobulk/main/data/PanImmune_GeneSet.csv"

if (params.input) { 
  params.input = file(params.input) } else { 
    exit 1, 'Input samplesheet not specified' }

include { PSEUDOBULK } from './workflows/pseudobulk.nf'

workflow {
  PSEUDOBULK ()
}
