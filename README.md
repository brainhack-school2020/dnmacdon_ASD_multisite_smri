[![](https://img.shields.io/badge/Visit-our%20project%20page-ff69b4)](https://school.brainhackmtl.org/project/template)

# Harmonizing Multi-Site Structural MRI Data Using ComBat

David MacDonald

## Summary 
This project involves using [ComBat](https://github.com/jfortin1/ComBatHarmonization), an open-source library for multi-site data harmonization, to remove site effects from subcortical volumetric data derived from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset, and to compare this method to using linear models and mixed effects models without harmonization. 

# Project definition 

### Background

I am an elementary school teacher, and currently a Master's student in the [CoBrA Lab](http://cobralab.ca) at McGill University, located at the Douglas Mental Health University Institute, where I study autism and brain anatomy, using structural MRI (sMRI). I have been working with a large, multi-site dataset to examine subcortical anatomy in autism. Multi-site MRI datasets can be difficult to work with, as scans are typically acquired on different equipment, using different protocols, by different operators. In addition, different sites may be sampling different populations. This can result in a dataset in which a significant portion of the variance is due to non-biological factors. Up to now, I have been using meta-analytic techniques to combine the data from the different sites. 

With this project, I would like to learn and apply two other techniques for inter-site data harmonization:
 * Use the open source ComBat library, which was originally intended to mitigate batch effects in genetic studies, but has since been adapted to work with neuroimaging data.
 * Use linear mixed-effect models. 

I would also like to:
 * Use the tools we have been learning about to make my project more transparent, easy to maintain, reproducible, and open to collaboration.
 * If time permits, find a way to compare these three site harmonization techniques systematically.

### Tools 

This project will make use of:
 * git and github for version control, code sharing, project management, and collaboration
 * Jupyter notebooks
 * Python, including packages for linear regression and mixed models (numpy, statsmodels) and data manipulation (pandas)
 * A virtualization technology, either conda or virtual environment, to improve reproducibility
 * Python libraries for data visualization (matplotlib, Seaborn) 
 * [ComBat](https://github.com/Jfortin1/ComBatHarmonization)

### Data 

I will be using subcortical volumes, previously derived from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset using the [MAGeT Brain](https://github.com/CobraLab/MAGeTbrain) pipeline.  
 
### Deliverables

 * github repository containing 
     * Analysis code in Jupyter notebooks and the subcortical volume data to be processed * All visualizations for the linear mixed-models and ComBat harmonization implementations * Virtual environment requirements.txt file, or conda environment.yaml file
     * README.md file summarizing the background methodology, and results
     * Link to final presentation slides


## Progress overview

### Docker Container
I used [neurodocker 0.7.0](https://github.com/ReproNim/neurodocker) to create the dockerfile that was used to build the container. This was fairly straightforward:
 1. The neurodocker command was built in a bash script (bdf.sh).
 2. Ubuntu was used as the base. Packages to install in the first layer were specified with neurodocker's --pkg-manager and --install options. Only those packages that were necessary to run the pipeline were installed here.
 3. Configuring R was slightly more complex. To allow R to manage its own dependencies, it's install.packages() function was used to install necessary packages. However, install.packages() often requires that packages be built from source, meaning that ubuntu packages like make, gcc, and g++ are required, even though they are NOT used to run the pipeline. To reduce bloat, the following method was used to install these packages temporarily during the docker build, without retaining them in the finished docker container. R configuation was handled by a script (R_config.sh) that was COPYd into the docker build using neurodocker's -c switch. Using a script ensured that all of the following commands were executed in building a single layer of the container. The script:
  * Used apt-get to install Ubuntu packages that are required by R to build the R packages that will be installed: make, gcc, g++
  * Ran an R command to download and install the necessary packages.
  * Used apt-get to remove the temporary Ubuntu packages (make, gcc, g++ and packages that were installed to satisfy their dependencies).
  * Cleared the apt cache.

The docker container was configured to run the pipeline bash script at startup in non-interactive mode. Input and output directories are set on the command line.


### Tools Learned

* git and github
* Statistical analysis using python, particularly linear mixed effect models
* Data visualization libraries in python
* Virtualization for python using conda
* ComBat for site harmonization
* Docker for containerization
 
## Results
 1. Combat harmonization shifted the subcortical volume distributions, typically subtly.
 2. The effects of ASD diagnosis on subcortical volumes were generally non-significant using all three measures.
 3. Cohen's _d_ effect sizes and confidence intervals were similar across all three methods.
 4. Measures of the effect of ASD diagnosis on subcortical volumes were generally non-significant using all three measures.

### Deliverables

#### Deliverable 1: Github Repository
The [Github repository](https://github.com/brainhack-school2020/dnmacdon_ASD_multisite_smri) contains:
 * Data, generated from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset as described above.
 * Code for the analysis "pipeline" using R and Python
 * Code used to generate the docker container in which the pipeline runs
 * Jupyter notebooks for interactive data visualization
 * This README.md file describing the project
 * Examples of visualizations created using the pipeline and notebooks
 * The slides used for the final Brainhack School presentation

#### Deliverable 2: Mini-Pipeline to test ComBat Data Harmonization
The pipeline consists of a bash script, which calls several R and Python scripts to harmonize the input data using ComBat, fit linear models to the harmonized and unharmonized data, fit linear mixed effect models with site as a random factor to the unharmonized data, compute effect size measures in all three cases, and display the effect sizes and confidence intervals obtained in a forest plot for comparison. It consists of:
 * harmonize_and_show_effect_sizes.sh: Bash script that manages data flow through the pipeline
 * harmonize_data_prep.py: Python script to load the data, remove rows with missing values, and mask the dependent variables according to quality control (QC) results
 * harmonize.R: R script that takes the masked data and performs ComBat harmonization
 * harmonize_fit_models.py: Python script that fits linear models to both harmonized and unharmonized data, adding site as a covariate to the unharmonized models, and linear mixed effects models on the unharmonized data, with site as a random factor.
 * forest.R: R script that operates on the effect size values computed in the previous step. Saves a forest plot comparing the three methods on each of the dependent variables.

#### Deliverable 3: Jupyter Notebooks
Jupyter notebooks were written to facilitate interactive data exploration. Several interactive plots were created, using seaborn and ipywidgets. These plots allow the user to explore both the harmonized and unharmonized distributions, overlaid with different covariates (such as site and diagnosis). Note that these notebooks require harmonized data from the pipeline, as the Python version of ComBat is not able to work with masked data. 
 
#### Deliverable 4: Virtualization
The conda environment file harmonization.yml is included in the repository, allowing the Python environment used in this project to be recreated. Note that the R environment was not virtualized in the same way, necessitating the use of Docker.

#### Deliverable 5: Containerization with Docker
The pipeline uses both Python and R. While virtualizing Python environments is readily done with conda, it is more difficult to do so with R. For this reason, the entire environment was constructed in a Docker container in which the pipeline runs. See above for more details.
 
## Conclusion and acknowledgement

