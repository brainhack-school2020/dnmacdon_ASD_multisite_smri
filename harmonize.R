# harmonize.R
# R script to perform inter-site harmonization of data using neuroCombat (https://github.com/Jfortin1/ComBatHarmonization)

# Ensure required packages are installed 
packages_to_check <- c("devtools")
required_packages <- packages_to_check[!(packages_to_check %in% installed.packages()[,"Package"])]
if(length(required_packages)) install.packages(required_packages, repos="https://cran.r-project.org")
if (!("neuroCombat" %in% installed.packages()[,"Package"])) 
{
	library(devtools)
	install_github("jfortin1/CombatHarmonization/R/neuroCombat")
}
library(neuroCombat)


main <- function()
{
	cat("Harmonizing data using ComBat...\n")

	# Parse the command line arguments 
	args <- commandArgs(trailingOnly = TRUE)
	
	# Arguments should be input file, output file, filename of features to harmonize, site feature, regressor, ComBat covariates,
	# model covariates. Minimum of 5.
	if (length(args) < 5)
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
		X <- args[5] # Independant variable.
		if (length(args) > 5) covars <- strsplit(gsub(" ","",args[6]),",")[[1]]
		if (length(args) > 6) mod_covars <- strsplit(gsub(" ","",args[7]),",")[[1]]
	}
	cat(paste("... using", input_file, "as input, and", output_file, "as output file.\n"))
	cat(paste("... using ComBat covariate", covars, "\n"))
	cat(paste("... site information is in", site_feature, "\n"))

	# Read in data
	features_to_harmonize <- readLines(file_features_to_harmonize) # readLines() gives us a vector of strings
	input <- read.csv(input_file)
	
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

	# If there are covariates, create a model matrix to pass to neuroCombat()
	if(length(covars)>0)
	{
		formula <- as.formula(paste("~",paste(covars,collapse="+")))
		covar_mat <- model.matrix(formula, data = input)
	}

	# Harmonize data using neuroCombat
	# Note that neuroCombat wants observations in columns, features in rows. Output is in same format.
	if ( exists("covar_mat") ) 
		harmonized <- neuroCombat( dat = t(input[features_to_harmonize]), batch = t(input[site_feature]), mod = covar_mat )
	else
		harmonized <- neuroCombat( dat = t(input[features_to_harmonize]), batch = t(input[site_feature]) )

	if ( ncol(harmonized$dat.combat) != nrow(input) ) 
		cat("WARNING: output has different number of rows as input. May be due to blank or constant rows in input.\n")

	# Combine the harmonized data with the site data, covariates, IV 
	output <- cbind(t(harmonized$dat.combat), input[covars])
	output <- cbind(output, input[site_feature])
	output <- cbind(output, input[X])
	
	# Check for model covariates that are not already included
	other_covars <- mod_covars[ !(mod_covars %in% covars) ]
	output <- cbind(output, input[other_covars])

	# Output harmonized data
	cat(paste("Writing output to", output_file,"\n"))
	write.csv(output, output_file, row.names=TRUE, na="")
}

# Make it so, Number One.
main()
