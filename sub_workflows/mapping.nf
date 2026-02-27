#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// modules
include { MINIMAP2_MAP_CATALOGUE } from '../modules/minimap2'

workflow mapping_mags{
	take:
	mags_catalogue
	host_dep_reads

	main:
	MINIMAP2_MAP_CATALOGUE(mags_catalogue, host_dep_reads)

	emit:
	bam = MINIMAP2_MAP_CATALOGUE.out.bam
}
