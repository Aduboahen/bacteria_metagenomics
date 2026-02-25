process MINIMAP2_MAP_CATALOGUE {
	label "map to mag catalogue"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bam"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.stats"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.idxstats"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bai"

	input:
	path mags_catalogue
	// 'Input MAGs file (fna)'
	tuple val(sample_id), path(read)

	output:
	path("${sample_id}.bam"), emit: bam
	// 'bams reads to MAGs in BAM format'
	path("${sample_id}.bam.stats")
	// 'Mapping statistics file'
	path("${sample_id}.bam.idxstats")
	// 'Mapping statistics file'
	path("${sample_id}.bam.bai"), emit: bai
	script:
	"""
		minimap2 -ax map-ont -t ${params.threads} ${mags_catalogue} ${read} | samtools sort - | samtools view -F 3844 -b -o ${sample_id}.bam -@ ${params.threads}

		samtools index ${sample_id}.bam > ${sample_id}.bam.bai

		samtools idxstats ${sample_id}.bam > ${sample_id}.bam.idxstats

		samtools stats ${sample_id}.bam > ${sample_id}.bam.stats
		"""
}


process MINIMAP2_REMOVE_HOST_READS {
	label "remove host reads"
	publishDir "${params.outdir}/fastq/host_depleted", mode: 'copy', pattern: "*.fastq.gz"

	input:
	tuple val(sample_id), path(read)
	// 'Input read file (fastq)'
	path hosts

	output:
	tuple val(sample_id), path("${sample_id}_cleaned.fastq.gz")

	script:
	"""
			minimap2 -ax map-ont -t ${params.threads} ${hosts} ${read} | \
			samtools sort | \
			samtools view -f 4 | \
			samtools fastq - > ${sample_id}_cleaned.fastq

			gzip ${sample_id}_cleaned.fastq
		"""
}
