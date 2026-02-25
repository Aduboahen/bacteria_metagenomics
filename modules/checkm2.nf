process CHECKM2_BIN_QC {
	label "checkm2 bin qc"
	publishDir "${params.outdir}/QC/", mode: 'copy'

	input:
	path bin_dir
	path CHECKMDB

	output:
	path "checkm"

	script:
	"""
		checkm2 predict --input ${bin_dir} --output-directory "checkm" \
		--database_path ${CHECKMDB} \
		--allmodels --threads ${params.threads} --force

		# dRep dereplicate ${params.outdir}/drep -g ${bin_dir} -p ${params.threads}
		"""
}