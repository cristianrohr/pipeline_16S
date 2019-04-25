#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=26_chimera_filter

create_qiime_map.pl ${INPUT_DIR}/*fasta > ${MAPPING_FILE}

