process concat_mags {
	tag 'concatenate mags'
	publishDir "${outputDir}/mags", mode: 'copy', pattern: "*"

	input:
		path mags_files // 'Path to saamebled MAGs files for all samples'

	output:
		path "mags_catalogue.fna",  emit: mags_catalogue // 'Concatenated MAGs in FASTA format'
		path "mags_catalogue.mmi" // MAG catalogue index file

	script:
		"""
			source ~/.virtualenvs/vamb/bin/activate
			
			python ~/repos/github/metagenome/scripts/vamb/src/concatenate.py mags_catalogue.fna ${mags_files}

			minimap2 -d mags_catalogue.mmi mags_catalogue.fna
		"""
}