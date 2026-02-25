process ALPHA_DIVERSITY {
	label "alpha diversity"
	publishDir "${params.outdir}/bracken/diversity", mode: 'copy'

	input:
	tuple val(sample_id), path(bracken_file)

	output:
	path "${sample_id}.alpha"

	script:
	"""
		alpha_diversity.py -f ${bracken_file} -a BP > ${sample_id}.alpha
		"""
}


process BETA_DIVERSITY {
	label "beta diversity"
	publishDir "${params.outdir}/bracken/diversity", mode: 'copy'

	input:
	path(bracken_files)

	output:
	path "beta_diversity"

	script:
	"""
			beta_diversity.py --input ${bracken_files} --type bracken > beta_diversity
		"""
}
