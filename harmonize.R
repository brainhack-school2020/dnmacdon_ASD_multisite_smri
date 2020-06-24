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
	# Parse the command line arguments (should only be an input file name and an output file)
	args <- commandArgs(trailingOnly = TRUE)
	
	# Arguments should be input file, output file, filename of features to harmonize, site feature, covariates. Minimum of 4.
	if (length(args) < 4)
	{
		cat("ERROR: MUST HAVE AT LEAST FOUR COMMAND LINE ARGUMENTS: input file, output file,\n")
		cat("  filename of list of features to harmonize, name of the site/batch feature, then optional covariates.\n")
		quit(status = 10)
	} else
	{
		input_file <- args[1]
		output_file <- args[2]
		file_features_to_harmonize <- args[3]
		site_feature <- args[4]
		covars <- c()
		if (length(args) > 4) covars <- args[-(1:4)] # Covariates are in all of the arguments after the fourth.
	}
	cat(paste("Using", input_file, "as input, and", output_file, "as output file.\n"))

	# Read in data
	features_to_harmonize <- readLines(file_features_to_harmonize) # readLines() gives us a vector of strings
	input <- read.csv(input_file)
	#input <- read.csv(input_file, stringsAsFactors=FALSE)
	
	# Extract features and make sure command line feature arguments make sense
	features <- colnames(input)

	if ( (all(c(features_to_harmonize, site_feature, covars) %in% features)) )
	{
		cat("All features exist in the dataset.\n")
	} else 
	{
		cat("ERROR: Features given on command line do not exist in the data file.\n")
		quit(status = 10)
	}

	# Harmonize data using neuroCombat
	# Note that neuroCombat wants observations in columns, features in rows. Output is in same format..
	harmonized <- neuroCombat( dat = t(input[features_to_harmonize]), batch = t(input[site_feature]) )
	if ( ncol(harmonized$dat.combat) != nrow(input) ) 
		cat("WARNING: output has different number of rows as input. May be due to blank or constant rows in input.\n")


	# Combine the harmonized data with the site data and covariates
	output <- cbind(t(harmonized$dat.combat), input[covars])
	output <- cbind(output, input[site_feature])
	
	# Output harmonized data
	cat(paste("Writing output to", output_file,"\n"))
	write.csv(output, output_file, row.names=TRUE)

	cat("Exiting harmonize.R\n")
}

# Make it so, Number One.
main()
