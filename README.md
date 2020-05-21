[![](https://img.shields.io/badge/Visit-our%20project%20page-ff69b4)](https://school.brainhackmtl.org/project/template)

# Harmonizing Multi-Site Structural MRI Data Using ComBat

Team contributors: David MacDonald, and anyone else who is interested!

## Summary 
This project involves using [ComBat](https://github.com/jfortin1/ComBatHarmonization), an open-source library for multi-site data harmonization, to remove site effects from subcortical volumetric data derived from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset. If time permits, I would also like to explore systematic ways of comparing different site harmonization approaches. 

# Project definition 

### Background

I am an elementary school teacher, and currently a Master's student in the [CoBRA Lab](http://cobralab.ca) at McGill University, located at the Douglas Mental Health University Institute, where I study autism and brain anatomy, using structural MRI (sMRI). I have been working with a large, multi-site dataset to examine subcortical anatomy in autism. Multi-site MRI datasets can be difficult to work with, as scans are typically acquired on different equipment, using different protocols, by different operators. In addition, different sites may be sampling different populations. This can result in a dataset in which a significant portion of the variance is due to non-biological factors. Up to now, I have been using meta-analytic techniques to combine the data from the different sites. 

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
     * Analysis code in Jupyter notebooks and the subcortical volume data to be processed
     * All visualizations for the linear mixed-models and ComBat harmonization implementations
     * Virtual environment requirements.txt file, or conda environment.yaml file
     * README.md file summarizing the background methodology, and results
     * Link to final presentation slides

## Results 

### Progress overview

Coming soon...

### Tools I will learn during this project

* git and github, particularly the features for collaboration, including the issue reporting system
* Statistical analysis using python, particularly linear mixed effect models
* Data visualization libraries in python
* Virtualization
* ComBat for site harmonization
 
### Results 
Coming soon...

#### Deliverable 1: Coming Soon


#### Deliverable 2: Coming Soon


#### Deliverable 3: Coming Soon 
 
 
 
## Conclusion and acknowledgement

