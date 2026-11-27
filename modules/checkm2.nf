process CHECKM2_BIN_QC {
    // run checkm2 on binned assemblies to
    // determine quality of bins present in metagenome
    label "checkm2"
    publishDir "${params.outdir}/${params.run_date}/QC/", mode: 'link'

    input:
    path bin_dir

    output:
    path "checkm"

    script:
    """
   		checkm2 predict --input ${bin_dir} --output-directory "checkm" \
   		--database_path ${params.CHECKMDB} \
   		--allmodels --threads ${task.cpus} --force

   		# dRep dereplicate ${params.outdir}/${params.run_date}/drep -g ${bin_dir} -p ${task.cpus}
   		"""
}
