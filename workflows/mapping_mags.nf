#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.outdir   = "${workflow.outputDir}"

// modules
include { map_mags } from '../modules/mag_mapping'

workflow {
	log.info(
		"""
			MAP host depleted reads to MAG Catalogue

			========Sources===============
			codeBase   						: ${projectDir}
			sample     						: ${params.sampleid}
			output path     			: ${params.outdir}
			MAGs catalogue				: ${params.mags_catalogue}

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	map_mags(params.mags_catalogue, params.host_dep_reads)
}
