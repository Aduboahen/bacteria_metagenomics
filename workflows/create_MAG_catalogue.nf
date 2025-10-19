#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir 		= "${params.outdir}"
params.threads 		= 10
params.KRAKEN2_DB = "$projectDir/k2_standard_16_GB_20250714" // path to kraken2 database
params.magsdir 		= "${params.outdir}/mags/**/*.assembly.fasta"
// module
include {concat_mags} from '../modules/concatenate_mags'

workflow {
		log.info """"
			Create MAG catalogue

			========Sources===============
			codeBase   			: $projectDir
			output path     : $params.outdir
			KRAKEN2 DB 			: $params.KRAKEN2_DB
			MAGs path
			threads    			: $params.threads

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""

		mag_files = Channel.fromPath("${params.magsdir}").collect()
    concat_mags(mag_files)
}