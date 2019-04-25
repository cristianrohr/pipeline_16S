#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

OTU_DIR=30_pick_otus
INPUT_DIR=40_rarefaction
OUTPUT_DIR=60_alpha_diversity
mkdir $OUTPUT_DIR

LEVELS=$(echo $SIMILARITYS | tr "," "\n")

for i in ${LEVELS}
do
        echo -e "\tSIMILARITY: ${i}"
        SIM=${i}_percent_similarity

	mkdir -p ${OUTPUT_DIR}/${SIM}

	#alpha_rarefaction.py -i 60_rarefaction/otu_table.biom -o 80_alpha_diversity/alpha_rarefaction_plot -t 54_OTU_picking/rep_set.tre -m map.txt --min_rare_depth 40 --max_rare_depth 350 --num_steps 12

        echo "alpha_diversity:metrics chao1,chao1_ci,dominance,doubles,equitability,observed_species,observed_otus,osd,shannon,singles" > ${OUTPUT_DIR}/${SIM}/diversity_params.txt

	MAX=`grep " Min: " ${OTU_DIR}/${SIM}/otu_table_high_conf_summary.txt | cut -d ' ' -f 3 | cut -f 1 -d '.'`

        echo -e "MAX ${MAX}"
        int=${MAX%.*}
        echo -e "int ${int}"
        MAX=${int}
        STEP=$(($MAX/100))
        echo -e "STEP ${STEP}"
        STEPS=${STEP%.*}
        echo -e "STEPS ${STEPS}"

	alpha_rarefaction.py -p ${OUTPUT_DIR}/${SIM}//diversity_params.txt -i ${INPUT_DIR}/${SIM}/otu_table.biom -o ${OUTPUT_DIR}/${SIM}/alpha_rarefaction_plot -t ${OTU_DIR}/${SIM}/rep_set.tre -m ${MAPPING_FILE} --min_rare_depth 40 --max_rare_depth ${MAX} --num_steps ${STEPS}
done

# Alpha diversity analysis

## There is a clear qualitative difference between the microbiota of mice from the two source facilities based on the above plots. It's also possible that there might also be differences between the rarefaction curves of samples from different source facilities. Rarefaction plots show alpha diversity, which in this case is taken as a measure of the OTU richness per sample (takes < 1 min on 1 CPU):
