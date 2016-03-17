###############################################################################
# Reads in violations data and does some basic cleanup and data prep.
#
# This routine encapsulates the loading of core violations data
# so that it is consistent across scripts and can be changed, when
# necessary, in one location. 
#
#    Data source - assumed to be a .csv file named "Property_Violations.csv"
#    located in the project's /data directory. Can easily be modified to pull
#    data from another source as the project evolves.
#
#    Dates are converted using the lubridate package
#
#    Ordinance # is cleaned up by removing universal "C. O." suffix
#
#    Ordinance Titles - this column, consisting of an ordinance number combined
#    with descriptive text, is added to the violations data
#
#    Latitude, Longitude - these columns are created by extracting data from
#    the Code.Violation.Location column
###############################################################################
library(dplyr)
library(lubridate)
library(zoo)
library(stringr)
library(tidyr)

# read in the code violations data
options(stringsAsFactors = FALSE)
column_classes = c(
  #Property.Violation.ID
  "character",
  #Case.ID
  "character",
  #Status
  "character",
  #Case.Opened.Date
  "character",
  #Case.Closed.Date
  "character",
  #Days.Open
  "integer",
  #Violation.Code
  "character",
  #Violation.Description
  "character",
  #Ordinance.Number
  "character",
  #Ordinance.Chapter
  "character",
  #Violation.Entry.Date
  "character",
  #Address
  "character",
  #County
  "character",
  #State
  "character",
  #Zip.Code
  "character",
  #KIVA.PIN
  "integer",
  #Council.District
  "character",
  #Police.Patrol.Area
  "character",
  #Inspection.Area
  "character",
  #Neighborhood
  "character",
  #Code.Violation.Location
  "character" 
)
# negotiate issue with RMarkdown working directory being different than console/global enviroment for RStudio
violations <-
  read.csv(get_violations_path("data/Property_Violations.csv"), colClasses = column_classes)

# convert dates using lubridate
violations$Case.Opened.Date = mdy(violations$Case.Opened.Date)
violations$Case.Closed.Date = mdy(violations$Case.Closed.Date)
violations$Violation.Entry.Date = mdy(violations$Violation.Entry.Date)

# clean up Ordinance.Number
violations$Ordinance.Number <-
  gsub(" C.O.", "", violations$Ordinance.Number)

# create a regular expression to pull coordinates from location
reg_coordinates <-
  gregexpr("(?<=\\()[^\\)]*(?=\\))",
           violations$Code.Violation.Location,
           perl = TRUE)
coordinates <-
  regmatches(violations$Code.Violation.Location, reg_coordinates)
violations$Latitude <-
  as.numeric(str_split_fixed(coordinates, ", ", 2)[, 1])
violations$Longitude <-
  as.numeric(str_split_fixed(coordinates, ", ", 2)[, 2])

# KC Ordinance Titles
ordinance_titles <- read.csv(get_violations_path("data/ordinance_titles.csv"), stringsAsFactors = FALSE)
violations <- violations %>%
  left_join(ordinance_titles, by = 'Ordinance.Number')
# clean up by removing the temporary dataset
rm(ordinance_titles)

violations$Ordinance.Title <-
  ifelse(
    is.na(violations$Ordinance.Title),
    violations$Ordinance.Number,
    violations$Ordinance.Title
  )


