# harmonize.R
# R script to perform inter-site harmonization of data using neuroCombat (https://github.com/Jfortin1/ComBatHarmonization)

# Ensure required packages are installed 
installed_packages <- c("metafor","devtools")
required_packages <- installed_packages[!(installed_packages %in% installed.packages()[,"Package"])]
if(length(required_packages)) install.packages(required_packages)
if (!("neuroCombat" %in% installed.packages()[,"Package"])) 
{
	library(devtools)
	install_github("jfortin1/CombatHarmonization/R/neuroCombat")
}
library(metafor)
library(neuroCombat)


main <- function()
{
	# Parse the command line arguments (should only be an input file name and an output directory)
	args <- commandArgs(trailingOnly = TRUE)
	
	# Arguments should be input file, output directory, feature to harmonize, covariates. Minimum of 3.
	if (length(args) < 3)
	{
		print("ERROR: MUST HAVE AT LEAST THREE COMMAND LINE ARGUMENTS: input file, output directory, feature to harmonize, then optional covariates.")
		quit(status = 10)
	} else
	{
		input_file <- args[1]
		output_dir <- args[2]
		feature_to_harmonize <- args[3]
		if (length(args) > 3) covars <- args[-(1:3)] # Covariates are in all of the arguments after the third.
	}
	print(paste("Using", input_file, "as input, and", output_dir, "as output directory."))

	# Read in data
	input <- read.csv(input_file)

	# Extract features and make sure command line feature arguments make sense
	features <- colnames(input)
	print(features)

	if ( (all(c(feature_to_harmonize, covars) %in% features)) )
	{
		print("All features exist in the dataset.")
	} else 
	{
		print("ERROR: Features given on command line do not exist in the data file.")
		quit(status = 10)
	}
	
	print("Exiting harmonize.R")
}

# Make it so, Number One.
main()
