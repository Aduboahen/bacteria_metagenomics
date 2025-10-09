process concatenate_mags {
	tag 'concatenate mags'
	conda '/home/james/miniconda3/envs/vamb'
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*."

	input:
		path mags_files // 'Input MAGs files (fna.gz)'

	output:
		path "${params.sampleid}_concatenated_mags.fna.gz",  emit: concat_mags // 'Concatenated MAGs in FASTA format'

	script:
		"""
			python /home/james/repos/github/vamb/src/concatenate.py ${params.sampleid}_concatenated_mags.fna.gz concatenate.py
		"""

}