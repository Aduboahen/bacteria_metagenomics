#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.sampleid = "${params.sampleid}"
params.outdir   = "$projectDir/results"
params.inputdir = "${params.inputdir}"
params.KRAKEN2_DB = "/home/james/repos/github/metagenome/k2_standard_16_GB_20250714" // path to kraken2 database
params.magsdir 		= "${params.outdir}/mags/**/*.assembly.fasta"  // directory containing MAGs
params.mag_catalogue = "${params.outdir}/mags/mags_catalogue.fna" // path to MAG catalogue
params.human_dep_reads = "${params.outdir}/kraken/human_dep_reads/${params.sampleid}_human_dep.fastq" // path to human genome depleted reads
params.bamdir 				= "${params.outdir}/mags/mapped" // path to BAMs
params.threads  =  10 
params.quality = 8 // base quality to include
params.length = 1000 // read length to include
params.bins = 1000 // size of MAg bin to include
