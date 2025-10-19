process abundance_estimation {
	tag 'abundance_estimation'
	conda '/home/james/miniconda3/envs/bacteria_meta'
	publishDir "${params.outdir}/abundance", mode: 'copy', pattern: "*.bracken*"

	input:
		path kraken_report // 'Taxonomic assignment reportt from Kraken2'

	output:
		path "${params.sampleid}.bracken.report", emit: bracken_report // 'Bracken report file'
		path "${params.sampleid}.bracken", emit: bracken_file // 'Bracken output file'

	script:
		"""
		bracken -d ${params.KRAKEN2_DB} -i ${kraken_report} -o ${params.sampleid}.bracken -w ${params.sampleid}.bracken.report -r 200
		"""
}