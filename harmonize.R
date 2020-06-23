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
	print(length(args))
	# Arguments should be input file, output directory, feature to harmonize, covariates. Minimum of 3.
	if (length(args) < 3)
	{
		print("Must have at least three command line arguments: input file, output directory, feature to harmonize, then optional covariates.")
		stop()
	} else
	{
		input_file <- args[1]
		output_dir <- args[2]
		feature_to_harmonize <- args[3]
		if (length(args) > 3) covars <- args[-(1:3)] # Covariates are in all of the arguments after the third.

	print(paste("Using", input_file, "as input, and", output_dir, "as output directory."))

	# Read in data
	input <- read.csv(input_file)

	features <- colnames(input)
	print(features)

	print("Exiting harmonize.R")
}

# Make it so, Number One.
main()
