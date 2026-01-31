#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

outputDir = "${workflow.outputDir}"

// module
include { concat_mags } from '../modules/concatenate_mags'
include { abricate_contigs } from '../modules/resistance_finder'

workflow {
	log.info(
		""""
			Create MAG catalogue
			========Sources===============
			codeBase   			: ${projectDir}
			outdir     : ${outputDir}
			MAGs path	: "${outputDir}/mags/**/*.assembly.fasta"
			threads    			: ${params.threads}
			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	mag_files = channel.fromPath("${params.magsdir}").collect()
	concat_mags(mag_files)
	abricate_contigs(mag_files)
}
