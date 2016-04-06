#!/usr/bin/Rscript
# Purpose:         CS-171 Project
# Date:            2016-04-03
# Author:          tim.hagmann@gmail.com
# Machine:         SAN-NB0044 | Intel i7-3540M @ 3.00GHz | 16.00 GB RAM
# R Version:       R version 3.2.4 -- "Very Secure Dishes"
#
# Notes:           Parallelisation requires the "RevoUtilsMath" package (if
#                  necessary, copy it manually into packrat). On Windows install 
#                  RTools in order to build packages.
################################################################################

## Options
options(scipen = 10)
update_package <- FALSE

## Init Files (always execute, eta: 5s)
source("scripts/101_init.R")                   # Helper functions to load packages
source("scripts/102_packages.R")               # Load all necessary packages

## Visualization
source("scripts/103_treemap.R")                # Constructing a treemap
