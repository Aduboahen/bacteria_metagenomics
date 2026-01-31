process vamb_binning{
	tag 'vamb binning'
	publishDir "${params.outdir}", mode: 'copy'

	input:
		path mags_catalogue // 'Input MAGs file (fasta)'
		path bamsdir // sorted bam file mapped to MAG catalogue
		val bin_size
	
	output:
		path "vamb/bins", emit: 'bins', type: 'dir' // directory containing vamb bins
		path "vamb"
	
	script:
		"""
			source ~/.virtualenvs/vamb/bin/activate

			vamb bin default --fasta ${mags_catalogue} --outdir "vamb" \
			--bamdir ${bamsdir} --minfasta ${bin_size} -p ${params.threads}
		"""
}