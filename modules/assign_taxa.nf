process assign_taxonomic {
	tag 'assign_taxa'
	publishDir "${params.outdir}/kraken/taxa", mode: 'copy', pattern: "*_kraken2_output.txt"
	publishDir "${params.outdir}/kraken/report", mode: 'copy', pattern: "*.k2report"
	publishDir "${params.outdir}/kraken/unclassified", mode: 'copy', pattern: "*_unclassified.fastq.gz"

	input:
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}.kraken2", emit: taxa_file  // 'Assigned taxa results'
		path "${params.sampleid}.k2report" // 'Kraken2 report file'
		path "${params.sampleid}_unclassified.fastq.gz" // 'Unclassified reads'

	script:
		"""
		kraken2 --db standard_db --report ${params.sampleid}.k2report \
		--unclassified-out ${params.sampleid}_unclassified.fastq.gz \
		--output ${params.sampleid}.kraken2 \
		--report-minimizer-data --use-names --threads ${params.threads}
		"""
}


process extract_human_reads {
	tag 'extract_human'
	publishDir "${params.outdir}/kraken/human_dep_reads", mode: 'copy', pattern: "*.fastq.gz"

	input:
		path read // 'Input read file (fastq)'
		path taxa_file // 'Taxonomic assignment file from Kraken2'

	output:
		path "${params.sampleid}_human_dep.fastq.gz" // 'Reads without human reads'

	script:
		"""
			extract_kraken_reads.py -k ${taxa_file} -s ${read} --taxid 9606 --exclude --output ${params.sampleid}_human_dep.fastq.gz --fastq-output
		"""
}