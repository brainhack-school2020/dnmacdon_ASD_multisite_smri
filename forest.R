# forest.R
# R script to plot a forest plot, given an input file of means and CIs.

# Ensure required packages are installed
packages_to_check <- c("forestplot")
required_packages <- packages_to_check[!(packages_to_check %in% installed.packages()[,"Package"])]
if(length(required_packages)) install.packages(required_packages)
library(forestplot)

main <- function()
{
	cat("La la la, making forest plots.")
	hold_basic()

	# Parse command line arguments

	# Read input files

	# Generate and save forest plot
	# For now with made-up data, to figure out the formats I need, and see the result.
}

hold_basic <- function()
{
	# Cochrane data from the 'rmeta'-package
	cochrane_from_rmeta <-
  	structure(list(
    		mean  = c(NA, NA, 0.578, 0.165, 0.246, 0.700, 0.348, 0.139, 1.017, NA, 0.531),
    		lower = c(NA, NA, 0.372, 0.018, 0.072, 0.333, 0.083, 0.016, 0.365, NA, 0.386),
    		upper = c(NA, NA, 0.898, 1.517, 0.833, 1.474, 1.455, 1.209, 2.831, NA, 0.731)),
    		.Names = c("mean", "lower", "upper"),
    		row.names = c(NA, -11L),
    		class = "data.frame")

	text_table<-cbind(c("", "Structure", "L. Striatum", "R. Striatum", "L. Globus Pallidus", "R. Globus Pallidus", "L. Thalamus",
			 "R. Thalamus"),
			 c("L.M. Unharm.", "Cohen's d", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6"),
			 c("L. Mixed. M.", "Cohen's d", "0,6", "0.1", "0.2", "0.3", "0.4", "0.5"),
			 c("Combat", "Cohen's d", "0.1", "0.3", "0.2", "0.3", "0.5", "0.6"))

	print(text_table)

	mean <- cbind(c(NA, NA, .1, .2, .3, .4, .5, .6),
			c(NA, NA, .6, .1, .2, .3, .4, .5),
			c(NA, NA, .1, .3, .2, .3, .5, .6))
	print(mean)

	lower <- cbind(c(NA, NA, -.2, -.3, -.4, -.5, -.6, .1),
			c(NA, NA, -.06, -.01, -.02, -.3, .04, .05),
			c(NA, NA, .01, .03, .02, .03, .05, .06))
	upper <- cbind(c(NA, NA, .4, .5, .6, .7, .8, .9),
			c(NA, NA, .4, .5, .6, .7, .8, .9),
			c(NA, NA, .4, .5, .6, .7, .8, .9))

	png('test.png', width=1024, height=320)
	forestplot(text_table,
		   is.summary = c(TRUE, TRUE, rep(FALSE,6)),		# Bold title rows 
		   mean = mean, 
		   lower = lower, 
		   upper = upper, 
		   fn.ci_norm = c(fpDrawNormalCI, fpDrawCircleCI, fpDrawDiamondCI),	# Different shapes for d from each model
		   boxsize = 0.25,
		   line.margin = unit(.1, "cm"),
#		   lineheight = unit(1.5, "cm"),
		   hrzl_lines = TRUE,
		   ci.vertices = TRUE,
		   col=fpColors(box=c("blue", "darkred", "darkgreen")),
		   legend=c("Unharmonized, Linear Model", "Linear Mixed Model", "Combat Harmonized, Linear Model"), 
		   xlab="Cohen's d ASD vs. HC",
		   title="Effect Size Measures of ASD Diagnosis on Subcortical Volume")
	dev.off()
#	forestplot(tabletext,
#           cochrane_from_rmeta,new_page = TRUE,
#           is.summary=c(TRUE,TRUE,rep(FALSE,8),TRUE),
#           clip=c(0.1,2.5),
#           xlog=TRUE,
#           col=fpColors(box="royalblue",line="darkblue", summary="royalblue"))
}

hold_multiline <- function()
{
	tabletext <- tabletext[,1]
	forestplot(tabletext,
           mean = cbind(HRQoL$Sweden[, "coef"], HRQoL$Denmark[, "coef"]),
           lower = cbind(HRQoL$Sweden[, "lower"], HRQoL$Denmark[, "lower"]),
           upper = cbind(HRQoL$Sweden[, "upper"], HRQoL$Denmark[, "upper"]),
           clip =c(-.1, 0.075),
           col=fpColors(box=c("blue", "darkred")),
           xlab="EQ-5D index")
}

main()
