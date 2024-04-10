workflow SAMPLESHEET_SPLIT {
    take:
    samplesheet

    main:
    Channel
        .fromPath( samplesheet )
        .splitCsv( header: true, sep:',' )
        // Make meta map from the samplesheet
        .map { row -> tuple(
            dataset: row.dataset,
            synapse_input_file_id: row.synapse_input_file_id,
            upload_folder: row.upload_folder,
            counts_layer: row.counts_layer,
            sample_id: row.sample_id,
            cell_type_id: row.cell_type_id 
            )
        }
        .set { psdata }
        
    emit: 
    psdata
}