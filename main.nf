#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { taxa_assign_assembly } from './sub_workflows/assembly_abundance'
include { create_mag_catalogue } from './sub_workflows/mag_catalogue'
include { mapping_mags } from './sub_workflows/mapping'
include { bin_classify } from './sub_workflows/bin_classify_amr'


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

	fastq_ch = channel.fromPath("${params.inputdir}/*", type: 'dir', checkIfExists: true)
		.map { folder ->
			def sample_id = folder.name
			return [sample_id, folder]
		}

	taxa_assign_assembly(
		fastq_ch,
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
