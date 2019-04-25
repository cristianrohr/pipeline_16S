#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=40_rarefaction
OUTPUT_DIR=50_otu_tables
mkdir $OUTPUT_DIR

LEVELS=$(echo $SIMILARITYS | tr "," "\n")

for i in ${LEVELS}
do
        echo -e "\tSIMILARITY: ${i}"
        SIM=${i}_percent_similarity

        mkdir -p ${OUTPUT_DIR}/${SIM}

	biom convert -i ${INPUT_DIR}/${SIM}/otu_table.biom -o ${OUTPUT_DIR}/${SIM}/seqs_otu_table.txt --to-tsv --header-key taxonomy

	if [ $i -eq 97 ]
	then
		echo -e "\t\tSumarizo los taxa y hago los plots"
		[[ ${NUM_SAMPLES} -eq "1" ]] && ONE_SAMPLE="-c bar" || ONE_SAMPLE=""
		echo -e "\t\t\tONE_SAMPLE: ${ONE_SAMPLE}"

		#echo -e "Create directories"
		#echo -e "mkdir -p ${OUTPUT_DIR}/${SIM}/summarized_plots_relative"
		#echo -e "mkdir -p ${OUTPUT_DIR}/${SIM}/summarized_plots_absolute"

		for j in {relative,absolute}
		do
			echo -e "\t\t\t$j"
			[[ "$j" == "absolute" ]] && IS_ABSOLUTE="-a" || IS_ABSOLUTE=""
			echo -e "\t\t\t\tIS_ABSOLUTE: ${IS_ABSOLUTE}"

			echo -e "\t\t\t\tSummarize taxa"
			summarize_taxa.py -i ${INPUT_DIR}/${SIM}/otu_table.biom -o ${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/ ${IS_ABSOLUTE}

			echo -e "\t\t\t\tPlot taxa summary"
#			workon test
			plot_taxa_summary.py -i ${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/otu_table_L2.txt,${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/otu_table_L3.txt,${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/otu_table_L4.txt,${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/otu_table_L5.txt,${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/otu_table_L6.txt -o ${OUTPUT_DIR}/${SIM}/summarized_plots_${j}/taxa_summary_plots/ ${ONE_SAMPLE}
#			deactivate
		done
	fi

done



