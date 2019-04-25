#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=30_pick_otus

LEVELS=$(echo $SIMILARITYS | tr "," "\n")

for i in $LEVELS
do
        echo -e "\tSIMILARITY: ${i}"
        SIM=${i}_percent_similarity

	biom summarize-table -i ${INPUT_DIR}/${SIM}/otu_table_mc1_w_tax_no_pynast_failures.biom -o ${INPUT_DIR}/${SIM}/otu_table_mc1_w_tax_no_pynast_failures_summary.txt
	biom summarize-table -i ${INPUT_DIR}/${SIM}/otu_table_high_conf.biom -o ${INPUT_DIR}/${SIM}/otu_table_high_conf_summary.txt

done

# The first four lines of clustering/otu_table_mc1_w_tax_no_pynast_failures_summary.txt are:

# Num samples: 24
# Num observations: 2434
# Total count: 12040
# Table density (fraction of non-zero values): 0.097
# This means that for the 24 separate samples, 2434 OTUs were called based on 12040 reads. Only 9.7% of the values in the sample x OTU table are non-zero, meaning that most OTUs are in a small number of samples.

# In contrast, the first four lines of clustering/otu_table_high_conf_summary.txt are:

# Num samples: 24
# Num observations: 887
# Total count: 10493
# Table density (fraction of non-zero values): 0.194
# After removing low-confidence OTUs, only 36% were retained: the number of OTUs dropped from 2434 to 887. This effect is generally even more drastic for bigger datasets. However, the numbers of reads only dropped from 12040 to 10493 (so 87% of the reads were retained). You can also see that the table density increased, as we would expect.
