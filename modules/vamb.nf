process VAMB_BINNING {
	label "vamb_binning"
	publishDir "${params.outdir}", mode: 'copy'

	input:
	path (mags_catalogue)
	// 'Input MAGs catalogue (fasta)'
	path "bams/*"
	// sorted bam file mapped to MAG catalogue
	val (bin_size)

	output:
	path "vamb/bins", emit: 'bins'	// directory containing vamb bins
	path "vamb/bins/*.fna", emit: 'fasta'// vamb generated fasta files for each bin
	path "vamb"

	script:
	"""
			source ${params.vamb_env}

			vamb bin default --fasta ${mags_catalogue} --outdir "vamb" --bamdir bams --minfasta ${bin_size} -p ${params.threads} --seed 373
		"""
}

process VAMB_CONCAT {
	label "vamb_concat"
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*"

	input:
		path mags_files // 'Path to saamebled MAGs files for all samples'

	output:
		path "mags_catalogue.fna",  emit: mags_catalogue // 'Concatenated MAGs in FASTA format'
		path "mags_catalogue.mmi" // MAG catalogue index file

	script:
		"""
			source ${params.vamb_env}
			
			python ${params.vamb_concat} mags_catalogue.fna ${mags_files}

			minimap2 -d mags_catalogue.mmi mags_catalogue.fna
		"""
}