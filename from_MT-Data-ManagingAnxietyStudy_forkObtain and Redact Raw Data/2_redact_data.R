# ---------------------------------------------------------------------------- #
# Redact Data
# Author: Jeremy W. Eberle
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# Notes ----
# ---------------------------------------------------------------------------- #

# Before running this script, restart R (CTRL+SHIFT+F10 on Windows), set your working 
# directory to the parent folder, and ensure that the raw CSV files for Sets A and B 
# obtained from the Private Component of the Managing Anxiety OSF project 
# (https://osf.io/pvd67/) are in "./data/raw_full/set_a/" and "./data/raw_full/set_b/".
# This script will import raw data from those folders and output certain redacted data 
# files to "./data/redacted/set_a/" and "./data/redacted/set_b/".

# For raw data files that contain potential identifiers, this script redacts the
# relevant columns so that subsequent cleaning can be run on a dataset that can be 
# shared and made public. Rather than changing the structure of the raw data, this 
# script replaces values of the relevant columns with "REDACTED_BY_CLEANING_SCRIPT".

# Scope: This script is based on these two raw datasets (which differ in some ways):
# - (a) A larger set of 26 CSV files as of 2/2/2019 obtained from Sonia Baee on 
# 9/3/2020 (who stated on that date that they represent the latest version of the 
# database on the R34 server and that she obtained them from Claudia Calicho-Mamani)
# - (b) A partial set of 20 CSV files as of 2/2/2019 obtained from Sonia on 1/18/2023

# This script may need updating when applied to other data sources, as there may have
# been changes to the database or newly collected data not accounted for by this script

# ---------------------------------------------------------------------------- #
# Store working directory, install correct R version, load packages ----
# ---------------------------------------------------------------------------- #

# Load custom functions

source("./Redact Raw Data/1_define_functions.R")

# Check correct R version, load groundhog package, and specify groundhog_day

groundhog_day <- version_control()

# No packages loaded

# ---------------------------------------------------------------------------- #
# Import raw data Sets A and B ----
# ---------------------------------------------------------------------------- #

# Obtain names of raw data files

filenames_a <- readLines("./data/raw_full/filenames_set_a.txt")
filenames_b <- readLines("./data/raw_full/filenames_set_b.txt")

# Import data files into named lists

dat_a <- lapply(paste0("./data/raw_full/set_a/", filenames_a), read.csv)
dat_b <- lapply(paste0("./data/raw_full/set_b/", filenames_b), read.csv)

names(dat_a) <- tools::file_path_sans_ext(filenames_a)
names(dat_b) <- tools::file_path_sans_ext(filenames_b)

# Rename data files in lists

names(dat_a) <- sub("_Feb_02_2019", "", names(dat_a))
names(dat_b) <- sub("_02_02_2019",  "", names(dat_b))

# ---------------------------------------------------------------------------- #
# Specify columns to retain ----
# ---------------------------------------------------------------------------- #

# Regarding date-related columns across tables, Bethany Teachman indicated on 
# 1/13/2021 that MindTrails is not subject to HIPAA regulations, so restrictions 
# on disclosing dates of training, dates of test measures, and birth years for 
# any participants over age 89 do not apply

# ---------------------------------------------------------------------------- #
# Identify and manually check character columns in Sets A and B ----
# ---------------------------------------------------------------------------- #

# Define function to list each table's character columns that need to be checked,
# optionally ignoring specified columns

list_char_cols_to_check <- function(dat, ignore_cols = NULL) {
  char_cols_to_check <- lapply(dat, function(df) {
    char_cols <- names(df)[sapply(df, is.character)]
    
    setdiff(char_cols, ignore_cols)
  })
  
  char_cols_to_check <- Filter(length, char_cols_to_check)
}

# Specify character columns to ignore

ignore_cols_a <- c("date", "date_completed", "datetime", "corrected_datetime", "dateSent",
                   "sessionId", "session", "corrected_session", "sessionName", "session_name",
                   "participantRSA")
ignore_cols_b <- c("date", "datetime", "session", "corrected_session", "sessionName")

# List character columns to check

(char_cols_to_check_a <- list_char_cols_to_check(dat_a, ignore_cols_a))
(char_cols_to_check_b <- list_char_cols_to_check(dat_b, ignore_cols_b))

# Manually checked all nonignorable character columns identified in following tables

  # In Set A, only "GiftLogDAO_recovered$orderId" and "ImageryPrime_recovered$situation" 
  # contain potential identifiable info

checked_tbls_a <- names(char_cols_to_check_a)

all(checked_tbls_a == c("AnxietyTriggers_recovered", "CIHS_FIXED", "CIHS_recovered", 
                        "DD_FU_recovered", "Demographic_recovered", "EmailLogDAO_recovered", 
                        "GiftLogDAO_recovered", "ImageryPrime_recovered", 
                        "MentalHealthHxTx_recovered", "MultiUserExperience_recovered", 
                        "ParticipantExportDAO_recovered", "ReturnIntention_recovered", 
                        "TaskLog_final_FIXED", "TrialDAO_recovered", "VisitDAO_recovered"))

  # In Set B, only "ImageryPrime$situation" contains potential identifiable info

checked_tbls_b <- names(char_cols_to_check_b)

all(checked_tbls_b == c("AnxietyTriggers", "CIHS", "DD_FU", "Demographics", 
                        "ImageryPrime", "MentalHealthHxTx", "MultiUserExperience", 
                        "ReturnIntention", "TrialDAO"))

# ---------------------------------------------------------------------------- #
# Redact columns in Sets A and B ----
# ---------------------------------------------------------------------------- #

redaction_text <- "REDACTED_BY_CLEANING_SCRIPT"

# In Set A, redact gift card order ID for security reasons

dat_a$GiftLogDAO_recovered$orderId <- redaction_text

# In Sets A and B, redact descriptions of anxious situation for imagery prime

dat_a$ImageryPrime_recovered$situation <- redaction_text
dat_b$ImageryPrime$situation           <- redaction_text

# ---------------------------------------------------------------------------- #
# List tables in Sets A and B that have been redacted ----
# ---------------------------------------------------------------------------- #

# List all tables that have been redacted by this script so that the redacted
# files can be named appropriately when outputted

redacted_tbls_a <- c("GiftLogDAO_recovered", "ImageryPrime_recovered")
redacted_tbls_b <- "ImageryPrime"

# ---------------------------------------------------------------------------- #
# Export redacted data for Sets A and B ----
# ---------------------------------------------------------------------------- #

# Define function to prepare redacted filenames and run for Sets A and B

prep_redacted_filenames <- function(filenames, dat, redacted_tbls) {
  filenames_sans_ext <- tools::file_path_sans_ext(filenames)
  
  redacted_tbls_idx <- which(names(dat) %in% redacted_tbls)
  
  redacted_filenames <- paste0(filenames_sans_ext[redacted_tbls_idx], "_redacted.csv")
}

redacted_filenames_a <- prep_redacted_filenames(filenames_a, dat_a, redacted_tbls_a)
redacted_filenames_b <- prep_redacted_filenames(filenames_b, dat_b, redacted_tbls_b)

# Define function to write redacted CSV files

write_redacted_data <- function(dat, redacted_tbls, redacted_filenames, path) {
  dat_redacted <- dat[names(dat) %in% redacted_tbls]
  
  for (i in 1:length(dat_redacted)) {
    write.csv(dat_redacted[[i]],
              paste0(path, redacted_filenames[i]),
              row.names = FALSE)
  }
}

# Write redacted files to CSV

redacted_dat_dir_a <- "./data/redacted/set_a/"
redacted_dat_dir_b <- "./data/redacted/set_b/"

dir.create(redacted_dat_dir_a, recursive = TRUE)
dir.create(redacted_dat_dir_b)

write_redacted_data(dat_a, redacted_tbls_a, redacted_filenames_a, redacted_dat_dir_a)
write_redacted_data(dat_b, redacted_tbls_b, redacted_filenames_b, redacted_dat_dir_b)