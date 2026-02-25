#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { taxa_assign_assembly } from './workflows/assembly_abundance'
include { create_mag_catalogue } from './workflows/mag_catalogue'
include { mapping_mags } from './workflows/mapping'
include { bin_classify } from './workflows/bin_classify_amr'


workflow {
	log.info(
		"""
			Bacterial metagenome analysis pipeline for assembly, 
			taxonomic classification of MAGs, amd AMR gene detection.

			=======Author=======
			James Osei-Mensa
			oseimensa@kccr.de
		"""
	)

	fastq = channel.fromPath("${params.inputdir}/*.fastq.gz", checkIfExists: true)
		.map { file ->
			def sample_id = file.simpleName
			return [sample_id, file]
		}

	taxa_assign_assembly(
		fastq,
		params.base_quality,
		params.read_length,
		params.hosts,
		params.KRAKEN2DB,
	)

	create_mag_catalogue(taxa_assign_assembly.out.mags_file.collect())

	mapping_mags(
		create_mag_catalogue.out.mags_catalogue,
		taxa_assign_assembly.out.host_dep_reads,
	)

	all_bracken = taxa_assign_assembly.out.bracken_file
		.map { bracken -> bracken[1] }
		.collect()

	bin_classify(
		all_bracken,
		create_mag_catalogue.out.mags_catalogue,
		mapping_mags.out.bam.collect(),
		params.bin_size,
		params.CHECKMDB,
	)
}
