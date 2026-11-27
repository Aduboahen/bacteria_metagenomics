process FASTCAT {
    // concat all fastq files for a sample into a single gzipped fastq file
    tag "${sample_id}"
    publishDir "${params.outdir}/${params.run_date}/fastq", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq_dir)

    output:
    tuple val(sample_id), path("${sample_id}_fastq.gz")

    script:
    """
   		fastcat ${fastq_dir} | gzip > "${sample_id}_fastq.gz"
   	"""
}
