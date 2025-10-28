#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// params.sampleid 			= "${params.sampleid}"
params.outdir = "${workflow.outputDir}"
params.threads = 10
params.bin_size = 1000
params.bamdir = "${params.outdir}/mags/mapped"
params.bin = "${params.outdir}/vamb/bins"
params.mags_catalogue = "${params.outdir}/mags/mags_catalogue.fna"
params.CHECKMDB = "/home/james/repos/github/metagenome/databases/CheckM2_database/uniref100.KO.1.dmnd"

// moduleS
include { vamb_binning } from '../modules/binning'
include { bin_qc } from '../modules/qc'
include { classify } from '../modules/classification'

workflow {

	log.info(
		"""
			Binning and Classifying MAGs

			usage: ${projectDir}/workflows/binning_classification.nf --params.outdir output_dir 	-resume

			========Sources===============
			codeBase  : ${projectDir}
			outdir    : ${params.outdir}
			bamdir = "${params.bamdir}"
			mags_catalogue = "${params.mags_catalogue}"

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	vamb_binning("${params.mags_catalogue}", "${params.bamdir}", "${params.bin_size}")
	// bins_dir = channel.fromPath("${params.bin}").collect()
	bin_qc(vamb_binning.out.bins)
}
