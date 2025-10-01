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
# This script will import raw data from those folders, output certain redacted data 
# files to "./data/redacted/set_a/" and "./data/redacted/set_b/", and copy unredacted
# files to "./data/raw_partial/set_a/" and "./data/raw_partial/set_b/".

# For raw data files that contain potential identifiers, this script redacts the
# relevant columns so that subsequent cleaning can be run on datasets that can be 
# shared and made public. Rather than changing the structure of the raw data, this 
# script replaces values of the relevant columns with "REDACTED_BY_CLEANING_SCRIPT".

# This script may need updating when applied to other data sources, as there may have
# been changes to the database or newly collected data not accounted for by this script

# ---------------------------------------------------------------------------- #
# Store working directory, install correct R version, load packages ----
# ---------------------------------------------------------------------------- #

# Load custom functions

source("./code/1_define_functions.R")

# Check correct R version, load groundhog package, and specify groundhog_day

groundhog_day <- version_control()

# No packages loaded

# ---------------------------------------------------------------------------- #
# Specify whether this is the first run of this script ----
# ---------------------------------------------------------------------------- #

# In the first run of this script, "GiftLogDAO_recovered_Feb_02_2019.csv" (i.e., 
# the raw, unredacted file) was imported, and the script replaced its "orderId"
# column's values with "REDACTED_BY_CLEANING_SCRIPT" and outputted the redacted file
# "GiftLogDAO_recovered_Feb_02_2019_redacted.csv" that is on the Private Component.
# The script did so by setting "first_run" to TRUE below. When running this script 
# on files already on the Private Component, "first_run" should be set to FALSE.

first_run <- FALSE

# ---------------------------------------------------------------------------- #
# Import raw data Sets A and B ----
# ---------------------------------------------------------------------------- #

# Get filenames to import for Sets A and B

filenames_a <- get_filenames_a(first_run = first_run)
filenames_b <- get_filenames_b()

# Import data files into named lists

raw_full_dat_dir_a <- "./data/raw_full/set_a/"
raw_full_dat_dir_b <- "./data/raw_full/set_b/"

dat_a <- lapply(paste0(raw_full_dat_dir_a, filenames_a), read.csv)
dat_b <- lapply(paste0(raw_full_dat_dir_b, filenames_b), read.csv)

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

  # In Set A, only "GiftLogDAO_recovered$orderId" (on first run of this script) and 
  # "ImageryPrime_recovered$situation" contain potential identifiable info

checked_tbls_a <- names(char_cols_to_check_a)

gift_log_tbl <- ifelse(first_run == TRUE, "GiftLogDAO_recovered", "GiftLogDAO_recovered_redacted")

all(checked_tbls_a == c("AnxietyTriggers_recovered", "CIHS_FIXED", "CIHS_recovered", 
                        "DD_FU_recovered", "Demographic_recovered", "EmailLogDAO_recovered", 
                        gift_log_tbl, "ImageryPrime_recovered", 
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

# In Set A, redact gift card order ID for security reasons (on first run of this script)

if (first_run == TRUE) {
  dat_a$GiftLogDAO_recovered$orderId <- redaction_text
} else {
  all(dat_a$GiftLogDAO_recovered_redacted$orderId == redaction_text)
}

# In Sets A and B, redact descriptions of anxious situation for imagery prime

dat_a$ImageryPrime_recovered$situation <- redaction_text
dat_b$ImageryPrime$situation           <- redaction_text

# ---------------------------------------------------------------------------- #
# List tables in Sets A and B that have been redacted ----
# ---------------------------------------------------------------------------- #

# List all tables that have been redacted by this script to date so that the 
# redacted files can be named appropriately when outputted and that the other, 
# unredacted raw files can be written to the "raw_partial" folder below

if (first_run == TRUE) {
  redacted_tbls_a <- c("GiftLogDAO_recovered", "ImageryPrime_recovered")
} else {
  redacted_tbls_a <- c("GiftLogDAO_recovered_redacted", "ImageryPrime_recovered")
}

redacted_tbls_b <- "ImageryPrime"

# ---------------------------------------------------------------------------- #
# Export redacted data to "redacted/" for Sets A and B ----
# ---------------------------------------------------------------------------- #

# Define function to prepare redacted filenames and run for Sets A and B

prep_redacted_filenames <- function(filenames, dat, redacted_tbls, first_run) {
  redacted_tbls_idx <- which(names(dat) %in% redacted_tbls)
  
  # Only append "_redacted" to gift log filename on first run
  
  if (first_run == FALSE) {
    gift_log_idx <- which(names(dat) == "GiftLogDAO_recovered_redacted")
    
    redacted_tbls_idx_to_append <- setdiff(redacted_tbls_idx, gift_log_idx)
  } else {
    redacted_tbls_idx_to_append <- redacted_tbls_idx
  }
  
  filenames_sans_ext <- tools::file_path_sans_ext(filenames)
  
  filenames_sans_ext[redacted_tbls_idx_to_append] <- 
    paste0(filenames_sans_ext[redacted_tbls_idx_to_append], "_redacted")
  
  filenames_sans_ext <- paste0(filenames_sans_ext, ".csv")
  
  redacted_filenames <- filenames_sans_ext[redacted_tbls_idx]
}

redacted_filenames_a <- prep_redacted_filenames(filenames_a, dat_a, redacted_tbls_a, first_run)
redacted_filenames_b <- prep_redacted_filenames(filenames_b, dat_b, redacted_tbls_b, first_run)

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

# ---------------------------------------------------------------------------- #
# Copy unredacted data to "raw_partial/" for Sets A and B ----
# ---------------------------------------------------------------------------- #

# Define function to copy unredacted CSV files from "raw_full/" to "raw_partial/"

copy_unredacted_data <- function(dat, filenames, redacted_tbls, raw_full_path, raw_partial_path) {
  unredacted_tbls_idx <- which(!(names(dat) %in% redacted_tbls))
  
  unredacted_filenames <- filenames[unredacted_tbls_idx]
  
  source_paths      <- file.path(raw_full_path,    unredacted_filenames)
  destination_paths <- file.path(raw_partial_path, unredacted_filenames)
  
  file.copy(source_paths, destination_paths, copy.date = TRUE)
}

# Copy unredacted files to "raw_partial/"

raw_partial_dat_dir_a <- "./data/raw_partial/set_a/"
raw_partial_dat_dir_b <- "./data/raw_partial/set_b/"

dir.create(raw_partial_dat_dir_a, recursive = TRUE)
dir.create(raw_partial_dat_dir_b)

copy_unredacted_data(dat_a, filenames_a, redacted_tbls_a, raw_full_dat_dir_a, raw_partial_dat_dir_a)
copy_unredacted_data(dat_b, filenames_b, redacted_tbls_b, raw_full_dat_dir_b, raw_partial_dat_dir_b)