# Obtain and Redact Raw Data

README Author: [Jeremy W. Eberle](https://github.com/jwe4ec)

## Data on Open Science Framework

Two sets of raw data ([Sets A and B](#sets-a-and-b)) from the Managing Anxiety (R34) SQL database 
are stored in the [MindTrails Managing Anxiety Study](https://osf.io/pvd67/) project 
on the Open Science Framework (OSF). The project has two components, with different permissions:
a [Private Component](https://osf.io/5sn2x/) and a [Public Component](https://osf.io/2x3jq/).

### Sets A and B

**Set A** is a larger set of 26 CSV files with data up to 2/2/2019 obtained from Sonia 
Baee on 9/3/2020 (who stated on that date that they represent the latest version of the 
database on the R34 server and that she obtained them from Claudia Calicho-Mamani)

**Set B** is a partial set of 20 CSV files with data up to 2/2/2019 obtained from Sonia 
Baee on 1/18/2023

The two datasets differ in some ways. ***TODO: Describe the differences.***





### Private Component

The [Private Component](https://osf.io/5sn2x/) has a ZIP file with the raw 
data for Sets A and B. The folder structure of the ZIP file is below.

```
.
└── data/
    ├── raw_full/    # All raw files
    |   ├── set_a/   #   26 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019.csv")
    |   └── set_b/   #   20 CSV files (e.g., "ImageryPrime_02_02_2019.csv")
    └── redacted/    # Redacted files
        ├── set_a/   #   2 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019_redacted.csv")
        └── set_b/   #   1 CSV files (e.g., "ImageryPrime_02_02_2019_redacted.csv")
```

To request access to files on this component, contact Bethany Teachman ([bteachman@bvirginia.edu](mailto:bteachman@bvirginia.edu)).

### Public Component

The [Public Component](https://osf.io/2x3jq/) contains a partial set of raw data 
files (i.e., those that did not need redaction) for Sets A and B and redacted files 
(from `2_redact_data.R`) for Sets A and B. The structure of the ZIP file is below.

Note: The `GiftLog` table (in Set A) and `ImageryPrime` table (in Sets A and B) in 
the `raw_full` folder of the [Private Component](#private-component) that are not 
in the `raw_partial` folder of this [Public Component](https://osf.io/2x3jq/) have
columns that may have identifiers. In the [Public Component](https://osf.io/2x3jq/), 
redacted versions of these tables are in `redacted`.

```
.
├── data/                    
|   ├── raw_partial/   # Raw files that did not need redaction
|   |   ├── set_a/     #   24 CSV files (e.g., "DASS21_AS_recovered_Feb_02_2019.csv")
|   |   └── set_b/     #   19 CSV files (e.g., "DASS21_AS_02_02_2019.csv")
|   └── redacted/      # Redacted files
|       ├── set_a/     #   2 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019_redacted.csv")
|       └── set_b/     #   1 CSV file (e.g., "ImageryPrime_02_02_2019_redacted.csv")
└── materials/
    ├── appendices/    # Appendices
    └── codebooks/     # Codebooks
```

## Redaction Scripts: Setup and File Relations

The scripts in the `Obtain and Redact Raw Data` folder of this repository import 
the full raw data files for Sets A and B and redact certain files.

If you have access to the full raw data (from the [Private Component](#private-component)), 
you can reproduce the redaction. Create a parent folder (with any desired name, indicated 
by `.` below) with two subfolders: `data` and `Obtain and Redact Raw Data`. The working 
directory must be set to the parent folder to import/export data via relative file paths.

Put the raw data files in subfolders of `data` called `raw_full/set_a/` and `raw_full/set_b/`.
When `2_redact_data.R` is run, it will create the `redacted` folder and files therein.

```
.                                 # Parent folder (i.e., working directory)
├── data/                         #   Data subfolder
|   ├── raw_full/                 #     Folder with files from Private Component
|   |   ├── set_a/                #       26 CSV files
|   |   └── set_b/                #       20 CSV files
|   └── (redacted/)               #     Folder with files will be created by "2_redact_data.R"
|       ├── set_a/                #       2 CSV files
|       └── set_b/                #       1 CSV file
└── Obtain and Redact Raw Data/   #   Code subfolder
    ├── 1_define_functions.R      #     Define functions for use by subsequent R scripts
    └── 2_redact_data.R           #     Redact certain CSV files from "raw_full" and output to "redacted"
```

***TODO: Move manifest TXT files' content to "1_define_functions.R"***




