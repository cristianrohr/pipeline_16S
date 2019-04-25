#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

OUTPUT_DIR=02_raw_data_qc
mkdir ${OUTPUT_DIR}

fastqc -t ${THREADS} 00_raw_data/*.fastq -o ${OUTPUT_DIR}/

cd ${OUTPUT_DIR}/

multiqc .

cd ..

rm -f ${OUTPUT_DIR}/*.zip

