process FASTCAT {
	label "concat fastq"

	input:
	tuple val(sample_id), path(fastq_dir)
	
	output:
	path "${sample_id}_fastq.gz"

	script:
	"""
		fastcat fastq_dir | gzip > fastq.gz
	"""
}