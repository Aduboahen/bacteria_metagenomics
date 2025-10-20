process vamb_binning{
	tag 'vamb binning'

	input:
		path mags_catalogue // 'Input MAGs file (fasta)'
		path bamsdir // sorted bam file mapped to MAG catalogue

	script:
		"""
		source ~/.virtualenvs/vamb/bin/activate

		vamb bin default --fasta ${mags_catalogue} --outdir "${params.outdir}/vamb" --bamdir ${bamsdir} -p ${params.threads} --minfasta ${params.bins}
		"""
}