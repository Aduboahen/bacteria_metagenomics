#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// moduleS
include { VAMB_BINNING } from '../modules/vamb'
include { CHECKM2_BIN_QC } from '../modules/checkm2'
include { BETA_DIVERSITY } from '../modules/diversity'
include { GTDB_CLASSIFY } from '../modules/gtdbtk'
include { ABRICATE_MAGS } from '../modules/abricate'

workflow bin_classify {
	take:
	bracken_files
	contigs_catalogue
	bams
	bin_size
	CHECKMDB

	main:
	BETA_DIVERSITY(bracken_files)
	VAMB_BINNING(contigs_catalogue, bams, bin_size)
	CHECKM2_BIN_QC(VAMB_BINNING.out.bins, CHECKMDB)
	ABRICATE_MAGS(VAMB_BINNING.out.fasta.collect())
	GTDB_CLASSIFY(VAMB_BINNING.out.bins)

	emit:
	bins = VAMB_BINNING.out.bins
	fasta = VAMB_BINNING.out.fasta
}
