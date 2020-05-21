[![](https://img.shields.io/badge/Visit-our%20project%20page-ff69b4)](https://school.brainhackmtl.org/project/template)

# A template for project reports at BrainHack School

Team contributors: David MacDonald, and anyone else who is interested!

## Summary 

# Project definition 

### Background

I am an elementary school teacher, and currently a Master's student in the [CoBRA Lab](http://cobralab.ca) at McGill University, located at the Douglas Mental Health University Institute, where I study autism and brain anatomy, using structural MRI (sMRI). I have been working with a large, multi-site dataset to examine subcortical anatomy in autism. Multi-site MRI datasets can be difficult to work with, as scans are typically acquired on different equipment, using different protocols, by different operators. In addition, different sites may be sampling different populations. This can result in a dataset in which a significant portion of the variance is due to non-biological factors. Up to now, I have been using meta-analytic techniques to combine the data from the different sites. With this project, I would like to learn and apply two other techniques for inter-site data harmonization:
 * Use the open source ComBat library, which was originally intended to mitigate batch effects in genetic studies, but has since been adapted to work with neuroimaging data.
 * Use linear mixed-effect models. 

I would also like to:
 * Use the tools we have been learning about to make my project more transparent, easy to maintain, reproducible, and open to collaboration.
 * If time permits, find a way to compare these three site harmonization techniques systematically.

### Tools 

This project will make use of:
 * git and github for version control, code sharing, project management, and collaboration
 * Python
 * A virtualization technology, either conda or virtual environment, to improve reproducibility
 * Python libraries for data visualization 

### Data 

I will be using subcortical volumes, previously derived from the [ABIDE](http://fcon_1000.projects.nitrc.org/indi/abide/) dataset using the [MAGeT Brain](https://github.com/CobraLab/MAGeTbrain) pipeline.  
 
### Deliverables

At the end of this project, we will have:
 - The current markdown document, completed and revised.
 - A gallery of the student projects at Brainhack 2020.
 - Instructions on the website about how to submit a pull request to the [BrainHack School website](https://github.com/BrainhackMTL/school) in order to add the project description to the website. 

## Results 

### Progress overview

The project was swiftly initiated by P Bellec, based on the existing template created in 2019 by Tristan Glatard and improved by different students. It was really not that hard. Community feedback is expected to lead to rapid further improvements of this first version. 

### Tools I learned during this project

 * **Meta-project** P Bellec learned how to do a meta project for the first time, which is developping a framework while using it at the same time. It felt really weird, but somehow quite fun as well. 
 * **Github workflow-** The successful use of this template approach will demonstrate that it is possible to incorporate dozens of students presentation on a website collaboratively over a few weeks. 
 * **Project content** Through the project reports generated using the template, it is possible to learn about what exactly the brainhack school students are working on. 
 
### Results 

#### Deliverable 1: report template

You are currently reading the report template! I will let you judge whether it is useful or not. If you think there is something that could be improved, please do not hesitate to open an issue [here](https://github.com/brainhack-school2020/project_template/issues) and let us know. 

#### Deliverable 2: project gallery

There is not yet a project gallery, as BHS 2020 is the first edition that will incorporate it on the website. You can still check out the [2019 BHS github organization](https://github.com/mtl-brainhack-school-2019)

##### ECG pupilometry pipeline by Marce Kauffmann 

The repository of this project can be found [here](https://github.com/mtl-brainhack-school-2019/ecg_pupillometry_pipeline_kaufmann). The objective was to create a processing pipeline for ECG and pupillometry data. The motivation behind this task is that Marcel's lab (MIST Lab @ Polytechnique Montreal) was conducting a Human-Robot-Interaction user study. The repo features:
 * a [video introduction](http://www.youtube.com/watch/8ZVCNeX42_A) to the project.
 * a presentation [made in a jupyter notebook](https://github.com/mtl-brainhack-school-2019/ecg_pupillometry_pipeline_kaufmann/blob/master/BrainHackPresentation.ipynb) on the results of the project.
 * Notebooks for all analyses.
 * Detailed requirements files, making it easy for others to replicate the environment of the notebook.
 * An overview of the results in the markdown document.
 
##### Other projects
Here are other good examples of repositories:
- [Learning to manipulate biosignals with python](https://github.com/mtl-brainhack-school-2019/franclespinas-biosignals) by François Lespinasse
- [Run multivariate anaylysis to relate behavioral and electropyhysiological data](https://github.com/mtl-brainhack-school-2019/PLS_PV_Behaviour) by Mike
- [PET pipeline automation and structural MRI exploration](https://github.com/mtl-brainhack-school-2019/rwickens-sMRI-PET) by Rebekah Wickens
- [Working with PSG [EEG] data from Parkinson's patients](https://github.com/mtl-brainhack-school-2019/Soraya-sleep-data-in-PD-patients) by Cryomatrix
- [Exploring Brain Functional Activation in Adolescents Who Attempted Suicide](https://github.com/mtl-brainhack-school-2019/Anthony-Gifuni-repo) by Anthony Gifuni

#### Deliverable 3: Instructions 
 
 To be made available soon. 
 
 
## Conclusion and acknowledgement

The BHS team hope you will find this template helpful in documenting your project. Developping this template was a group effort, and benefitted from the feedback and ideas of all BHS students over the years.
