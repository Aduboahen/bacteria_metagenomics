#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir   = "$projectDir/results"
params.sampleid = "ERR5000343_sub12"
params.threads  =  10
params.quality = 8
params.length = 1000
params.inputdir = "${params.inputdir}"
params.KRAKEN2_DB = "/home/james/repos/github/metagenome/k2_standard_16_GB_20250714" // path to kraken2 database


// module
include {clean_reads} from '../modules/qc'
include {assign_taxa; extract_human_reads} from '../modules/assign_taxa'
include {assemble_mags} from '../modules/assemble_mags'
include {abundance_estimation} from '../modules/abundance_correction'

workflow {
		log.info"""
			Assemble reads and generate MAGS

			========Sources===============
			codeBase  	: $projectDir
			sample    	: $params.sampleid
			inputdir     	: $params.inputdir
			outdir    	: $params.outdir
			KRAKEN2 DB 	: $params.KRAKEN2_DB
			threads   	: $params.threads

			=======Filters========
			required length   : $params.length
			quality threshold : $params.quality

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""

		fastq = Channel.fromPath("${params.inputdir}/${params.sampleid}.fastq.gz").ifEmpty{"no such file"}
		clean_reads(fastq)
		assign_taxa(clean_reads.out.read)
		extract_human_reads(clean_reads.out.read, assign_taxa.out.taxa_file)
		abundance_estimation(assign_taxa.out.kraken_report)
		assemble_mags(extract_human_reads.out)
}