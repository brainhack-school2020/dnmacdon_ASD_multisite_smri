#!/bin/bash

# This script manages a small "pipeline" to take multisite subcortical volume data (though it could be any
# type of data), harmonize it using neuroComBat, output the harmonized data, and generate a forest plot
# showing effect sizes of a covariate of interest on each of the subcortical volumes. This forest plot
# also shows the effect size calculations from linear regression on the unharmonized data, with site as
# a covariate, and linear mixed models, with site as a random factor (random intercept).

display_help() {
	echo "Usage: $0 arguments"
        echo " where all of the following arguments are required:"
	echo "         -i input file"
	echo "         -o output_dir"
	echo "         -s site_column_name"
	echo "         -z ComBat covariates as comma-separated list. Not necessarily the same as the regression covariates."
	echo "         -x column name of regressor / independent variable. Must be categorical."
	echo "         -l name of control condition for regressor (e.g. 0 or \"Control\")" 
	echo "         -c comma separated covariate list of covariate columns for the linear model"
	echo "         -q comma separates list of QC masking column names (QCname)"
	echo "         -t QC threshold. All features (dependant variable) with QC values at or below the threshold will be masked out"
	echo "The names of the features (dependent variables) must be of the format QCname_vol. For example, if the QC masking columns"
	echo "are L_str,R_str then the features or dependent variables must be L_str_vol,R_str_vol in the data file."
	exit 1
}

# Halt execution if any step fails
set -e

# ------------- Parse command line arguments and save them -------------------------
if [ ! "$#" == "18" ]; then
	display_help
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
	-z)
		COVAR_COMBAT="$2"
		shift
		shift
		;;
	-h)
		display_help
		shift
		exit 
		;;
	*)
		display_help
		printf $USAGE
		exit
		;;
	esac
done

# ----------------- Set up directories and temporary, intermediate filenames ----------------------
INT_MASKED=int_masked.csv
INT_HARMONIZED=harmonized_data.csv
INT_FEATURES=int_features.csv
INT_EFFECT_SIZES=int_es.csv
INT_ES_NAMES=int_es_names.csv
FP_NAME="forest-plot.png"
# Generate tmp directory dynamically to prevent data loss.
TMP_DIR="$(mktemp -d -p .)"

if [[ ! -d $OUTDIR ]]; then 
	mkdir $OUTDIR 
fi

if [[ ! -d $TMP_DIR ]]; then
	echo "Error creating temporary directory. Exiting."
	exit 1
fi

# ------------ Run the pipeline ----------------------------------------------
# Mask features based on QC
./harmonize_data_prep.py $INFILE $QC_MASK $QC_THRESH $TMP_DIR/$INT_MASKED $TMP_DIR/$INT_FEATURES

# Harmonize features. Put the harmonized data in the output directory, as the user may want it.
echo Rscript harmonize.R $TMP_DIR/$INT_MASKED $OUTDIR/$INT_HARMONIZED $TMP_DIR/$INT_FEATURES $SITE $COVAR_COMBAT
Rscript harmonize.R $TMP_DIR/$INT_MASKED $OUTDIR/$INT_HARMONIZED $TMP_DIR/$INT_FEATURES $SITE $X $COVAR_COMBAT $COVAR

# Fit linear models and save effect size measures
./harmonize_fit_models.py $OUTDIR/$INT_HARMONIZED $INFILE $X $CONTROL $COVAR $SITE $TMP_DIR $TMP_DIR/$INT_EFFECT_SIZES $TMP_DIR/$INT_ES_NAMES

# Generate forest plot
Rscript forest.R $TMP_DIR/$INT_EFFECT_SIZES $TMP_DIR/$INT_ES_NAMES $OUTDIR/$FP_NAME

# Remove temporary files
echo "Removing temporary files"
rm -R $TMP_DIR

echo "Processing complete"
