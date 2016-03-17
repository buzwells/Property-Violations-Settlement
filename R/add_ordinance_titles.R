###############################################################################
# Adds an Ordinance.Titles column to violations data. The column is a
# concatenation of ordinance number and some descriptive text describing
# the ordinance. 
###############################################################################

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