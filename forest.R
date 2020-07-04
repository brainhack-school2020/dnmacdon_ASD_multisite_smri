# forest.R
# R script to plot a forest plot, given an input file of means and CIs.

# Ensure required packages are installed
packages_to_check <- c("forestplot")
required_packages <- packages_to_check[!(packages_to_check %in% installed.packages()[,"Package"])]
if(length(required_packages)) install.packages(required_packages)
library(forestplot)

main <- function()
{
	cat("Generating forest plot...\n")
	
	# To do: add command line parsing, so we don't need to hard-code filenames, structure names, etc.
	# Parse command line arguments
	args <- commandArgs(trailingOnly = TRUE)
	if (length(args) < 3)
	{
		cat("ERROR: MUST HAVE THREE COMMAND LINE ARGUMENTS.\n")
		cat(" es_filenames: name of file containing the filenames of effect size measures.\n")
		cat(" es_names: name of file containing the display names for each batch of effect size measures.\n")
		cat(" out_file: name of output file.\n")
	} else
	{
		es_filenames <- args[1]
		es_names <- args[2]
		out_file <- args[3]
	}
	
	# Read input files
	# Read the names of the input files and the display names of each set of data into character vectors
	es_filenames <- readLines(es_filenames)
	es_names <- readLines(es_names)

	# Read the input files, format data for forestplot()
	for (i in (1:length(es_filenames)))
	{
		input <- read.csv(es_filenames[i],stringsAsFactors=FALSE)
		structures <- input[['X']]
		if (!exists('text_table')) text_table <- cbind(structures)
		d_temp <- input[['d']]
		lower_temp <- input[['lower_ci']]
		upper_temp <- input[['upper_ci']]
		if (exists('cohensd')) cohensd <- cbind(cohensd, d=d_temp) else cohensd <- cbind(d=d_temp)
		if (exists('lower_ci')) lower_ci <- cbind(lower_ci, lower_ci=lower_temp) else lower_ci <- cbind(lower_ci=lower_temp)
		if (exists('upper_ci')) upper_ci <- cbind(upper_ci, upper_ci=upper_temp) else upper_ci <- cbind(upper_ci=upper_temp)
		if (exists('text_table')) text_table <- cbind(text_table, d=d_temp) else text_table <- cbind(d=d_temp)
	}

	# Add header rows. Only needed for the titles in the text table, but forestplot() requires that they are all the same
	# dimensions, so we pad the data columns, too.
	text_table <- rbind(c("", es_names), text_table)
	cohensd <- rbind(rep(NA,3), cohensd)
	lower_ci <- rbind(rep(NA,3), lower_ci)
	upper_ci <- rbind(rep(NA,3), upper_ci)
	
	# Generate and save forest plot
	png(out_file, width=1024, height=320)
	forestplot(text_table,
		   is.summary = c(TRUE, rep(FALSE,6)),		# Bold title rows 
		   mean = cohensd, 
		   lower = lower_ci, 
		   upper = upper_ci, 
		   fn.ci_norm = c(fpDrawNormalCI, fpDrawCircleCI, fpDrawDiamondCI),	# Different shapes for d from each model
		   boxsize = 0.25,
		   line.margin = unit(.1, "cm"),
#		   lineheight = unit(1.5, "cm"),
		   hrzl_lines = TRUE,
		   ci.vertices = TRUE,
		   col=fpColors(box=c("blue", "darkred", "darkgreen")),
		   legend=es_names, 
		   xlab="Cohen's d ASD vs. HC",
		   title="Effect Size Measures of ASD Diagnosis on Subcortical Volume")
	dev.off()

	cat(paste("... forest plot complete, saved in", 'forest_plot.png', '\n'))
}

main()
