#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=24_fastq2fasta
OUTPUT_DIR=26_chimera_filter
#mkdir $OUTPUT_DIR

# Database
RDP_DB_UCHIME=${STEP26_DB}

chimera_filter.pl -type 1 -thread ${THREADS} -db ${RDP_DB_UCHIME} ${INPUT_DIR}/*fasta -o ${OUTPUT_DIR} -log ${OUTPUT_DIR}/chimera_filter_log.txt

# Due to the alternating conserved and variable regions in the 16S gene, during PCR amplification,
# a strand that is partially extended in one cycle can act as a primer in a later cycle and anneal
# to a template in the wrong position. This is called a chimeric DNA molecule, and we want to remove
# these so as not to treat them as true DNA samples. This step is important for microbiome work,
# as otherwise these reads would be called as novel OTUs. In fact, it is likely that not all
# chimeric reads will be removed by this step. Using our sequences in FASTA files we can run the chimera filtering (~3 min on 1 CPU):

# Where "-type 1" means that any reads clearly called as chimeric AND reads that are ambiguous are filtered out.
