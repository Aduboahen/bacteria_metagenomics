#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir   = "${workflow.outputDir}"

// module
include {clean_reads} from '../modules/qc'
include {assign_taxa; extract_human_reads} from '../modules/assign_taxa'
include {assemble_mags} from '../modules/assemble_mags'
include {abundance_correction} from '../modules/abundance_correction'
include {visualise_abundance} from '../modules/abundance_correction'
include {alpha_diversity} from '../modules/abundance_correction'

workflow {
		log.info"""
			Assemble reads and generate MAGS

			========Sources===============
			codeBase  	: $projectDir
			sample    	: $params.sampleid
			inputdir     	: $params.inputdir
			params.outdir    	: $params.outdir
			KRAKEN2 DB 	: $params.KRAKEN2DB

			=======Filters========
			required length   : $params.length
			quality threshold : $params.quality

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""

		fastq = channel.fromPath("${params.inputdir}/${params.sampleid}.fastq.gz").ifEmpty{"no such file"}
		clean_reads(fastq)
		assign_taxa(clean_reads.out.read)
		extract_human_reads(clean_reads.out.read, assign_taxa.out.taxa_file)
		abundance_correction(assign_taxa.out.kraken_report)
		visualise_abundance(abundance_correction.out.bracken_report)
		alpha_diversity(abundance_correction.out.bracken_file)
		assemble_mags(extract_human_reads.out)
}