library(raster)
library(car)

#####  Function definitions

# biomass estimation function
Biomass_estimation <- function(chm, data) {
    # Change NA to 0
    chm[is.na(chm)] <- 0

    # make an aggregated raster with the max height, 90th percentile, and 80th
    # percentile for every 133 pixels given the spatial resolution
    maxheightrast <- aggregate(chm, fact=133, fun=function(i, na.rm)

    # make a maximum height raster to use for extent later
    quantile(i, probs=1, na.rm=na.rm))

    # create dataframes
    percent100 <- as.data.frame(maxheightrast)
    percent90  <- as.data.frame(aggregate(chm, fact=133, fun=function(i, na.rm)
        quantile(i, probs=0.90, na.rm=na.rm)))
    percent80  <- as.data.frame(aggregate(chm, fact=133, fun=function(i, na.rm)
        quantile(i, probs=0.80, na.rm=na.rm)))

    # Create the model
    powerlaw <- lm(Biomass ~ Height_Max + Height_80th + Height_90th,data=data)

    # Combine the dataframes and name variables
    rastdataframei <- data.frame(Height_Max=percent100, Height_90th=percent90,
        Height_80th=percent80)
    colnames(rastdataframe)[1] <- "Height_Max"
    colnames(rastdataframe)[2] <- "Height_90th"
    colnames(rastdataframe)[3] <- "Height_80th"

    # apply log transformation
    lograstdataframe <- log(rastdataframe)

    # Change infinity to NA
    is.na(lograstdataframe) <- sapply(lograstdataframe, is.infinite)

    # Change NA to 0
    lograstdataframe[is.na(lograstdataframe)] <- 0

    # Apply model to aggregated rasters
    logbiodata <- predict(powerlaw,lograstdataframe)

    # Convert log(kg) to kg
    biodata <- exp(logbiodata)

    # Get the coordinates of the aggregated rasters
    coord <- coordinates(maxheightrast)

    # Attach the coordinates to a dataframe
    bioraster <- as.data.frame(coord)

    # Attach biomass estimates to the dataframe
    bioraster$Biomass <- biodata

    # Convert first three columns to latitude, longitude, and biomass,
    # respectively
    bioraster <- rasterFromXYZ(bioraster)

    # Get the coordinate reference system of input raster
    rastcrs <- crs(chm)

    # Attach the coordinate reference system from input raster
    crs(bioraster) <- rastcrs

    # Return the result
    return(bioraster)
}

#####  Driver code to run the functions

# Set raster file
rastblast <- raster("320320.tif")

# Set the training data .csv file
Mastersheet <- read.csv('Lidar_Training_Data.csv')

# Apply log transformation and select variables
LogMastersheet <- log(Mastersheet[,c(1, 4, 5, 6)])

# Run Biomass_estimation()
test <- Biomass_estimation(rastblast, LogMastersheet)

# Write the raster file
writeRaster(test, filename = '320320_estimated.tif', bylayer = TRUE,
            format = "GTiff", overwrite = TRUE)

# Create plot to inspect
# plot(test)
