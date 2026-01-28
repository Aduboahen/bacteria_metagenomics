#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.outdir = "${workflow.outputDir}"

// module
include { concat_mags } from '../modules/concatenate_mags'

workflow {
	log.info(
		""""
			Create MAG catalogue

			========Sources===============
			codeBase   			: ${projectDir}
			outdir     : ${params.outdir}
			MAGs path	: "${params.magsdir}"
			threads    			: ${params.threads}

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	mag_files = channel.fromPath("${params.magsdir}").collect()
	concat_mags(mag_files)
}
