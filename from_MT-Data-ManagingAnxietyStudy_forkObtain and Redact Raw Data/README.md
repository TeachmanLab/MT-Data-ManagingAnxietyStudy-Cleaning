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

**Sets A and B differ in some key ways**, and Jeremy Eberle is currently working to compare 
them with the clean data used for the main outcomes paper. For more information, see his
[jwe4ec/ma-networks](https://github.com/jwe4ec/ma-networks) repo (for differences he has
found as of 9/18/2025, see his [develop](https://github.com/jwe4ec/ma-networks/tree/develop) branch).

### Private Component

The [Private Component](https://osf.io/5sn2x/) has a file `private-v1.0.0.zip` with the
full set of raw data files (with one exception) for Sets A and B. The ZIP's structure is below.

The exception is that for Set A only the redacted version of the `GiftLog` table 
is included (which was redacted on the first run of the scripts below).

```
.
└── data/
    └── raw_full/    # All raw files (but see exception for Set A above)
        ├── set_a/   #   26 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019.csv")
        └── set_b/   #   20 CSV files (e.g., "ImageryPrime_02_02_2019.csv")
```

To request access to files on this component, contact Bethany Teachman ([bteachman@bvirginia.edu](mailto:bteachman@bvirginia.edu)).

### Public Component

The [Public Component](https://osf.io/2x3jq/) has a file `public-v1.0.0.zip` with
a partial set of raw data files (i.e., those that did not need redaction) for Sets 
A and B and redacted files for Sets A and B. The ZIP's structure is below.

Note: The `ImageryPrime` table (in Sets A and B) in the `raw_full` folder of the 
[Private Component](#private-component) that is not in the `raw_partial` folder of 
this [Public Component](https://osf.io/2x3jq/) has a column that may have identifiers,
whereas the `GiftLog` table (in Set A) in the `raw_full` folder that is not in the
`raw_partial` folder has already been redacted. In the [Public Component](https://osf.io/2x3jq/), 
redacted versions of these two tables are in the `redacted` folder.

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

### Version Control

If a newer version of the ZIP for the Private Component or the ZIP for the Public
Component is released, upload the new ZIP with a new version number and document 
the changes below but **do not delete any old versions**. Analysis projects will
import the data from specific versions (projects should reference the version
they use).

- `private-v1.0.0.zip` and `public-v1.0.0.zip` were uploaded by Jeremy Eberle on 
9/18/2025 after running the redaction scripts below (as of commit `ce73142`; setting
`first_run` in `2_redact_data.R` to `TRUE`) on that date.

## Redaction Scripts: Setup and File Relations

The scripts in the `Obtain and Redact Raw Data` folder of this repository import 
the full raw data files for Sets A and B and redact certain files.

If you have access to the full raw data (from the [Private Component](#private-component)), 
you can reproduce the redaction. Create a parent folder (with any desired name, indicated 
by `.` below) with two subfolders: `data` and `Obtain and Redact Raw Data`. The working 
directory must be set to the parent folder to import/export data via relative file paths.

Put the raw data files in subfolders of `data` called `raw_full/set_a/` and `raw_full/set_b/`.
When `2_redact_data.R` is run, it will create the `redacted` folder and files therein.

Note: On the first run of the redaction scripts, `first_run` in `2_redact_data.R` was 
set to `TRUE` (which redacted both the `GiftLog` and `ImageryPrime` tables). When
reproducing the redaction starting from the raw data already on the Private Component,
`first_run` should be set to `FALSE` (which will redact only `ImageryPrime`, because
the `GiftLog` on the Private Component is already redacted).

```
.                                 # Parent folder (i.e., working directory)
├── data/                         #   Data subfolder
|   ├── raw_full/                 #     Folder with files from Private Component
|   |   ├── set_a/                #       26 CSV files
|   |   └── set_b/                #       20 CSV files
|   └── (redacted/)               #     Folder with files will be created by "2_redact_data.R"
|       ├── set_a/                #       1 CSV file (2 on first run of redaction scripts)
|       └── set_b/                #       1 CSV file
└── Obtain and Redact Raw Data/   #   Code subfolder
    ├── 1_define_functions.R      #     Define functions for use by subsequent R scripts
    └── 2_redact_data.R           #     Redact certain CSV files from "raw_full" and output to "redacted"
```