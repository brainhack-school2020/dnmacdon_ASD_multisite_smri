# harmonizeR

This folder contains code used to work out how to use R from within python, to harmonize multi-site sMRI data using the R version of [neuroComBat](https://github.com/jfortin1/ComBatHarmonization).

## Notes
 * The harmonizeR.yml environment description was copied from ../harmonize.yml: it includes the basic dependencies so far used to process this data.
 * Installing rpy2 using conda did not work: there were many pages of dependency conflicts. A web search suggests that this is common using rpy2 with conda, and that pip install tends to work better, That was successful:
```
 conda env create -f harmonizeR.yml
 conda activate harmonizeR
 pip install rpy2
```
 * The above package has been added to the harmonizeR.yml environment file:
```
 conda env export --name harmonizeR > harmonizeR.yml
```
 * Have encountered many issues trying to get a "reproducible" and virtualized R environment set up. May have to do this using Docker, if it is necessary to use R.
 
