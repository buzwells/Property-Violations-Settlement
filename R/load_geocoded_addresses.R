

read_addresses <- function(include_all = FALSE) {
  # read in the code violations data
  column_classes = c(
    #Kiva.Pin
    "integer",
    #County.APN
    "character",
    #Address.Number
    "character",
    #Street
    "character",
    #Street.Type
    "character",
    #Combined.Full.Address
    "character",
    #City
    "character",
    #State
    "character",
    #Longitude
    "double",
    #Latitude
    "double",
    #AFFGEOID
    "character",
    #GEOID
    "character"
  )
  # negotiate issue with RMarkdown working directory being different than console/global enviroment for RStudio
  addresses <-
    read.csv(get_violations_path("data/address_blockgroup_master.csv"), colClasses = column_classes)
  # clean up temporary objects
  rm(column_classes)
  
  # match the casing of the violations dataset
  names(addresses)[names(addresses) == 'Kiva.Pin'] <- 'KIVA.PIN'
  # match the naming in 
  
  if(include_all) {
    addresses <- addresses
  } else {
    addresses <- addresses %>% select(KIVA.PIN, GEOID) 
  }
  addresses
}