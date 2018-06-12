## Basic script to import data and plot the initial results
# Created by Alex Hayes
# 12 June 2018

## LOAD THE RELEVENT PACKAGES
# Load the load.packages function
source("./function_load.packages.r")

# Load the packages we might want
# if the package doesn't exist, it should download and install
# note: some packages may be pesky and require you to restart your session before they will install
load.packages(packages <- c(
  ## Data manipulation
  "data.table", #for data processing
  "stringr", #for easy string manipulation
  "plyr", #for summarising data

  ## Curve fitting
  "lme4", #for mixed linear models
  "minpack.lm", #for non-linear model fitting
  "bbmle", #for maximum likelihood estimates
  "optimx", #for optimisation algorithms

  ## Packages for Plotting ##
  "ggplot2", #for plotting data
  "gridExtra", #to create a grid of ggplots
  "cowplot", #to also create grids of ggplots
  "ggpubr", #publication ready themes
  "ggthemes", #more publication ready themes
  "svglite", #to export as svg
  "Cairo", #to export eps
  "extrafont" #load the fonts package for graphing
))


# DATA IMPORT -------------------------------------------------------------
## FIND ALL THE CSV FILES IN THE DATA PATH
files = dir(
  path = 'DATA',pattern = '.csv',full.names = T,recursive = T
)

## IMPORT DATA AND ATTACH THE IDENTIFYING INFORMATION
# Create a blank list to store the data
data <- list()
for (i in seq_along(files)) {
  # Read the CSV
  tmp = fread(files[i], skip=3) # skip the specimen id and specimen notes

  # Remove the first row which contains only the units and overwrite the table
  tmp <- tmp[-1, ]

  # Rename the Compressive stress column to just stress - easier to write later
  # I noticed that some files refer to compressove stress so I renamed the columns in the CSV
  setnames(tmp, "True stress", "Stress")

  # Convert the columns to numbers
  # note that I formatted them as a list so each entry is clearer
  tmp[, c("Time",
          "Extension",
          "Load",
          "Stress") := list(
    as.numeric(Time),
    as.numeric(Extension),
    as.numeric(Load),
    as.numeric(Stress))]

  # Label the data with the unique file number
  tmp[, File := files[i]]

  # Re-read the file but keep only the first two lines
  header <- fread(files[i], nrows=2, header = F)

  # Store the specimen label in the table for referencing later
  tmp[, label := header[1,2]]

  # Store in the list for later
  data[[i]] = tmp
}

# Convert the data list to a data.table
DATA <- rbindlist(data)

# Firstly, let's zero our extension and call it "displacement"
DATA[, "Displacement" := abs(Extension - Extension[1]), by="File"] #for each unique file, take the starting extension and subtract it to "zero" the extension

## Next let's plot the data
ggplot(DATA[seq(1,.N,3),]) + #Plot every 3rd point to make it faster
  aes(x = Time, y = Displacement, colour = File) + #colour each file
  geom_line() + #plot as a line
  theme(legend.position = "none") #hide the legend since our file names are long

## Zoom in on the first few seconds to see what is happening
ggplot(DATA[]) +
  aes(x = Time, y = Displacement, colour = File) + #colour each file
  geom_line() + #plot as a line
  xlim(-1,5) +
  theme(legend.position = "none") #hide the legend since our file names are long
