process clean_reads {
	tag 'qc'
	conda '/home/james/miniconda3/envs/bacteria_meta'
	publishDir "${params.outdir}/qc/clean_reads", mode: 'copy'

	input:
		path read

	output:
		path "${params.sampleid}_fastp.fastq.gz", emit: read
		path("${params.sampleid}_fastp.html")
    path("${params.sampleid}_fastp.json")

	
	script:
		"""
		fastplong -i ${read} -o ${params.sampleid}_fastp.fastq.gz \
			--qualified_quality_phred ${params.quality} \
			--length_required ${params.length} \
			--html ${params.sampleid}_fastp.html \
			--json ${params.sampleid}_fastp.json \
			--thread ${params.threads}
		"""
}