process KRAKEN2_ASSIGN_TAXA {
	label "assign taxa"
	publishDir "${params.outdir}/kraken/abundance", mode: 'copy', pattern: "*kraken2"
	publishDir "${params.outdir}/kraken/report", mode: 'copy', pattern: "*.k2report"
	publishDir "${params.outdir}/kraken/classified", mode: 'copy', pattern: "*_classified.fastq"
	publishDir "${params.outdir}/kraken/unclassified", mode: 'copy', pattern: "*_unclassified.fastq"

	input:
	tuple val(sample_id), path(read)
	// 'Input read file (fastq)'
	path KRAKEN2DB

	output:
	path "${sample_id}.kraken2", emit: taxa_file
	// 'Assigned taxa results'
	tuple val(sample_id), path("${sample_id}.k2report"), emit: kraken_report
	// 'Kraken2 report file'
	path "${sample_id}_classified.fastq"
	// 'Unclassified reads'
	path "${sample_id}_unclassified.fastq"

	script:
	"""
			kraken2 --db ${KRAKEN2DB} --report ${sample_id}.k2report \
			--classified-out ${sample_id}_classified.fastq \
			--unclassified-out ${sample_id}_unclassified.fastq \
			--output ${sample_id}.kraken2 --report-minimizer-data --use-names \
			--threads ${params.threads} --memory-mapping ${read}
		"""
}
