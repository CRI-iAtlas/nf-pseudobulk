include { synapse_get } from "../modules/synapse_get.nf"

workflow SYNAPSE_GET {
    take:
    psdata
    
    main:
    adata_name = synapse_get(psdata)
    
    emit:
    adata_name
}