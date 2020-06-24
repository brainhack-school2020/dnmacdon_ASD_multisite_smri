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
		print("ERROR: MUST HAVE AT LEAST FOUR COMMAND LINE ARGUMENTS: input file, output file,")
		print("  filename of list of features to harmonize, name of the site/batch feature, then optional covariates.")
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
	print(paste("Using", input_file, "as input, and", output_file, "as output file."))

	# Read in data
	features_to_harmonize <- readLines(file_features_to_harmonize) # readLines() gives us a vector of strings
	input <- read.csv(input_file)
	#input <- read.csv(input_file, stringsAsFactors=FALSE)
	
	# Extract features and make sure command line feature arguments make sense
	features <- colnames(input)

	if ( (all(c(features_to_harmonize, site_feature, covars) %in% features)) )
	{
		print("All features exist in the dataset.")
	} else 
	{
		print("ERROR: Features given on command line do not exist in the data file.")
		quit(status = 10)
	}

	# Harmonize data using neuroCombat
	
	# ----- DEBUG -----
	print(colnames(input[features_to_harmonize]))
	print(colnames(input[site_feature]))
	for (i in 1:length(features_to_harmonize))
	{
		print(paste(features_to_harmonize[i], class(input[[features_to_harmonize[i]]])))
	}
	print(paste(site_feature, class(input[[site_feature]]), length(unique(input[[site_feature]]))))
	# ----- DEBUG -----
	
	# Actual harmonization. Note that neuroCombat wants observations in columns, features in rows. Output is in same format..
	harmonized <- neuroCombat( dat = t(input[features_to_harmonize]), batch = t(input[site_feature]) )
	if ( ncol(harmonized$dat.combat) != nrow(input) ) i
		print("WARNING: output has different number of rows as input. May be due to blank or constant rows in input.")


	# Combine the harmonized data with the site data and covariates
	output <- cbind(t(harmonized$dat.combat), input[covars])
	output <- cbind(output, input[site_feature])
	print(colnames(output))
	print(dim(output))
	
	# Output harmonized data
	write.csv(output, output_file, row.names=TRUE)

	print("Exiting harmonize.R")
}

# Make it so, Number One.
main()
