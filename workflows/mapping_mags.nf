#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

outputDir   = "${workflow.outputDir}"

// modules
include { map_mags } from '../modules/mag_mapping'
include {concat_mags} from '../modules/concatenate_mags'
workflow {
	log.info(
		"""
			MAP host depleted reads to MAG Catalogue
			========Sources===============
			codeBase   		 : ${projectDir}
			sample     		 : ${params.sampleid}
			output path    : ${outputDir}
			MAGs catalogue : ${params.mags_catalogue}
			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)
	map_mags("${params.mags_catalogue}", "${params.host_dep_reads}")
}
