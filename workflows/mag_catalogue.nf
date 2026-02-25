#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// module
include { VAMB_CONCAT } from '../modules/vamb'
include { ABRICATE_CONTIGS } from '../modules/abricate'

workflow create_mag_catalogue {
	take:
	raw_mags

	main:
	VAMB_CONCAT(raw_mags)
	ABRICATE_CONTIGS(raw_mags)

	emit:
	mags_catalogue = VAMB_CONCAT.out.mags_catalogue
}
