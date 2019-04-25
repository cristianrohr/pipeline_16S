#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=10_stitch_pair_end_reads
OUTPUT_DIR=12_stitch_pair_end_qc
mkdir ${OUTPUT_DIR}

fastqc -t ${THREADS} ${INPUT_DIR}/*.fastq -o ${OUTPUT_DIR}/

cd ${OUTPUT_DIR}
multiqc .
cd ..

rm -f ${INPUT_DIR}/*.zip

