# Metagenome Analysis for Long reads

## Tools

**fastplong**\
**kraken2**\
**bracken**\
**flye**\
**vamb**\
**checkm**\
**minimap2**\
**gtdb-tk**\
**abricate**

## Databases
**k2_standard_16_GB**\
**CheckM2**

<!-- TODO add links for databses -->


## Usage

- Clone the repository

```bash
git clone https://github.com/Aduboahen/bacteria_metagenomics.git
cd bacteria_metagenomics
```

- Create mamba environments and install dependencies

```bash
mamba create -n bacteria_meta -file main.yml
mamba create -n bacteria_meta -file assembly.yml
mamba create -n bacteria_meta -file checkm2.yml
```

### Prepare your samples

1. Create a directory for the fastq files; default: ./input
2. Create a directory for the databases; default: ./databases
3. Create a directory for host genome, copy fasta file into it and generate indexes with minimap2 (minmap2 -d <host.mmi> <host.fasta.gz>); default hosts


### Run the pipeline

Look in nextflow.config file to edit input, host genome, databses, and output directories

Execute the workflow using the following command:
```bash
nextflow run main.nf
```

## Pipeline Summary

1. QC & Preprocessing: **fastplong**
2. Remove host reeads: **minimap2**
3. Estimate abundance: **kraken2**
4. Refine abundance estimate: **bracken**
5. Visualise abundance: **krona**
6. Assembly: **flye**
7. Binning: **vamb**
8. Refine bins: **checkm2**
9. Classfy MAGs: **gtdbtk**
10. AMR Genes: **abricate**

## License

This project is licensed under the terms of the GNU GENERAL PUBLIC LICENSE.

**Author**: James Osei-Mensa

**Affiliation**: Infectious Diseases Epidemiology Research Group (IDERG), Kumasi Centre for Collaborative Research in Tropical Medicine (KCCR)