process vamb_binning{
	tag 'vamb binning'
	publishDir "${params.outdir}/vamb", mode: 'copy', pattern: "*"

	input:
		path mags_catalogue // 'Input MAGs file (fasta)'
		path bamsdir // sorted bam file mapped to MAG catalogue

	// output:
		// path "${params.sampleid}", emit: bins_file // 'Binned MAGs in FASTA format'

	script:
		"""
		source ~/.virtualenvs/vamb/bin/activate

		vamb bin default --fasta ${mags_catalogue} --outdir "${params.outdir}/vamb" --bamdir ${bamsdir} -p ${params.threads} --minfasta ${params.bins}
		"""
}