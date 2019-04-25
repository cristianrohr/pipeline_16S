#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

OUTPUT_DIR=01_basic_stats
mkdir ${OUTPUT_DIR}

OUTPUT=${OUTPUT_DIR}/stats.txt
touch ${OUTPUT}

TOTAL=0
for FILE in 00_raw_data/*_R1_001.fastq
do
	NUM=$((`cat ${FILE} | wc -l` / 4 | bc))
	TOTAL=$((TOTAL+NUM))
	echo "${FILE}: ${NUM}" >> ${OUTPUT}
done
echo "TOTAL NUMBER OF PAIRS: ${TOTAL}" >> $OUTPUT
