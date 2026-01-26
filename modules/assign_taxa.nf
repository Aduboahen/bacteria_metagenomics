process assign_taxa {
	tag 'assign_taxa'
	publishDir "${params.outdir}/kraken/abundance", mode: 'copy', pattern: "*kraken2"
	publishDir "${params.outdir}/kraken/report", mode: 'copy', pattern: "*.k2report"
	publishDir "${params.outdir}/kraken/classified", mode: 'copy', pattern: "*_classified.fastq"
	publishDir "${params.outdir}/kraken/unclassified", mode: 'copy', pattern: "*_unclassified.fastq"

	input:
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}.kraken2", emit: taxa_file  // 'Assigned taxa results'
		path "${params.sampleid}.k2report", emit: kraken_report // 'Kraken2 report file'
		path "${params.sampleid}_classified.fastq" // 'Unclassified reads'
		path "${params.sampleid}_unclassified.fastq" // 'Unclassified reads'

	script:
		"""
			kraken2 --db ${params.KRAKEN2DB} --report ${params.sampleid}.k2report \
			--classified-out ${params.sampleid}_classified.fastq \
			--unclassified-out ${params.sampleid}_unclassified.fastq \
			--output ${params.sampleid}.kraken2 --report-minimizer-data --use-names \
			--threads ${params.threads} --memory-mapping ${read}
		"""
}


process remove_host_reads {
	tag 'remove_host_reads'
	
	publishDir "${params.outdir}/kraken/host_depleted", mode: 'copy', pattern: "*.fastq.gz"

	input:
		path read // 'Input read file (fastq)'
		// path taxa_file // 'Taxonomic assignment file from Kraken2'

	output:
		path "${params.sampleid}_cleaned.fastq.gz" // 'Reads without host reads'

	script:
		"""
			minimap2 -ax map-ont ${params.hosts} ${read}  | samtools sort | samtools view -f 4 | samtools fastq - > ${params.sampleid}_cleaned.fastq

			gzip ${params.sampleid}_cleaned.fastq
		"""
}
