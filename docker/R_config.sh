#!/bin/bash

apt-get update
apt-get -y upgrade

# install compiler-related packages required by R to build its packages
apt-get -y --no-install-recommends install make gcc g++ 

# Install required R packages
R -e "install.packages(c(\"devtools\",\"forestplot\"),repos=\"http://cloud.r-project.org\")"

# Install neuroCombat
R -e "library(devtools);install_github(\"jfortin1/CombatHarmonization/R/neuroCombat\")"

# Remove the compiler packages, which are no longer needed
apt-get -y remove make gcc g++ 

# Clean up
apt-get -y autoremove
apt-get -y autoclean
