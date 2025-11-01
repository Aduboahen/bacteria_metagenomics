process map_mags {
	tag 'map_mag'
	conda '/home/james/miniconda3/envs/bacteria_meta'
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bam"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.stats"
	publishDir "${params.outdir}/bams", mode: 'copy', pattern: "*.bai"

	input:
		path mag_catalogue // 'Input MAGs file (fna)'
		path read // 'Input reads file (fastq)'

	output:
		path "${params.sampleid}.bam", emit: bam // 'bams reads to MAGs in BAM format'
		// path "${params.sampleid}_filtered.bam", emit: filtered_bam // 'bams reads to MAGs in filtered BAM format'
		path "${params.sampleid}.bam.stats", emit: mapping_stats // 'Mapping statistics file'
		path "${params.sampleid}.bam.bai", emit: bam_bai // 'Index file for bams BAM'

	script:
		"""
		minimap2 -ax lr:hq ${mag_catalogue} ${read} | samtools sort - | samtools view -F 3844 -b -o ${params.sampleid}.bam -@ ${params.threads}

		samtools index ${params.sampleid}.bam > ${params.sampleid}.bam.bai

		samtools idxstats ${params.sampleid}.bam > ${params.sampleid}.bam.stats
		"""
}