process map_mags {
	tag ${params.sampleid}
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bam"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.stats"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bai"

	input:
		path mags_catalogue // 'Input MAGs file (fna)'
		path read // 'Input reads file (fastq)'

	output:
		path "${params.sampleid}.bam", emit: bam // 'bams reads to MAGs in BAM format'
		path "${params.sampleid}.bam.stats" // 'Mapping statistics file'
		path "${params.sampleid}.bam.idxstats" // 'Mapping statistics file'
		path "${params.sampleid}.bam.bai", emit: bam_bai // 'Index file for bams BAM'

	script:
		"""
		minimap2 -ax map-ont -t ${params.threads} ${mags_catalogue} ${read} | samtools sort - | samtools view -F 3844 -b -o ${params.sampleid}.bam -@ ${params.threads}

		samtools index ${params.sampleid}.bam > ${params.sampleid}.bam.bai

		samtools idxstats ${params.sampleid}.bam > ${params.sampleid}.bam.idxstats

		samtools stats ${params.sampleid}.bam > ${params.sampleid}.bam.stats
		"""
}