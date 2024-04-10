include { SAMPLESHEET_SPLIT } from '../subworkflows/samplesheet_split.nf'
include { GENESET } from '../subworkflows/geneset.nf'
include { SYNAPSE_GET } from '../subworkflows/synapse_get.nf'
include { RUN_PSEUDOBULK } from '../subworkflows/run_pseudobulk.nf'
include { RUN_GSEA } from '../subworkflows/run_gsea.nf'

workflow PSEUDOBULK {
    SAMPLESHEET_SPLIT ( params.input )
    GENESET ( params.geneset_file )
    SYNAPSE_GET( SAMPLESHEET_SPLIT.out.map {
        it.synapse_input_file_id
    } )
    RUN_PSEUDOBULK( SYNAPSE_GET.out, SAMPLESHEET_SPLIT.out )
    RUN_GSEA ( 
        GENESET.out, 
        RUN_PSEUDOBULK.out, 
        SAMPLESHEET_SPLIT.out )
}
