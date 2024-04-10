process synapse_get {

    input:
    tuple val(synapse_input_file_id)

    secret 'SYNAPSE_AUTH_TOKEN'

    output:
    path "*.h5ad"

    script:
    """
    synapse get ${synapse_input_file_id}
    """
}
