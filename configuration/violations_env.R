###############################################################################
# Sets common environment variables.
###############################################################################

# a full path working directory location to mitigate R Markdown (Knitr) issues
# that arise from its failure to use the same working directory as RStudio
#
# -> Replace with the full path to your working directory
violations_dir <- 
  "/Users/joelwells/Documents/code/ckc/Property-Violations-Settlement/"

get_violations_dir <- function() {
  violations_dir
}
