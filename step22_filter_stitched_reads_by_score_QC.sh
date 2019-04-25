#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=20_filter_stitched_reads_score
OUTPUT_DIR=22_filter_stitched_reads_score_QC

mkdir ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

cat ../${INPUT_DIR}/*.fastq | fastqc -t ${THREADS} -o . stdin
mv stdin_fastqc.html assembled.filtered.combined_fastqc.html
mv stdin_fastqc.zip assembled.filtered.combined_fastqc.zip
multiqc .
rm -f assembled.filtered.combined_fastqc.zip
cd ..

