process abundance_estimation {
	tag 'abundance_estimation'
	publishDir "${params.outdir}/abundance", mode: 'copy', pattern: "*.tsv"

	input:
		path taxa_file // 'Taxonomic assignment file from Kraken2'
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}_abundance.tsv", emit: abundance_file // 'Abundance estimation results'

	script:
		"""
		bracken -d -i ${taxa_file} -o ${params.sampleid}_abundance.txt \
		-w ${params.sampleid}_bracken.report
		"""

}