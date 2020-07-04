#!/bin/bash

# This script manages a small "pipeline" to take multisite subcortical volume data (though it could be any
# type of data), harmonize it using neuroComBat, output the harmonized data, and generate a forest plot
# showing effect sizes of a covariate of interest on each of the subcortical volumes. This forest plot
# also shows the effect size calculations from linear regression on the unharmonized data, with site as
# a covariate, and linear mixed models, with site as a random factor (random intercept).

USAGE="Usage: $0 -i input_file -o output_dir -s site_column_name -x column name of regressor -c comma separated covariate list\n \
	-l name of control condition for regressor (e.g. 0 or \"Control\") -q comma separates list of QC masking column names\n
	The names of the features (dependent variables) must be of the format QCname_vol. For example, if the QC masking columns\n
	are L_str,R_str then the features or dependent variables must be L_str_vol,R_str_vol in the data file."

# Halt execution if any step fails
set -e

# ------------- Parse command line arguments and save them -------------------------
if [ "$#" == "0" ]; then
	echo $USAGE
	exit 1
fi

while (( "$#" )); do
	case $1 in
	-i)
		INFILE="$2"
		shift
		shift
		;;
	-o)
		OUTDIR="$2"
		shift
		shift
		;;
	-s)
		SITE="$2"
		shift
		shift
		;;
	-x)
		X="$2"
		shift
		shift
		;;
	-c)
		COVAR="$2"
		shift
		shift
		;;
	-l)
		CONTROL="$2"
		shift
		shift
		;;
	-q)
		QC_MASK="$2"
		shift
		shift
		;;
	-t)
		QC_THRESH="$2"
		shift
		shift
		;;
	-h)
		echo $USAGE
		shift
		exit 
		;;
	esac
done

if [[ ! -d $OUTDIR ]]; then 
	mkdir $OUTDIR 
fi

# ------------ Run the pipeline ----------------------------------------------
./harmonize_data_prep.py $INFILE $QC_MASK $QC_THRESH $OUTDIR/int_masked.csv
echo JA JA JA

