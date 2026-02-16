process abundance_correction {
	tag "${params.sampleid}"
	publishDir "${params.outdir}/abundance_correction/bracken/abundance", mode: 'copy', pattern: "*.bracken"
	publishDir "${params.outdir}/abundance_correction/bracken/report", mode: 'copy', pattern: "*.breport"

	input:
		path kraken_report // 'Taxonomic assignment reportt from Kraken2'

	output:
		path "${params.sampleid}.breport", emit: bracken_report // 'Bracken report file'
		path "${params.sampleid}.bracken", emit: bracken_file // 'Bracken output file'

	script:
		"""
		bracken -d ${params.KRAKEN2DB} -i ${kraken_report} -o ${params.sampleid}.bracken -w ${params.sampleid}.breport -r 100 -l S -t ${params.threads}
		"""
}

process visualise_abundance{
	tag "${params.sampleid}"
	publishDir "${params.outdir}/krona", mode: 'copy', pattern: "*"

	input:
		path bracken_report // 'Path to abundance file from bracken'4

	output:
		path "${params.sampleid}.krona" // bracken report converted to krona format
		path "${params.sampleid}.krona.html" // krona plot


	script:
		"""
		kreport2krona.py -r ${bracken_report} -o ${params.sampleid}.krona

		ktImportText ${params.sampleid}.krona -o ${params.sampleid}.krona.html
		"""
}

process alpha_diversity{
	tag "${params.sampleid}"
	
	publishDir "${params.outdir}/abundance_correction/diversity", mode: 'copy'

	input:
		path bracken_file
	
	output:
		path "${params.sampleid}.alpha"
	
	script:
		"""
		alpha_diversity.py -f ${bracken_file} -a BP > ${params.sampleid}.alpha
		"""
}


process beta_diversity{
	tag "${params.sampleid}"
	
	publishDir "${params.outdir}/abundance_correction/diversity", mode: 'copy'

	input:
		path bracken_files
	
	output:
		path "beta_diversity"
	
	script:
		"""
			beta_diversity.py --input ${bracken_files} --type bracken > beta_diversity
		"""
}