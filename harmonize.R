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

# Parse the command line arguments (should only be an input file name and an output directory)
args <- commandArgs(trailingOnly = TRUE)
input_file = "input.csv"  # Set the default input file if none is given on the command line.
output_dir = "output"     # Set default output directory

if (length(args) == 1)
{
	input_file <- args[1]
} else if (length(args) >= 2 )
{
	input_file <- args[1]
	output_dir <- args[2]
}

print(paste("Using", input_file, "as input, and", output_dir, "as output directory."))

# Read in data
print( paste( "Reading data from", input_file))


print("Exiting harmonize.R")
