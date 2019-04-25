#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=26_chimera_filter/
OUTPUT_DIR=29_combine_fasta_files
mkdir ${OUTPUT_DIR}

add_qiime_labels.py -i ${INPUT_DIR} -m ${MAPPING_FILE} -c FileInput -o ${OUTPUT_DIR}

# Esto solo lo hago para mantener la nomenclatura vieja
mv ${OUTPUT_DIR}/combined_seqs.fna ${OUTPUT_DIR}/seqs.fna

# Now that we have adequately prepared the reads, we can now run OTU picking using QIIME. An Operational Taxonomic Unit (OTU) defines a taxonomic group based on sequence similarity among sampled organisms. QIIME software clusters sequence reads from microbial communities in order to classify its constituent micro-organisms into OTUs. QIIME requires FASTA files to be input in a specific format (specifically, sample names need to be at the beginning of each header line). We have provided the mapping file ("map.txt"), which links filenames to sample names and metadata.

# If you open up map.txt (e.g. with vim) you will notice that 2 columns are present without any data: "BarcodeSequence" and "LinkerPrimerSequence". We don't need to use these columns, so we have left them blank.

# Also, you will see that the "FileInput" column contains the names of each FASTA file, which is what we need to specify for the command below.

# This command will correctly format the input FASTA files and output a single FASTA:

# add_qiime_labels.py -i non_chimeras/ -m map.txt -c FileInput -o combined_fasta 
# If you take a look at combined_fasta/combined_seqs.fna you can see that the first column of header line is a sample name taken from the mapping file.

# Now that the input file has been correctly formatted we can run the actual OTU picking program!
