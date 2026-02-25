process BRACKEN_ABUNDANCE {
	label "bracken"
	publishDir "${params.outdir}/bracken/abundance", mode: 'copy', pattern: "*.bracken"
	publishDir "${params.outdir}/bracken/report", mode: 'copy', pattern: "*.breport"

	input:
	tuple val(sample_id), path(kraken_report)
	// 'Taxonomic assignment reportt from Kraken2'
	path KRAKEN2DB

	output:
	tuple val(sample_id), path("${sample_id}.breport"), emit: bracken_report
	// 'Bracken report file'
	tuple val(sample_id), path("${sample_id}.bracken"), emit: bracken_file

	script:
	"""
		bracken -d ${params.KRAKEN2DB} -i ${kraken_report} -o ${sample_id}.bracken -w ${sample_id}.breport -r 100 -l S -t ${params.threads}
		"""
}


