#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// params
params.outdir = "${workflow.outputDir}"

// moduleS
include { vamb_binning } from '../modules/binning'
include { bin_qc } from '../modules/qc'
include { concat_mags } from '../modules/concatenate_mags'
include {beta_diversity} from '../modules/abundance_correction'
include { classify } from '../modules/classification'

workflow {

	log.info(
		"""
			Binning and Classifying MAGs

			usage: ${projectDir}/workflows/binning_classification.nf --params.outdir output_dir 	-resume

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
	
	mag_files = channel.fromPath("${params.magsdir}").collect()
	bracken_files = channel.fromPath("${params.bracken}").collect()
	beta_diversity(bracken_files)
	concat_mags(mag_files)
	vamb_binning(concat_mags.out.mags_catalogue, "${params.bamsdir}", "${params.bin_size}", mag_files)
	bin_qc(vamb_binning.out.bins)
	// classify(vamb_binning.out.bins)
}
