#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// module
include { VAMB_CONCAT } from '../modules/vamb'
include { ABRICATE_CONTIGS } from '../modules/abricate'

workflow create_mag_catalogue {
	take:
	contigs_files

	main:
	VAMB_CONCAT(contigs_files)
	ABRICATE_CONTIGS(contigs_files)

	emit:
	mags_catalogue = VAMB_CONCAT.out.contigs_catalogue
}
