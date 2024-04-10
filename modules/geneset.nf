process geneset {
  input:
    val(geneset_url)
  
  output:
    path "*.csv"

  script:
  """
  curl -o PanImmune_GeneSet.csv ${geneset_url}
  """
}