#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir   			= "${params.outdir}"
// params.sampleid 			= "${params.sampleid}"
params.threads  			=  10
params.bins 					= 1000
params.bamdir 				= "${params.outdir}/mags/mapped"
params.mags_catalogue = "${params.outdir}/mags/mags_catalogue.fna"
params.KRAKEN2_DB 		= "$projectDir/k2_standard_16_GB_20250714" // path to kraken2 database

// moduleS
include {vamb_binning} from '../modules/binning'
// include {classify} from '../modules/classification.nf'

workflow{

	log.info """"
			Binning and Classifying MAGs

			usage: ${projectDir}/workflows/binning_classification.nf --outdir output_dir 	-resume

			========Sources===============
			codeBase  : $projectDir
			outDir    : $params.outdir
			KRAKEN2 DB : $params.KRAKEN2_DB
			params.bamdir = "${params.outdir}/mags/mapped"
			params.mags_catalogue = "${params.outdir}/mags/mags_catalogue.fna"
			threads   : $params.threads

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""

	vamb_binning(params.mags_catalogue, params.bamdir)
	// classify(params.mags_catalogue)

}