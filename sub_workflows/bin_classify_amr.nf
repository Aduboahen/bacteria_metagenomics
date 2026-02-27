#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// moduleS
include { VAMB_BINNING } from '../modules/vamb'
include { CHECKM2_BIN_QC } from '../modules/checkm2'
include { BETA_DIVERSITY } from '../modules/diversity'
include { GTDB_CLASSIFY } from '../modules/gtdbtk'
include { ABRICATE_BINS } from '../modules/abricate'

workflow bin_classify {
	take:
	bracken_files
	mags_catalogue
	bams
	bin_size
	CHECKMDB

	main:
	BETA_DIVERSITY(bracken_files)
	VAMB_BINNING(mags_catalogue, bams, bin_size)
	CHECKM2_BIN_QC(VAMB_BINNING.out.bins, CHECKMDB)
	ABRICATE_BINS(VAMB_BINNING.out.fasta.collect())
	GTDB_CLASSIFY(VAMB_BINNING.out.bins)

	emit:
	bins = VAMB_BINNING.out.bins
	fasta = VAMB_BINNING.out.fasta
}
