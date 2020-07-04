[![](https://img.shields.io/badge/Visit-our%20project%20page-ff69b4)](https://school.brainhackmtl.org/project/template)

# Harmonizing Multi-Site Structural MRI Data Using ComBat

David MacDonald

## Summary 
This project involves using [ComBat](https://github.com/jfortin1/ComBatHarmonization), an open-source library for multi-site data harmonization, to remove site effects from subcortical volumetric data derived from a subset of the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset, and to compare this method to using linear models and mixed effects models without harmonization. 

## Instructions
The sections below provide an introduction to the purpose and structure of the project. To run it yourself, you will need to have Docker and conda installed on your system. To run the pipeline:
1. Download this repository.
2. Run the containerized pipeline:
   1.  

If you wish to build the Docker container that was built in this project:
1. From the docker directory, run bdf.sh. This creates the Dockerfile that contains the specifications for the container.
``` ./bdf.sh ```
2. Build the container:
``` docker build -t harmonizer . ```

If you wish to run the Jupyter notebooks for data exploration:
1. First, run the pipeline. This will create a file of harmonized data that the notebooks need to run.
2. Load the conda environment in which the notebooks will run. From the repository's root directory, run:
``` conda env create -f harmonization.yml ```
3. From the same directory, open the directory in jupyter and select the notebook you wish to open.
``` jupyter notebook ```
4. If necessary, change the directory of the input file.

## Project definition 
### Background
I am a Master's student in the [CoBrA Lab](http://cobralab.ca) at McGill University, located at the Douglas Mental Health University Institute, where I study autism and brain anatomy, using structural MRI (sMRI). I have been working with a large, multi-site dataset to examine subcortical anatomy in autism. Multi-site MRI datasets can be difficult to work with, as scans are typically acquired on different equipment, using different protocols, by different operators. In addition, different sites may be sampling different populations. This can result in a dataset in which a significant portion of the variance is due to non-biological factors. Up to now, I have been using meta-analytic techniques to combine the data from the different sites. 

With this project, I would like to learn and apply two other techniques for inter-site data harmonization:
 * Use the open source ComBat library, which was originally intended to mitigate batch effects in genetic studies, but has since been adapted to work with neuroimaging data.
 * Use linear mixed-effect models. 

I would also like to:
 * Use the tools we have been learning about to make my project more transparent, easy to maintain, reproducible, and open to collaboration.
 * If time permits, find a way to compare these three site harmonization techniques systematically.

### Tools 
This project makes use of:
 * git and github for version control, code sharing, project management, and collaboration
 * Jupyter notebooks
 * Python, including packages for linear regression and mixed models (numpy, statsmodels) and data manipulation (pandas)
 * Conda for virtualization, to improve reproducibility
 * Python libraries for data manipulation (pandas), visualization (matplotlib, Seaborn) and analysis (numpy, statsmodels)
 * [ComBat](https://github.com/Jfortin1/ComBatHarmonization)
 * R, for using ComBat and for some data visualization
 * Docker, to containerize the R- and Python-based pipeline and improve reproducibility

#### ComBat
ComBat is a tool that was developed by ---------------------------- in 2007 for mitigating batch effects in genetic data. FINISH COMBAT EXPLANATION, USE EQUATIONS FROM SLIDE.

### Data 
This project made use of subcortical volumes, previously derived from a subset (n = 359, across three sites and two releases) of the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset using the [MAGeT Brain](https://github.com/CobraLab/MAGeTbrain) pipeline.
 
### Deliverables
 * github repository containing 
    * Analysis code in Jupyter notebooks and the subcortical volume data to be processed 
    * All visualizations for the linear mixed-models and ComBat harmonization implementations 
    * Virtual environment requirements.txt file, or conda environment.yaml file
    * README.md file summarizing the background methodology, and results
    * Final presentation slides

## Progress overview
### Pipeline: Python vs. R
Initially, the project was meant to run entirely in Python. However, two challenges arose. First, the current Python version of neuroCombat is not able to accept data with missing values. Since this data is masked based on segmentation quality (structures whose segementation failed are not used), the data would contain missing values. The R version of neuroCombat does support missing values. Also, R has much more sophisticated packages available to generate forest plots, which are used here to compare the results of the different harmonization methods. Since the language of the Brainhack School is Python, the project was reconceived as a mini-pipeline, using both R and Python.

### Jupyter Notebooks
Jupyter notebooks are used in this project both for data visualization and for presentation (using RISE). Initially, data harmonization was done in Python, and all of the code ran inside of Jupyter notebooks. When QC masking was added, it was necessary to move the ComBat harmonization code to R. For this reason, the Jupyter Notebooks depend on having access to the harmonized data from the pipeline. Several interactive visualizations are provided in the Jupyter notebooks, and conda environments are provided to allow them to be run on other machines without version conflicts.

### Docker Container
I used [neurodocker 0.7.0](https://github.com/ReproNim/neurodocker) to create the dockerfile that was used to build the container. This was fairly straightforward:
 1. The neurodocker command was built in a bash script (bdf.sh).
 2. Ubuntu was used as the base. Packages to install in the first layer were specified with neurodocker's --pkg-manager and --install options. Only those packages that were necessary to run the pipeline were installed here.
 3. R configuration was accomplished by instructing neurodocker to include R base packages, and through an additional script, that called R to install its own packages and manage dependencies. This resulted in a slightly smaller docker image. The script:
    * Used apt-get to install Ubuntu packages that are required by R to build the R packages that will be installed: make, gcc, g++, but NOT required to run the pipeline.
    * Ran an R command to download and install the necessary packages.
    * Used apt-get to remove the temporary Ubuntu packages (make, gcc, g++ and packages that were installed to satisfy their dependencies).
    * Cleared the apt cache.

The docker container was configured to run the pipeline bash script at startup in non-interactive mode. Input and output directories are set on the command line. All code that is run in the Docker container is provided on the command line (i.e. it has not been built in to the container). This is to allow for modifications, for example to use it on a different dataset, while maintaining the same environment. That said, most options are specified on the command line, so it may not be necessary to modify the code.

## Results
 1. Combat harmonization shifted the subcortical volume distributions, typically subtly.
 2. The effects of ASD diagnosis on subcortical volumes were generally non-significant using all three measures.
 3. Cohen's _d_ effect sizes and confidence intervals were similar across all three methods.
 4. Measures of the effect of ASD diagnosis on subcortical volumes were generally non-significant using all three measures.

### Tools Learned
* git and github
* Statistical analysis using python, particularly linear mixed effect models
* Data visualization libraries in python
* Virtualization for python using conda
* ComBat for site harmonization
* Docker for containerization
 
## Deliverables
### Deliverable 1: Github Repository
The [Github repository](https://github.com/brainhack-school2020/dnmacdon_ASD_multisite_smri) contains:
 * Data, generated from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset as described above.
 * Code for the analysis "pipeline" using R and Python
 * Code used to generate the docker container in which the pipeline runs
 * Jupyter notebooks for interactive data visualization
 * This README.md file describing the project
 * Examples of visualizations created using the pipeline and notebooks
 * The slides used for the final Brainhack School presentation

### Deliverable 2: Mini-Pipeline to test ComBat Data Harmonization
The pipeline takes as input a .csv file containing the data: volumes for each subcortical structure for each participant, as well as ASD diagnosis, Age, Sex, Total Brain Volume, Imaging Site, and Quality Control (QC) values describing the quality of each segmentation. Its output consists of two files: a .csv file in which the subcortical volumes and total brain volume have been harmonized using ComBat, and a forest plot showing the effect sizes of diagnosis on subcortical volumes, while controlling for Age, Sex, and Total Brain Volume. The forest plot shows the results of a linear model fit on the harmonized data, a linear model fit on the unharmonized data with Site as a covariate, and a linear mixed-effects model fit on the unharmonized data with Site as a random factor (random intercept).

The pipeline consists of a bash script, which calls several R and Python scripts to harmonize the input data using ComBat, fit linear models to the harmonized and unharmonized data, fit linear mixed effect models with site as a random factor to the unharmonized data, compute effect size measures in all three cases, and display the effect sizes and confidence intervals obtained in a forest plot for comparison. It consists of:
 1. harmonize_cmd.sh: Contains the bash command used to start the pipeline. This script is called on startup by the Docker container. All command-line options are specified here.
 2. harmonize_and_show_effect_sizes.sh: Bash script that manages data flow through the pipeline
 3. harmonize_data_prep.py: Python script to load the data, remove rows with missing values, and mask the dependent variables according to quality control (QC) results
 4. harmonize.R: R script that takes the masked data and performs ComBat harmonization
 5. harmonize_fit_models.py: Python script that fits linear models to both harmonized and unharmonized data, adding site as a covariate to the unharmonized models, and linear mixed effects models on the unharmonized data, with site as a random factor.
 6. forest.R: R script that operates on the effect size values computed in the previous step. Saves a forest plot comparing the three methods on each of the dependent variables.

Note that, although the pipeline is here run non-interactively inside a Docker container, each segment is built in such a way that it can be run independently, and the command line arguments can be specified at runtime.

### Deliverable 3: Jupyter Notebooks
Jupyter notebooks were written to facilitate interactive data exploration. Several interactive plots were created, using seaborn and ipywidgets. These plots allow the user to explore both the harmonized and unharmonized distributions, overlaid with different covariates (such as site and diagnosis). Note that these notebooks require harmonized data from the pipeline, as the Python version of ComBat is not able to work with masked data. 
 
### Deliverable 4: Virtualization
The conda environment file harmonization.yml is included in the repository, allowing the Python environment used in this project to be recreated. Note that the R environment was not virtualized in the same way, necessitating the use of Docker.

### Deliverable 5: Containerization with Docker
The pipeline uses both Python and R. While virtualizing Python environments is readily done with conda, it is more difficult to do so with R. For this reason, the entire environment was constructed in a Docker container in which the pipeline runs. See above for more details.
 
## Improvements
A number of improvements are possible.
 * Using a library such as rpy2 to call R from within Python would eliminate the need for the bash scripting, the complex command-line arguments, and the use of temporary files, which would reduce the apparent complexity of the process.
 * The entire pipeline could be constructed in Python, if the Python version of neuroCombat supported missing values in the data.
 * The entire pipeline could be constructed in R, though the interactive data exploration would suffer.
 * With some minor modifications, vertex-wise analyses could be run using this code. ComBat harmonization may be better suited to vertex-wise data.

## Conclusion and acknowledgement

