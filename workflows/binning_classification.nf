#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// params.sampleid 			= "${params.sampleid}"
params.outdir = "$workflow.outputDir"
params.threads  			=  10
params.bin_size					= 1000
params.bamdir = "${params.outdir}/mags/mapped"
params.bin = "${params.outdir}/vamb/bins"
params.mags_catalogue = "${params.outdir}/mags/mags_catalogue.fna"
params.KRAKEN2_DB 		= "$launchDir/databases/k2_standard_16_GB_20250714" // path to kraken2 database
params.CHECKMDB = "/home/james/repos/github/metagenome/databases/CheckM2_database/niref100.KO.1.dmnd"

// moduleS
include {vamb_binning} from '../modules/binning'
include {bin_qc} from '../modules/qc'
include {bin_qc_debug} from '../modules/debug.nf'
include {classify} from '../modules/classification'

workflow{

		log.info """
			Binning and Classifying MAGs

			usage: ${projectDir}/workflows/binning_classification.nf --params.outdir output_dir 	-resume

			========Sources===============
			codeBase  : $projectDir
			outdir    : $params.outdir
			KRAKEN2 DB : $params.KRAKEN2_DB
			bamdir = "$params.bamdir"
			binsdir = "$params.bin"
			mags_catalogue = "$params.mags_catalogue"
			threads   : $params.threads

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""

		vamb_binning("$params.mags_catalogue", "${params.bamdir}", "${params.bin_size}")
		// bins_dir = channel.fromPath("$params.bin")
		bin_qc_debug(vamb_binning.out.bins)
		// classify(bin_qc.out)
}