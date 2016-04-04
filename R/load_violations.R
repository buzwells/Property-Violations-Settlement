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


rdata_violations <- normalizePath(get_violations_path("output/violations_data.rdf"), mustWork = FALSE)


### FUNCTIONS

read_violations <- function() {
  # read in the code violations data
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
  # clean up temporary objects
  rm(column_classes)
  
  # strip unnecessary suffix from Ordinance.Number
  violations$Ordinance.Number <-
    gsub(" C.O.", "", violations$Ordinance.Number)
  violations
}

# convert dates using lubridate
convert_violation_dates <- function(d) {
  d$Case.Opened.Date = mdy(d$Case.Opened.Date)
  d$Case.Closed.Date = mdy(d$Case.Closed.Date)
  d$Violation.Entry.Date = mdy(d$Violation.Entry.Date)
  
  d
}

extract_violation_coordinates <- function(d) {
  # create a regular expression to pull coordinates from location
  reg_coordinates <-
    gregexpr("(?<=\\()[^\\)]*(?=\\))",
             d$Code.Violation.Location,
             perl = TRUE)
  coordinates <-
    regmatches(d$Code.Violation.Location, reg_coordinates)
  d$Latitude <-
    as.numeric(str_split_fixed(coordinates, ", ", 2)[, 1])
  d$Longitude <-
    as.numeric(str_split_fixed(coordinates, ", ", 2)[, 2])
  # clean up by removing temporary objects
  rm(reg_coordinates)
  rm(coordinates)
  d
}

add_ordinance_titles <- function(d) {
  # KC Ordinance Titles
  ordinance_titles <- read.csv(get_violations_path("data/ordinance_titles.csv"), stringsAsFactors = FALSE)
  d <- d %>%
    left_join(ordinance_titles, by = 'Ordinance.Number')
  # clean up by removing the temporary dataset
  rm(ordinance_titles)
  
  # default to ordinance number for ordinances without a title
  d$Ordinance.Title <-
    ifelse(
      is.na(d$Ordinance.Title),
      d$Ordinance.Number,
      d$Ordinance.Title
    )
  d
}

clear_violations_data <- function() {
  if(file.exists(rdata_violations)) {
    file.remove(rdata_violations)
  }
}

### MAIN

if(!exists('violations')) {
  if(file.exists(rdata_violations)) {
    load(rdata_violations)
  } else {
    violations <- read_violations()
    violations <- violations %>% 
      convert_violation_dates() %>% 
      extract_violation_coordinates() %>% 
      add_ordinance_titles()
    
    save(violations, file = rdata_violations)
  }
}