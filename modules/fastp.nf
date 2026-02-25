process FASTPLONG_CLEAN_READS {
	label "clean reads"
	publishDir "${params.outdir}/QC/fastp", mode: 'copy'

	input:
	tuple val(sample_id), path (read) // 'Input read file (fastq)'
	val phred_qual // 'Base quality threshold for filtering'
	val read_len // 'Minimum read length for filtering'

	output:
	tuple val(sample_id), path("${sample_id}_fastp.fastq.gz"), emit: read
	path "${sample_id}_fastp.html"
	path "${sample_id}_fastp.json"

	script:
	"""
		fastplong -i ${read} -o ${sample_id}_fastp.fastq.gz \
			--qualified_quality_phred ${phred_qual} \
			--length_required ${read_len} \
			--html ${sample_id}_fastp.html \
			--json ${sample_id}_fastp.json \
			--thread ${params.threads}
		"""
}

