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
#    Ordinance Titles - this column, consisting of an ordinance number combined
#    with descriptive text, is added to the violations data
#
#    Latitude, Longitude - these columns are created by extracting the data from
#    the Code.Violation.Location column
###############################################################################
library(dplyr)
library(lubridate)
library(zoo)
library(stringr)
library(tidyr)

# read in the code violations data
options(stringsAsFactors = FALSE)
#  setAs("character","myDate", function(from) as.Date(from, format="%m/%d/%Y") )
#  setClass("myDate")
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
simple_path <- "data/Property_Violations.csv"
data_path <- ifelse(exists('violations_dir'), paste(violations_dir, "/", simple_path, sep = ""), simple_path)
data_path

violations <-
  read.csv(data_path, colClasses = column_classes)
#convert dates using lubridate
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

#KC Ordinance Titles
ordinance_titles <- data.frame(
  Ordinance.Number = c(
    "48-25",
    "48-27",
    "48-28",
    "48-30",
    "48-31",
    "48-32",
    "48-46(c)",
    "48-68 (3)",
    "56-113",
    "56-114",
    "56-132 (B)",
    "56-132",
    "56-133",
    "56-135",
    "56-163",
    "56-189",
    "56-352",
    "56-573",
    "56-93",
    "56-131"
  ),
  Ordinance.Title = c(
    "Trash on public or private property"
    ,
    "Damaged or unlicensed vehicles"
    ,
    "Off-street parking"
    ,
    "Rank weeds"
    ,
    "Open to entry"
    ,
    "Open storage"
    ,
    "Graffiti"
    ,
    "Trash on Public Right of Way"
    ,
    "Accessory structures"
    ,
    "Fences and retaining walls"
    ,
    "Exterior walls - paint"
    ,
    "Exterior walls - structural"
    ,
    "Roofs"
    ,
    "Windows and screens"
    ,
    "Plumbing and electrical system"
    ,
    "Cooking and heating"
    ,
    "Rental regisration"
    ,
    "Vacant registration"
    ,
    "Stairs, porches and handrails"
    ,
    "Foundations and walls"
  )
)

#concat the number and title
ordinance_titles$Ordinance.Title <-
  paste(ordinance_titles$Ordinance.Number,
        ordinance_titles$Ordinance.Title)

violations <- violations %>%
  left_join(ordinance_titles, by = 'Ordinance.Number')

violations$Ordinance.Title <-
  ifelse(
    is.na(violations$Ordinance.Title),
    violations$Ordinance.Number,
    violations$Ordinance.Title
  )

# clean up by removing the temporary dataset
rm(ordinance_titles)
