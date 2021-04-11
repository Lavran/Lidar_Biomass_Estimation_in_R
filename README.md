##Lidar_Biomass_Estimation
This repository contains several R scripts that I have written to estimate forest biomass from lidar point clouds.
###scripts
Creating_Canopy_Height_Models = R script used to create canopy height models from lidar point clouds saved as .las files

Creating_Plot_Polygons = R script that creates plot polygons from the southwest corner of a plot. 

Extracting_Lidar_Predictor_Variables = R script for extracting the pixel distribution of a plot from a canopy height model(CHM). Then calculates various height precentiles and crown geometric volume of a plot.

Model_Comparison_Final = Using the created training data from Extracting_Lidar_Predictor_Variables a multiple linear regression, log-linear, random forest, and support vector regression model via a 10-fold cross-validation were compared to determine the most effective predictive model.

Creating_Biomass_Raster = Creates a biomass estimation raster with 10 meter by X 10 meter cell resolution from a CHM

Biomass_Function = A function used to make a canopy height model (CHM) into a biomass estimation raster with 10 meter by X 10 meter cell size using a log-linear model.
