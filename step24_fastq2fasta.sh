#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=20_filter_stitched_reads_score
OUTPUT_DIR=24_fastq2fasta
mkdir $OUTPUT_DIR

run_fastq_to_fasta.pl -p ${THREADS} -o ${OUTPUT_DIR} ${INPUT_DIR}/*.fastq

# The next steps in the pipeline require the sequences to be in FASTA format, 
# which we will generate using this command (< 1 min on 1 CPU):

# run_fastq_to_fasta.pl -p 1 -o fasta_files filtered_reads/*fastq
# Note that this command removes any sequences containing "N" (a fully ambiguous base read),
# which is << 1% of the reads after the read filtering steps above.
