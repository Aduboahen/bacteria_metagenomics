#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.outdir = "${params.outdir}"
params.sampleid = "${params.sampleid}"
params.threads = 10
params.mag_catalogue = "${params.outdir}/mags/mags_catalogue.fna"
params.human_dep_reads = "${params.outdir}/kraken/human_dep_reads/${params.sampleid}_human_dep.fastq"
// 'Input reads file (fastq)'
params.KRAKEN2_DB = "${projectDir}/k2_standard_16_GB_20250714"
// path to kraken2 database

// module
include { map_mags } from '../modules/mag_mapping'
include { vamb_binning } from '../modules/binning.nf'


workflow {
	log.info(
		"""
			MAP human depleted reads to MAG Catalogue

			========Sources===============
			codeBase   						: ${projectDir}
			sample     						: ${params.sampleid}
			output path     			: ${params.outdir}
			MAGs catalogue				: ${params.mag_catalogue}
			threads    						: ${params.threads}

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	map_mags(params.mag_catalogue, params.human_dep_reads)
}
