#### Function ####
## Load Packages ##
#
# Specify the packages in a vector 'x'.
# Pass vector to the function
# Function checks the library for the package
# Function loads package, or installs if missing

load.packages <- function(x) {
	for (foo in x) {
	if (!require(foo, character.only = T)) {install.packages(foo)}
	  library(foo, character.only = T) #for data management
	}
}

#### Examples of implementation with common  packages
# Specify and load the list of packages
# load.packages(packages <- c(
#   ## Data manipulation
#   "data.table", #for data processing
#   "stringr", #for easy string manipulation
#   "plyr", #for summarising data
#
#   ## Curve fitting
#   "lme4", #for mixed linear models
#   "minpack.lm", #for non-linear model fitting
#   "bbmle", #for maximum likelihood estimates
#   "optimx", #for optimisation algorithms
#
#   ## Packages for Plotting ##
#   "ggplot2", #for plotting data
#   "gridExtra", #to create a grid of ggplots
#   "cowplot", #to also create grids of ggplots
#   "ggpubr", #publication ready themes
#   "ggthemes", #more publication ready themes
#   "svglite", #to export as svg
#   "Cairo", #to export eps
#   "extrafont" #load the fonts package for graphing
# ))

