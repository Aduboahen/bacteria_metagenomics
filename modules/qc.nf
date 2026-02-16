process clean_reads {
	tag ${params.sampleid}
	publishDir "${params.outdir}/qc/clean_reads", mode: 'copy'

	input:
	path read
	val phred_qual
	val read_len

	output:
	path "${params.sampleid}_fastp.fastq.gz", emit: read
	path "${params.sampleid}_fastp.html"
	path "${params.sampleid}_fastp.json"

	script:
	"""
		fastplong -i ${read} -o ${params.sampleid}_fastp.fastq.gz \
			--qualified_quality_phred ${phred_qual} \
			--length_required ${read_len} \
			--html ${params.sampleid}_fastp.html \
			--json ${params.sampleid}_fastp.json \
			--thread ${params.threads}
		"""
}

process bin_qc {
	tag ${params.sampleid}
	publishDir "${params.outdir}/qc/", mode: 'copy'

	input:
	path bin_dir

	output:
	path "checkm"

	script:
	"""
		checkm2 predict --input ${bin_dir} --output-directory "checkm" \
		--database_path ${params.CHECKMDB} \
		--allmodels --threads ${params.threads} --force

		# dRep dereplicate ${params.outdir}/drep -g ${bin_dir} -p ${params.threads}

		"""
}
