###############################################################################
# Sets common environment variables.
###############################################################################

### FUNCTIONS
get_violations_path <- function(filename) {
  sprintf("%s%s%s", violations_dir, "/", filename)
}

load_common_libs <- function() {
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(lubridate)
  library(stringr)
}

### MAIN
temp_path <- 'violations_dir.rdf'

# a full path working directory location to mitigate R Markdown (Knitr) issues
# that arise from its failure to use the same working directory as RStudio
if(file.exists(temp_path)) {
  load(temp_path)
} else {
  violations_dir <- getwd()
  # dir is saved, so that it can be found by RStudio
  save(violations_dir, file = temp_path)
  # dir is saved, so that it can be found by Knitr (for RMarkdown)
  save(violations_dir, file = sprintf("%s%s", "docs/", temp_path))
}

rm(temp_path)


