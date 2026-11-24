process FASTCAT {
	// concat all fastq files for a sample into a single gzipped fastq file
	label "concat_fastq"

	input:
	tuple val(sample_id), path(fastq_dir)
	
	output:
	tuple val(sample_id), path("${sample_id}_fastq.gz")

	script:
	"""
		fastcat $fastq_dir | gzip > "${sample_id}_fastq.gz"
	"""
}