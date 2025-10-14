# ---------------------------------------------------------------------------- #
# Import Clean Data
# Author: Jeremy W. Eberle
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# Notes ----
# ---------------------------------------------------------------------------- #

# Before running script, restart R (CTRL+SHIFT+F10 on Windows) and set working 
# directory to parent folder. This script will import intermediate clean data from 
# "./data/intermediate_clean/" (outputted by "3_clean_data.R") and show how to convert 
# POSIXct date columns back to POSIXct data types with correct time zones. It outputs
# no files but serves as a starting point for further cleaning/analysis.

# ---------------------------------------------------------------------------- #
# Check correct R version and load packages ----
# ---------------------------------------------------------------------------- #

# Load custom functions

source("./code/1_define_functions.R")

# Check correct R version, load groundhog package, and specify groundhog_day

groundhog_day <- version_control()

# No packages loaded

# ---------------------------------------------------------------------------- #
# Import intermediate clean data tables and their POSIXct time zones ----
# ---------------------------------------------------------------------------- #

# Import intermediate clean data tables into named list

int_cln_tbls_path      <- "./data/intermediate_clean/tables/"
int_cln_tbls_filenames <- c("bbsiq.csv", "credibility.csv", "dass21_as.csv", "dass21_ds.csv", 
                            "demographic.csv", "oa.csv", "participant.csv", "rr.csv")
int_cln_tbls_paths     <- paste0(int_cln_tbls_path, int_cln_tbls_filenames)

int_cln_tbls        <- lapply(int_cln_tbls_paths, read.csv)
names(int_cln_tbls) <- tools::file_path_sans_ext(int_cln_tbls_filenames)

# Import time zones of tables' "_as_POSIXct" columns

POSIXct_time_zones <- read.csv("./data/intermediate_clean/POSIXct_time_zones.csv")

# ---------------------------------------------------------------------------- #
# Convert POSIXct columns to POSIXct with correct time zones ----
# ---------------------------------------------------------------------------- #

# Define function to convert a table's "_as_POSIXct" columns to POSIXct with time 
# zones specified in "POSIXct_time_zones"

convert_POSIXct_cols <- function(table, table_name, POSIXct_time_zones) {
  POSIXct_cols <- names(table)[grepl("_as_POSIXct", names(table))]
  
  for (col in POSIXct_cols) {
    tzone <- POSIXct_time_zones$tzone[POSIXct_time_zones$table == table_name &
                                        POSIXct_time_zones$col == col]
    
    table[[col]] <- as.POSIXct(table[[col]], tzone)
    
    cat("Converted", table_name, "column", col, "to POSIXct with time zone", tzone, "\n")
  }
  
  return(table)
}

# Run function for all tables in list

for (i in 1:length(int_cln_tbls)) {
  table_name <- names(int_cln_tbls)[i]
  table <- int_cln_tbls[[i]]
  
  table <- convert_POSIXct_cols(table, table_name, POSIXct_time_zones)
  
  int_cln_tbls[[i]] <- table
}