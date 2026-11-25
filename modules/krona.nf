process KRONA_VISUALISE {
    // visualise abundance
    tag "${sample_id}"
    publishDir "${params.outdir}_${params.run_date}/krona", mode: 'link', pattern: "*"

    input:
    tuple val(sample_id), path(bracken_report)

    output:
    path "${sample_id}.krona"
    path "${sample_id}.krona.html"

    script:
    """
   		kreport2krona.py -r ${bracken_report} -o ${sample_id}.krona

   		ktImportText ${sample_id}.krona -o ${sample_id}.krona.html
   		"""
}
