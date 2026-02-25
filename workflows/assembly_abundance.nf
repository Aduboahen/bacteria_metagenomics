#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// module
include { FASTPLONG_CLEAN_READS } from '../modules/fastp'
include { KRAKEN2_ASSIGN_TAXA } from '../modules/kraken'
include { MINIMAP2_REMOVE_HOST_READS } from '../modules/minimap2'
include { FLYE_ASSEMBLE } from '../modules/flye'
include { BRACKEN_ABUNDANCE } from '../modules/bracken'
include { KRONA_VISUALISE } from '../modules/krona'
include { ALPHA_DIVERSITY } from '../modules/diversity'

workflow taxa_assign_assembly {
	take:
	fastq_ch
	base_quality
	read_length
	hosts
	KRAKEN2DB

	main:
	FASTPLONG_CLEAN_READS(fastq_ch, base_quality, read_length)
	MINIMAP2_REMOVE_HOST_READS(FASTPLONG_CLEAN_READS.out.read, hosts)
	KRAKEN2_ASSIGN_TAXA(MINIMAP2_REMOVE_HOST_READS.out, KRAKEN2DB)
	BRACKEN_ABUNDANCE(KRAKEN2_ASSIGN_TAXA.out.kraken_report, KRAKEN2DB)
	KRONA_VISUALISE(BRACKEN_ABUNDANCE.out.bracken_report)
	ALPHA_DIVERSITY(BRACKEN_ABUNDANCE.out.bracken_file)
	FLYE_ASSEMBLE(MINIMAP2_REMOVE_HOST_READS.out)

	emit:
	mags_file = FLYE_ASSEMBLE.out.mag_file
	host_dep_reads = MINIMAP2_REMOVE_HOST_READS.out
	bracken_file = BRACKEN_ABUNDANCE.out.bracken_file
}
