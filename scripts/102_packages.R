## CRAN packages
extraction_packages <- c("readr")
transformation_packages <- c("stringr", "plyr", "dplyr", "tidyr", "data.table", "data.tree")
modeling_packages <- c("caret", "rpart", "C50", "pROC", "e1071", "Formula", "randomForest",
                       "methods", "mlbench", "party")
visualization_packages <- c("RColorBrewer", "maptools", "classInt", "rgeos",
                            "tabplot", "treemap")

required_packages <- c(extraction_packages, transformation_packages, modeling_packages,
                       visualization_packages)
packagesCRAN(required_packages, update = setMissingVar(var_name = "update_package", value = FALSE))

## Clear Workspace
rm(list = ls())
