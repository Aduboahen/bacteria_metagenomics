#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// moduleS
include { vamb_binning } from '../modules/binning'
include { bin_qc } from '../modules/qc'
include {beta_diversity} from '../modules/abundance_correction'
include { classify } from '../modules/classification'
include { abricate_bins } from '../modules/resistance_finder'

workflow {

	log.info(
		"""
			Binning and Classifying MAGs
			========Sources==========
			codeBase  : ${projectDir}
			outdir    : ${params.outdir}
			bamsdir : ${params.bamsdir}
			mags_catalogue : ${params.mags_catalogue}
			MAGs dir : ${params.magsdir}
			CHECKMDB : ${params.CHECKMDB}
			=======Filter=============
			bin size: ${params.bin_size}
			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)
	bracken_files = channel.fromPath("${params.bracken}").collect()
	beta_diversity(bracken_files)
	vamb_binning("${params.mags_catalogue}", "${params.bamsdir}", "${params.bin_size}")
	bin_qc(vamb_binning.out.bins,  "${params.CHECKMDB}")
	mag_bins = channel.fromPath("${params.bins}").collect()
	abricate_bins(mag_bins)
	classify(vamb_binning.out.bins)
}
