process KRONA_VISUALISE {
	label "krona"
	publishDir "${params.outdir}/krona", mode: 'copy', pattern: "*"

	input:
	tuple val(sample_id), path(bracken_report)

	output:
	path "${sample_id}.krona"
	// bracken report converted to krona format
	path "${sample_id}.krona.html"

	script:
	"""
		kreport2krona.py -r ${bracken_report} -o ${sample_id}.krona

		ktImportText ${sample_id}.krona -o ${sample_id}.krona.html
		"""
}