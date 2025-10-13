# MT-Data-ManagingAnxietyStudy-Cleaning

**README Author:** [Jeremy W. Eberle][jeremy]\
**View Live:** [https://jwe4ec.github.io/MT-Data-ManagingAnxietyStudy-Cleaning/][ma-cleaning-repo-pages][^1]

This README describes centralized data cleaning for the MindTrails Project Managing
Anxiety Study, an NIMH-funded ([R34MH106770][ma-nih-reporter]) randomized controlled 
trial of web-based interpretation bias training for anxious adults (registration on
ClinicalTrials.gov: [NCT02382003][ma-clinical-trials]).

Initial data cleaning was conducted by [Sonia Baee][sonia] and [Claudia Calicho-Mamani][claudia] 
for the main outcomes paper ([Ji et al., 2021][ji-et-al-2021]). However, the clean datasets on 
that paper's [OSF project][ji-et-al-2021-osf] contain only (a) scale-level data for certain 
measures over time and (b) item-level data for certain measures only at baseline. Further, the 
final cleaning script used for that paper was lost, and the exact version of the raw dataset that 
was cleaned for that paper also seems lost.

The present repo seeks to obtain clean item-level data on key measures over time 
for the 807 participants in the main outcomes paper's intent-to-treat (ITT) sample. 
The repo does so by redacting two raw datasets and then comparing them to the clean 
datasets used in that paper. Although neither raw dataset seems to be the exact 
version cleaned for that paper, the present code is able to reproduce most of the 
scale-level data used in that paper from a combination of data drawn from these two 
raw datasets (and from the baseline item-level data used in that paper).

After reproducing most of the scale-level data used in the main outcomes paper,
the present code deviates from that paper in the cleaning of the demographics data 
(i.e., cleaning additional values for birth year and education; handling of blank 
values) and the OASIS data (i.e., recoding session values to be consecutive). The 
present code also outputs clean data for more measures (i.e., credibility) than are 
in the datasets used in that paper, and given that the present cleaning pipeline is 
reproducible, additional measures in the raw datasets could be added to the pipeline.

For more on the initial cleaning and how it compares to the present repo, see 
[Initial Versus Present Cleaning](#initial-versus-present-cleaning) below.

For questions, please contact [Jeremy Eberle][jeremy] or file an
[issue][ma-cleaning-repo-issues].

## TODO: Table of Contents




- [Initial Versus Present Cleaning](#initial-versus-present-cleaning)
  - [Initial Cleaning](#initial-cleaning)
  - [Present Cleaning](#present-cleaning)
  - [Differences](#differences)
- [Citation](#citation)
- [Data on OSF](#data-on-osf)
  - [Sets A and B](#raw-sets-a-and-b)
  - [Private Component](#private-component)
  - [Public Component](#public-component)
- [Code: Setup and File Relations](#code-setup-and-file-relations)
- [Code: Functionality](#code-functionality)
- [Further Cleaning and Analysis Considerations](#further-cleaning-and-analysis-considerations)
- [Resources](#resources)
  - [Appendices and Codebooks](#appendices-and-codebooks)
  - [MindTrails Wiki](#mindtrails-wiki)

## Initial Versus Present Cleaning

### Initial Cleaning

#### Imported Data and Code

The initial data cleaning done by [Sonia Baee][sonia] and [Claudia Calicho-Mamani][claudia] 
for the main outcomes paper ([Ji et al., 2021][ji-et-al-2021]) consists of two scripts 
(`R34_cleaning_script.R` and `R34.ipynb`) in the `Data Cleaning` folder of the
[MT-Data-ManagingAnxietyStudy][ma-repo] repo, and one script (`Script1_DataPrep.R`) 
on that paper's [OSF project][ji-et-al-2021-osf].

`R34_cleaning_script.R` and `R34.ipynb` both have issues (see
[MT-Data-ManagingAnxietyStudy/issues][ma-repo-issues]) and seem to be separate drafts 
(one script does not import data files exported from the other). Given that `R34.ipynb`
exports a data file whose name (`FinalData-28Feb20.csv`) resembles that of the data file 
(`FinalData-28Feb20_v02.csv`) imported by `Script1_DataPrep.R`, `R34.ipynb` seems to be 
the later draft. But the final version of `R34.ipynb` is unavailable (Sonia indicated on 
11/22/2021 that the final script was lost upon switching laptops).

- `R34_cleaning_script.R` (author: maybe Claudia, but uploaded by Sonia) imports data 
files that are unavailable. Although the filenames are dated 2/2/2019, some names differ 
from those in raw **[Sets A and B](#raw-sets-a-and-b)** (on the
[present repo's OSF project](#data-on-osf)), and some tables in Sets A and B are not 
imported. The script also exports files that are unavailable and some of whose 
filenames differ from those in Sets A and B. (See this 
[filenames comparison][ma-cleaning-repo-pages-filenames_list_flt].)[^2]
- `R34.ipynb` (by Sonia) imports data whose filenames are a subset of those 
imported by `R34_cleaning_script.R` ([comparison][ma-cleaning-repo-pages-filenames_list_flt]), 
but the files are unavailable, so it is unclear if files with the same names are the same. 
The script also imports some **`notes.csv`** metadata (on [this repo's OSF project](#data-on-osf)).
The script exports `FinalData-28Feb20.csv`, but this is unavailable and, again, not the name of the 
file imported by `Script1_DataPrep.R`.
- `Script1_DataPrep.R` (author: unknown but uploaded by Julie Ji) imports `FinalData-28Feb20_v02.csv`
(also unavailable) and, among other things, computes the final BBSIQ score used in the later analysis 
scripts for that paper. It exports **`R34_FinalData_New_v02.csv`** (which is on the 
[main outcome paper's OSF project][ji-et-al-2021-osf]).

#### "Clean" Data on Main Outcome Paper's OSF Project

**`R34_FinalData_New_v02.csv`** contains demographics data; scale-level data over
time for the BBSIQ, DASS-21-AS, DASS-21-DS, OASIS, and RR; and the CBM and imagery 
prime conditions for the 807 ITT participants in the main outcomes paper. The present
repo refers to this file as the **"clean data from the main outcomes paper"**.

Also on the [main outcome paper's OSF project][ji-et-al-2021-osf] is **`R34_Cronbach.csv`**, 
which contains item-level data at baseline for the BBSIQ, DASS-21-AS, OASIS, and RR for the 
same 807 participants. The code used to create this file is unavailable. The present repo 
refers to this file as the **"clean item-level baseline data from the main outcomes paper"**.

"Clean" is in quotes above because this repo deviates from these datasets (see below) 
and does further cleaning.

### Present Cleaning

Given that the raw datasets used to generate the "clean" datasets for the main outcome 
paper are unavailable, the present repo has to use the two raw datasets that are available, 
which the present repo calls **Sets A and B** and whose origins, differences, and storage on 
the present repo's OSF project are described in the section [Data on OSF](#data-on-osf) below.

Broadly, the present repo starts by redacting Sets A and B via `2_redact_data.R`. Then, 
`3_clean_data.R` cleans and scores Sets A and B for the tables they share (demographics, 
BBSIQ, DASS-21-AS, DASS-21-DS, OASIS, and RR) with the clean datasets from the main 
outcomes paper (**`R34_FinalData_New_v02.csv`**, **`R34_Cronbach.csv`**), with a focus on reproducing
the demographics data and scale scores for the 807 ITT participants in that paper.

After using clues from the initial cleaning scripts (`R34_cleaning_script.R`, `R34.ipynb`,
`Script1_DataPrep.R`) and **`notes.csv`** to clean and score these tables for the 807 ITT 
participants, `3_clean_data.R` compares Sets A and B with the clean data from the main 
outcomes paper (`R34_FinalData_New_v02.csv`), starting with the demographics data and then 
turning to non-demographic scale scores. For notes on these comparisons, see these 
[data notes](./docs/data_notes.md).

For demographics data, these comparisons revealed that the clean data from the main
outcomes paper has some likely inadvertent `NA` values for birth year (and thus age), some 
education values that were not cleaned, and some blank values for most items. After 
reproducing the demographics data, `3_clean_data.R` deviates from the main outcomes paper
and does [additional cleaning of the demographics data](#additional-demographics-cleaning).

For non-demographics data, these comparisons found that Set A has more data than Set B but 
is missing DASS-21-AS and OASIS data for some people (e.g., due to server error). After 
finding the data in Set B and `R34_Cronbach.csv`, `3_clean_data.R` adds these data to Set A 
and compares this "Set A With Added Data" to the clean data from the main outcomes paper. For
each table, the datasets have the same people but 
[different numbers of observations](#different-numbers-of-observations).

Comparisons of non-demographics data also revealed that in the clean data from the main outcomes 
paper, the `session` label in the OASIS table seems incorrect for 111 participants. The label 
makes it seem like these participants skipped the OASIS at one session, but `3_clean_data.R`
investigates this issue, and it is more plausible that the session label is incorrect. After
reproducing the OASIS data, `3_clean_data.R` 
[corrects the session label in the OASIS table](#corrected-session-in-oasis-table).

`3_clean_data.R` ultimately reproduces all of the scale scores for all of the tables and
observations that the "Set A With Added Data" shares with the clean data used in the main 
outcomes paper (it also confirms that the CBM and imagery prime conditions are the same).
But after doing so, `3_clean_data.R` removes the scale scores it computed because future 
analyses may deviate from the specific
[scale scores used in the main outcomes paper](#removed-scale-scores-used-in-main-outcomes-paper).

`3_clean_data.R` also [cleans the credibility data](#clean-credibility-data) for the 807 
ITT participants.

#### Exported Data on Present Repo's OSF Project

In the end, this repo exports redacted raw CSV files for all tables in Sets A and B. It also 
exports clean item-level CSV files for the demographics, credibility, BBSIQ, DASS-21-AS, DASS-21-DS, 
OASIS, RR, and participant (containing the CBM and imagery prime conditions) tables for the 807 
ITT participants, along with a CSV file with the time zones of POSIXct columns. These exported files, 
and the files imported into the present pipeline, are on [this repo's OSF project](#data-on-osf).

### Differences

#### 1. Additional Demographics Cleaning

The clean demographics data exported from the present repo differs from that used in the
main outcomes paper due to the following kinds of additional cleaning.[^3]

- The clean data from the main outcomes paper has 12 more `NA`s for birth year (and thus age).
These `NA`s (`inadvertent_na_birth_year_pids`), which correspond to weird raw birth years (i.e., 
those > 2222) in Set A, seem inadvertent because (a) the raw values were corrected in Set B, (b) 
`R34_cleaning_script.R` made the same corrections, and (c) `R34.ipynb` intended to make these 
corrections but didn't due to a bug (see [Issue 9][ma-repo-issue9] on [MT-Data-ManagingAnxietyStudy][ma-repo]). 
The clean data exported from the present repo corrects these birth years.
- The clean data from the main outcomes paper has weird education values for 2 people
(`weird_education_pids`). These were corrected in `R34_cleaning_script.R` but not in `R34.ipynb` 
(see [Issue 10][ma-repo-issue10] on [MT-Data-ManagingAnxietyStudy][ma-repo]). The clean data exported 
from the present repo corrects these values.
- The clean data from the main outcomes paper has some blank values for most items that
correspond to raw blanks and question marks in Sets A and B, suggesting an apparent server
issue. For clarity, the clean data exported from the present repo recodes these blanks as
`Missing (server issue)`.

#### 2. Numbers of Observations

The clean data exported from the present repo has different numbers of observations from 
that used in the main outcomes paper (see the `set_add` vs. `clean` columns below, respectively)[^4] 
for the following reasons.

  ```text
  > set_add_vs_cln_nrow
              set_add clean diff
  bbsiq          1234  1233    1   # Participant 532
  dass21_as       909   913   -4   # Likely additional data collected
  dass21_ds      1175  1174    1   # Participant 532
  demographic     807   807    0
  oa             2662  2681  -19   # Likely additional data collected
  participant     807   807    0
  rr             1186  1185    1   # Participant 532
  ```
  
- In the clean data from the main outcomes paper (`R34_FinalData_New_v02.csv`), Participant 532 
lacks baseline scores for the BBSIQ, DASS-21-DS, and RR. `notes.csv` says that they were originally 
thought not to have RR data at baseline but do. Their baseline BBSIQ and RR data are the same as 
those in the clean item-level baseline data (`R34_Cronbach.csv`). Thus, these data are retained 
in the clean data exported from the present repo.
- The clean data from the main outcomes paper (`R34_FinalData_New_v02.csv`) has 4 more rows for
the DASS-21-AS and 19 more rows for the OASIS than the clean data exported from the present repo.
For all participants, the additional row(s) are for session(s) that came after the participants' 
session(s) for which the DASS-21-AS or OASIS data are available in Sets A or B. Most likely, the 
clean data from the main outcomes paper were derived from raw data dumped from the server at some
point after Sets A and B were dumped from the server. (Indeed, Sets A and B seem to have less data
than the raw data imported and described in `R34.ipynb`; see [data notes](./docs/data_notes.md).)

#### 3. Corrected Session in OASIS Table

The clean data exported from the present repo has different session labels in the OASIS table for 
111 participants whose labels in the clean data from the main outcomes paper make it seem like 109 
participants skipped the OASIS at Session 1 (e.g., Participant 431 in `initial_ex` below) and like 2 
participants skipped the OASIS at Session 3. In the clean data exported from the present repo, these 
labels are recoded to be consecutive (e.g., `present_ex` below).[^5]

```text
> initial_ex   # Clean data from main outcomes paper (dates are unavailable)
  participant_id session_only oasis_score
1            431          PRE          12
2            431     SESSION2          13
3            431     SESSION3          11
> present_ex   # Clean data exported from present repo (before "oa_total" is removed)
  participant_id session_only     date_as_POSIXct oa_total
1            431          PRE 2016-06-13 11:20:35       12
2            431     SESSION1 2016-06-13 11:29:35       13   # Recoded session
3            431     SESSION2 2016-06-16 00:30:17       11   # Recoded session
```

These 111 participants are present across CBM and imagery prime conditions:

```text
> table(sep_dat_comp_rest$participant$cbmCondition[skipped_1_oa_session_mask])
FIFTY_FIFTY     NEUTRAL    POSITIVE   # CBM conditions
         31          51          29 
> table(sep_dat_comp_rest$participant$prime[skipped_1_oa_session_mask])
ANXIETY NEUTRAL                       # Imagery prime conditions
     59      52
```

The consecutive session labels are more plausible for the following reasons:

- For participants whose session labels in Set A and in the clean data used in the main outcomes
paper make it seem like they skipped the OASIS at one session, their session labels in the Set A 
OASIS table differ from the session labels for the OASIS in the Set A task log (which are consecutive). 
Moreover, some of these participants' session dates in the Set A OASIS table differ from their dates 
for corresponding sessions in the Set A RR table. (Note: The clean data used in the main outcomes
paper lacks a task log and lacks session dates.)
- The session labels were corrected to be consecutive in Set B.
- For participants whose session labels in Set A and in the clean data used in the main outcomes 
paper make it seem like they skipped the OASIS at Session 1, most of the dates in the Set A OASIS
table are the same for baseline and Session 2. This is implausible because whereas Session 1
could be started right after the baseline assessment was completed, Session 2 could not be started 
until 2 days after Session 1 was completed.

#### 4. Removed Scale Scores Used in Main Outcomes Paper

The clean data exported from the present repo excludes all of the scale scores that 
`3_clean_data.R` computed to reproduce those in the clean data used in the main outcomes 
paper (`R34_FinalData_New_v02.csv`), which used the specific scoring methods below.

- **BBSIQ mean ratio score (`bbsiq_ratio_mean`)**
  - Computed as the mean of (a) the ratio of the mean of the 7 negative internal items to 
  the mean of the 14 benign internal items (`bbsiq_int_ratio`) and (b) the ratio of the mean 
  of the 7 negative external items to the mean of the 14 benign external items (`bbsiq_ext_ratio`).
  Each mean for a set of items is the mean of the available items in that set.
  - Called **`negativeBBSIQ`** (i.e., the mean of the two ratios `bbsiq_physical_score` and `bbsiq_threat_score`,
  respectively) in `R34_FinalData_New_v02.csv`
- **DASS-21-AS doubled total score (`dass21_as_total_dbl`)**
  - Computed by first imputing item-level `NA`s with the median of the item's column in long-format
  data (i.e., across participants and time points), then computing the sum of all 7 items and multiplying
  the sum by 2
    - Although the imputed values were used to compute the score, the clean data from the present repo 
    retains the original `NA`s (does not actually overwrite them with the imputed values)
  - Called **`dass_as_score`** in `R34_FinalData_New_v02.csv`
- **DASS-21-DS doubled total score (`dass21_ds_total_dbl`)**
  - Computed using the DASS-21-AS method above but with the 7 DASS-21-DS items
  - Called **`dass_ds_score`** in `R34_FinalData_New_v02.csv`
- **OASIS total score (`oa_total`)**
  - Computed as the sum of all 5 items, treating item-level `NA`s as responses of 0
  - Called **`oasis_score`** in `R34_FinalData_New_v02.csv`
- **RR average item scores (`rr_nf_mean`, `rr_ns_mean`, `rr_pf_mean`, `rr_ps_mean`)**
  - Computed, respectively, as (a) the mean of the 9 negative nonthreat items, (b) the mean of the 9
  negative threat items, (c) the mean of the 9 positive nonthreat items, and (d) the mean of the 9
  positive threat items. Each mean is the mean of the available items.
  - Called **`RR_negative_nf_score`**, **`RR_negative_ns_score`**, **`RR_positive_pf_score`**, and
  **`RR_positive_ps_score`**, respectively, in `R34_FinalData_New_v02.csv`

#### 5. Clean Credibility Data

The clean data exported from the present repo includes the credibility data. Given that these data
are not in the clean data from the main outcomes paper, `3_clean_data.R` confirms that the credibility
data in Sets A and B are identical.

## Citation

When using a given release of the cleaning code or associated [data](#data-on-osf), please 
cite the version number and Version DOI for the release. The Version DOI for a given release 
is in the [Release Notes][ma-cleaning-repo-releases]. **To get the full citation, click on 
the DOI badge in the [Release Notes][ma-cleaning-repo-releases] to go to that version's 
record on Zenodo, where the citation is in the Citation pane.**

For more details about version numbers, GitHub releases, Zenodo DOIs, and acknowledgments,
see the [Citation](./docs/citation.md) page.

## Data on OSF

The data files imported into the present data cleaning pipeline--the two sets of raw data 
(**Sets A and B**) from Sonia, the two "clean" datasets from the main outcomes paper 
(**`R34_FinalData_New_v02.csv`**, **`R34_Cronbach.csv`**), and the **`notes.csv`** 
from Sonia--and the clean data exported from the present repo are stored in the 
[MindTrails Managing Anxiety Study][ma-osf] project on the Open Science Framework (OSF).

The project has two components, with different permissions: a 
[Private Component][ma-osf-private] and a [Public Component][ma-osf-public].

### Raw Sets A and B

Two sets of raw data originating from the Managing Anxiety (R34) SQL database and both
containing data up to 2/2/2019 were obtained from Sonia Baee.

- **Set A** is a larger set of 26 CSV files obtained from Sonia on 9/3/2020 (who stated 
on that date that they are the latest version of the database on the R34 server 
and that she obtained them from Claudia Calicho-Mamani)
- **Set B** is a partial set of 20 CSV files obtained from Sonia on 1/18/2023

Sets A and B differ in several ways. For example, Set A has more tables than Set B 
(see [filenames comparison][ma-cleaning-repo-pages-filenames_list_flt]) and more
data on key shared tables (see [data notes](./docs/data_notes.md)). However, Set A
is missing data in some tables for some people--data that are in Set B
([data notes](./docs/data_notes.md)). They also differ in their structure and values (e.g., 
see [data notes](./docs/data_notes.md)), and some oddities in Set A (e.g., weird birth 
years, implausible session labels for OASIS) seem to have been corrected in Set B.

Given that the clean data from the main outcomes paper has more rows for some
tables (e.g., DASS-21-AS, OASIS) than the clean data exported from the present repo
(see [Numbers of Observations](#2-numbers-of-observations) above), neither Set A nor
Set B seems to be the exact version of the raw data cleaned for that paper, which
might have been dumped from the server at a later date. Still, using both Sets A and 
B, the present repo reproduces most of the scores used in that paper.

### Other Data

#### Copies of "Clean" Data From Main Outcomes Paper

Given that the present repo seeks to reproduce the scale scores in the clean data from 
the main outcomes paper, it imports the two clean data files on 
[that paper's OSF project][ji-et-al-2021-osf]. `R34_FinalData_New_v02.csv` 
and `R34_Cronbach.csv`, which are [described above](#clean-data-on-main-outcome-papers-osf-project)
and were uploaded to that OSF project on `2020-04-18 01:10 AM`, were downloaded from that OSF project
and put in the `data/other/clean_from_main_paper/` folder of the present repo's OSF project.

#### Notes from Sonia

The present repo also uses `notes.csv`, which was obtained from from Sonia Baee on 11/24/2021 
and put in the `data/other/notes_from_sonia/` folder of the present repo's OSF project.

#### For README

Additionally, the present repo uses a `filenames_list.csv` manually created by Jeremy Eberle
in the `data/other/for_README/` folder of this repo's OSF project to generate the HTML
for the [filenames comparison][ma-cleaning-repo-pages-filenames_list_flt] of this README.
`3_clean_data.R` imports this CSV file, filters out certain filenames,[^2] and creates 
`docs/filenames_list_flt.html`, which is hosted on this repo's GitHub Pages site.

### Private Component

**TODO: Upload new ZIP files with new version number (v1.0.1) to OSF and add entry to version history**





The [Private Component][ma-osf-private] has a file `private-v1.0.0.zip` with the **full set 
of raw data files** (with one exception) for **Sets A and B**. The ZIP's structure is below.

The exception is that for Set A only the redacted version of the `GiftLog` table 
is included (which was redacted on the first run of `code/2_redact_data.R`; see below).

```
.
└── data/
    └── raw_full/    # All raw files (but see exception for Set A above)
        ├── set_a/   #   26 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019.csv")
        └── set_b/   #   20 CSV files (e.g., "ImageryPrime_02_02_2019.csv")
```

To request access to files on this component, contact [Jeremy Eberle][jeremy] or 
[Bethany Teachman][bethany-email].

### Public Component

The [Public Component][ma-osf-public] has a file `public-v1.0.0.zip` with a 
**partial set of raw data files** (i.e., those that did not need redaction) for 
**Sets A and B**, **redacted files** for Sets A and B, other data files needed for 
the present cleaning ("clean" **`R34_FinalData_New_v02.csv`** and **`R34_Cronbach.csv`** 
files from the main outcomes paper; **`notes.csv`** from Sonia) and README 
(`filenames_list.csv`), and clean data files (see
[exported data](#exported-data-on-present-repos-osf-project) above).
The ZIP's structure is below.

Note: The `ImageryPrime` table (in Sets A and B) in the `raw_full` folder of the 
[Private Component](#private-component) that is not in the `raw_partial` folder of 
this Public Component has a column that may have identifiers, whereas the `GiftLog` 
table (in Set A) in the `raw_full` folder that is not in the `raw_partial` folder 
has already been redacted (no need to retain raw version of this table). In the 
Public Component, redacted versions of these two tables are in the `redacted` folder.

```
.
├── data/                    
|   ├── raw_partial/                   # Raw files that did not need redaction
|   |   ├── set_a/                     #   24 CSV files (e.g., "DASS21_AS_recovered_Feb_02_2019.csv")
|   |   └── set_b/                     #   19 CSV files (e.g., "DASS21_AS_02_02_2019.csv")
|   ├── redacted/                      # Redacted files
|   |   ├── set_a/                     #   2 CSV files (e.g., "ImageryPrime_recovered_Feb_02_2019_redacted.csv")
|   |   └── set_b/                     #   1 CSV file (e.g., "ImageryPrime_02_02_2019_redacted.csv")
|   ├── other/                         # Other files needed for data cleaning
|   |   ├── clean_from_main_paper/     #   2 CSV files ("R34_FinalData_New_v02.csv", "R34_Cronbach.csv")
|   |   ├── notes_from_sonia/          #   1 CSV file ("notes.csv")
|   |   └── for_README/                #   1 CSV file ("filenames_list.csv")
|   └── intermediate_clean/            # Clean files
|       ├── tables/                    #   8 CSV files (e.g., "dass21_as.csv")
|       └── "POSIXct_time_zones.csv"   #   Time zones of tables' POSIXct columns
└── materials/
    ├── appendices/                    # Appendices
    └── codebooks/                     # Codebooks
```

### Version Control

If a newer version of the ZIP for the Private or Public Components is released, the 
new ZIP with a new version number will be uploaded. Old versions will not be deleted 
given that analysis projects will import data from specific versions (projects 
should [cite](#citation) the version they use). For simplicity, if either ZIP is 
updated, new versions of both ZIP files with the same version number will be uploaded.

- **v1.0.0**: `private-v1.0.0.zip` and `public-v1.0.0.zip` were uploaded by Jeremy Eberle on 
9/18/2025 after running the redaction script below (as of commit `988cf1e` "Distinguish first 
vs. later runs of scripts"; setting `first_run` in `2_redact_data.R` to `TRUE`) on that date.

## Code: Setup and File Relations

The scripts in `code/` import the full raw data files for Sets A and B, redact certain 
files for Sets A and B, and clean the redacted and remaining raw files to yield *intermediately* 
clean files. The resulting files are considered "intermediately cleaned" because further, 
analysis-specific cleaning will be required for any given analysis.

Create a parent folder (with any desired name, indicated by `.` in the 
[directory tree](#directory-tree-and-runtimes) below) with two subfolders: `data` and `code`.
Put the code from the present repo in the `code` folder and set the working directory to the
parent folder so that data can be imported and exported using relative file paths.

### Redacting Data

If you have access to the full raw data (from the [Private Component](#private-component)), you can 
reproduce the redaction. Put the raw data files in subfolders of `data` called `raw_full/set_a/` and 
`raw_full/set_b/`. `2_redact_data.R` will create the `data/redacted/` and `data/raw_partial/` folders 
and files therein.

Note: On the first run of `2_redact_data.R`, `first_run` in that script was set to `TRUE` (which 
redacted both the `GiftLog` and `ImageryPrime` tables). When reproducing the redaction starting 
from the raw data already on the Private Component, `first_run` should be set to `FALSE` (which 
will redact only `ImageryPrime`, because the `GiftLog` on the Private Component is already redacted,
but both redacted files will still be exported to `data/redacted/`).

### Cleaning Data

`3_clean_data.R` imports raw data files that did not need redaction (from `data/raw_partial/set_a/`
and `data/raw_partial/set_b/`) and redacted data files (from `data/redacted/set_a/` and 
`data/redacted/set_b/`). If you reproduced the redaction following the steps above, these folders 
and their files will be automatically created; otherwise, you can get these folders and their files 
from the [Public Component](#public-component).

`3_clean_data.R` also imports other files needed for the present cleaning (from 
`data/other/clean_from_main_paper/` and `data/other/notes_from_sonia/`) and README (from `data/other/for_README/`).
You can get these folders and their files from the [Public Component](#public-component).

`3_clean_data.R` will create the `data/intermediate_clean/` folder containing a CSV file with the time zones
of the clean tables' POSIXct columns (`POSIXct_time_zones.csv`) and a `tables` subfolder with the clean 
CSV data files. It will also create the `docs` folder and HTML file therein (`filenames_list_flt.html`).

`4_import_clean_data.R` imports the time zones of clean tables' POSIXct columns (from 
`data/intermediate_clean/`) and the clean tables themselves (from `data/intermediate_clean/tables/`).
It does not export any files but serves as a starting point for further cleaning and analysis.

### Directory Tree and Runtimes

```
.                                      # Parent folder (i.e., working directory)
├── data/                              #   Data subfolder (manually create)
|   ├── raw_full/                      #     Folder from Private Component
|   |   ├── set_a/                     #       26 CSV files
|   |   └── set_b/                     #       20 CSV files
|   ├── (raw_partial/)                 #     Folder created by "2_redact_data.R" or from Public Component
|   |   ├── set_a/                     #       24 CSV files
|   |   └── set_b/                     #       19 CSV files
|   ├── (redacted/)                    #     Folder created by "2_redact_data.R" or from Public Component
|   |   ├── set_a/                     #       2 CSV files
|   |   └── set_b/                     #       1 CSV file
|   ├── other/                         #     Folder from Public Component
|   |   ├── clean_from_main_paper/     #       2 CSV files ("R34_FinalData_New_v02.csv", "R34_Cronbach.csv")
|   |   ├── notes_from_sonia/          #       1 CSV file ("notes.csv")
|   |   └── for_README/                #       1 CSV file ("filenames_list.csv")
|   └── (intermediate_clean/)          #     Folder created by "3_clean_data.R"
|       ├── tables/                    #       8 CSV files
|       └── "POSIXct_time_zones.csv"   #
├── code/                              #   Code subfolder from this repo
|   ├── 1_define_functions.R           #     Define functions for use by subsequent R scripts
|   ├── 2_redact_data.R                #     Redact certain CSV files from "raw_full/"
|   ├── 3_clean_data.R                 #     Clean certain CSV files from "raw_partial/" and "redacted/"
|   └── 4_import_clean_data.R          #     Import clean CSV files from "intermediate_clean/"
└── (docs/)                            #   Docs subfolder created by "3_clean_data.R"
    └── (filenames_list_flt.html)      #     HTML file created by "3_clean_data.R"
```

On a Windows 11 Enterprise laptop (32 GB of RAM; Intel Core Ultra 7 165U, 1700 Mhz, 12 cores, 
14 logical Processors), each script runs in < 1 min. As noted in `1_define_functions.R`, 
packages may take longer to load the first time you load them with `groundhog.library()`.

## Code: Functionality

### [1_define_functions.R](./code/1_define_functions.R)

This script defines functions for use by later scripts, each of which sources this file.

Version control is achieved by checking that the R version used to write the scripts 
(`R version 4.4.3 (2025-02-28 ucrt)`) matches the user's R version and by defining dates 
for `meta.groundhog()` and `groundhog_day`, which are used by the `groundhog` package to 
load the package versions that were used to write the scripts. See script for details.

### [2_redact_data.R](./code/2_redact_data.R)

This script redacts relevant columns by replacing all of their rows with 
`REDACTED_BY_CLEANING_SCRIPT`, retaining the structure of the raw data files.

- Specify columns to retain that were considered for redaction
- Identify and manually check character columns in Sets A and B
- Redact `order_id` from gift log table in Set A
- Redact `situation` from imagery prime table in Sets A and B
- Export redacted tables to `data/redacted/` for Sets A and B
- Copy tables that did not need redaction to `data/raw_partial/` for Sets A and B 

Note: To ensure that `order_id` is not retained in the full raw data, after the first run of
this script, the unredacted version of the gift log table was deleted from 
`data/raw_full/set_a/` and replaced with the redacted version.

By contrast, the unredacted versions of the imagery prime table are retained in 
`data/raw_full/set_a/` and `data/raw_full/set_b/` on the Private Component because 
these tables contain free-text responses that may *or may not* contain identifiers. 
Notably, participants were not asked to provide identifiers in their responses.

### [3_clean_data.R](./code/3_clean_data.R)

After creating the HTML table to [compare filenames][ma-cleaning-repo-pages-filenames_list_flt], 
this script does the following to clean key data tables of interest.

#### Prepare Datasets for Comparison

- Clean `notes.csv` and identify 36 participants affected by server error (`server_error_pids`)
- Restructure clean data from main outcomes paper (`R34_FinalData_New_v02.csv`) and clarify session column
  - Extract data into separate, long-format tables
  - Compute `session_only`, as original `session` in DASS-21-AS table may conflate 
  session label with eligibility
- Streamline tables in Sets A and B
  - Investigate `_FIXED` tables in Set A and exclude `CIHS_recovered_Feb_02_2019` as 
  `CIHS_Feb_02_2019_FIXED` has more columns and the same values on shared columns
  - Investigate other repeated tables in Sets A and B and exclude the `DD_FU` tables because 
  the `DD` tables have more rows/columns and are the same as the `DD_FU` tables otherwise
  - Shorten table names
  - Restrict to tables of potential interest (initially consider the DD and QOL tables in 
  addition to the participant, demographics, BBSIQ, DASS-21-AS, DASS-21-DS, OASIS, RR,
  credibility, and task log tables)
- Clarify participant, date, and session columns in Sets A and B
  - Identify potential columns that index participants in Sets A and B, correct weird 
  `participantRSA` values in Set A where possible, and define `participant_id` in Sets A 
  and B
  - Compare numbers of participants in Sets A and B and those counted in `R34.ipynb`
  - Identify, investigate, and recode time stamp and date columns in Sets A and B, handling
  Set B participants with shorter dates in their DASS-21-AS and OASIS tables
  - Compute `session_only` in Sets A and B, for same reason as above
- Identify 807 ITT participant IDs in clean data from main outcomes paper (`cln_participant_ids`), 
confirm that none are test accounts, and filter Sets A and B to these participants
- Check for discrepancies between session and date-related values in Set A task log table
and other tables in Sets A and B and in clean data from main outcomes paper
- Check for and resolve unexpected multiple entries in Set A (using approaches from main
outcomes paper)
  - Resolve for OASIS table by sorting each participant's entries chronologically and then 
  recoding the session column so that it reflects the expected session order for the number 
  of entries present for that participant
  - Resolve for other tables by keeping the most recent entry (but retain all entries in 
  task log for reference)
- Check for unexpected multiple entries in Set B (none found)
- Clarify participant and session columns in clean item-level baseline data from main
paper (`R34_Cronbach.csv`)
- Define scale items in Sets A and B and in clean baseline item-level data from 
main outcomes paper
- Extract clean item-level baseline data from main outcomes paper into separate tables
- Compute scale scores in Sets A and B and clean item-level baseline data from 
main outcomes paper
  - Recode "prefer not to answer" values as `NA`
  - Recode credibility items in Sets A and B (see [Issue 12][ma-repo-issue12] in 
  [MT-Data-ManagingAnxietyStudy][ma-repo])
  - Check response ranges
  - Compute scores using approaches from main outcomes paper (for BBSIQ, DASS-21-AS, 
  DASS-21-DS, OASIS, and RR; see 
  [scoring approaches above](#removed-scale-scores-used-in-main-outcomes-paper))
  
#### Compare Datasets, Investigate Differences, Add Missing Data, and Do More Cleaning

- Clean demographics table (with focus on Set A) and compare with clean data from main outcomes
paper (after reproducing clean data, do [additional cleaning above](#additional-demographics-cleaning))
- Compare Set A with clean data from main outcomes paper on non-demographic tables
  - Compare participants and numbers of observations for shared participants
  - Investigate [ostensibly skipped sessions in OASIS table](#corrected-session-in-oasis-table)
    - Compare session dates between OASIS, RR, and task log tables in Set A (different)
    - Identify 111 people with one session skipped in OASIS table in Set A and clean data (109 
    at Session 1: `skipped_oa_S1_set_a_pids`; 2 at Session 3: `skipped_oa_S3_set_a_pids`)
  - Compare scale scores above for shared observations (same)
- Compare Set B with clean data from main outcomes paper on non-demographic tables
  - Compare participants and numbers of observations for shared participants
  - Compare scale scores above for shared observations (same except OASIS scores for people with 
  one session skipped in OASIS table in clean data)
  - Further investigate [ostensibly skipped sessions in OASIS table](#corrected-session-in-oasis-table)
    - No participants have skipped sessions in Set B OASIS table
    - Compare session labels in Set B OASIS table to those in Set A task log (same)
    - Compare session labels in Set A OASIS table to those in Set A task log (different
    unless session labels in Set A OASIS table are recoded to be consecutive)
    - Compare session dates between OASIS and RR tables in Set B (consistent)
- Look for and add non-demographic data missing for some participants in Set A
  - Create `dataset` column in each table to label each row with its source
  - For the 36 participants affected by server error (`server_error_pids`):
    - Add data from Set B OASIS and DASS-21-AS tables
    - Add baseline DASS-21-AS data from `R34_Cronbach.csv` for 2 more participants (data not in Set B)
  - For another participant (1866), add baseline OASIS data from `R34_Cronbach.csv` (data not in Set B)
- Compare "Set A With Added Data" with clean data from main outcomes paper on non-demographic tables
  - Same participants but [different numbers of observations](#numbers-of-observations)
  - Compare scale scores above for shared observations (same)
  - Compare CBM and anxiety imagery prime conditions (same)
- Compare Sets A and B on credibility table (same)
- Do additional cleaning to finalize clean data to export
  - From "Set A With Added Data", add participant, demographics, BBSIQ, DASS-21-AS, DASS-21-DS, OASIS, 
  and RR tables to list of tables to export
  - [Correct session label in OASIS table](#corrected-session-in-oasis-table) to 
  be consecutive for people who ostensibly skipped one session
  - [Remove scale scores](#removed-scale-scores-used-in-main-outcomes-paper) 
  computed via scoring methods of main outcomes paper
  - From Set A, add credibility table to list of tables to export
- Get time zones of clean tables' POSIXct columns
- Export clean tables and the time zones of their POSIXct columns as CSV files

### [4_import_clean_data.R](./code/4_import_clean_data.R)

This script imports the clean data files and converts the POSIXct columns, which
were exported as characters, back to the POSIXct data type. As such, the script 
serves as a starting point for further cleaning and analysis.

## Further Cleaning and Analysis Considerations

The following considerations may be relevant to further cleaning or to analysis.

### Present Intermediately Clean Data

Keep the following in mind when using the clean data exported from the present repo.

- Use `participant_id` to index participants and `session_only` to index time points
- The `_as_POSIXct` columns assume that system-generated time stamps are in `EST` time
zone (i.e., UTC - 5, all year, not `America/New York`, which switches between EST and EDT)
- For task log table:
  - Time stamp columns seem to be an hour different from other tables' time stamps
  - Unexpected multiple entries were retained in this table for reference, including:
    - Multiple SUDS entries at Sessions 1, 3, 6, and 8 (with no `tag` for before vs. after training)
    - Multiple non-SUDS entries
- Item values of `NA` in exported tables are due to "prefer not to answer" responses
  - Except for demographics table, where `NA`s for birth year (and thus age) are due to weird 
  values (0 or 2222) and where "prefer not to answer" for categorical items is its own explicitly
  named level
- Item response ranges have already been checked for exported tables
  - Note: RR response options were `0:3` in present study (retained here) but `1:4` in Calm Thinking study
  - Note: credibility response options (corrected here to `1:5`) differ from those analyzed in present
  study's credibility paper (see [Issue 12][ma-repo-issue12] in [MT-Data-ManagingAnxietyStudy][ma-repo])
- Each table's `dataset` column labels each row with its source, using these labels:
  - `"raw_dat"`: from Set A
  - `"raw_dat_b"`: from Set B
  - `"cln_dat"`: from "clean" data from main outcomes paper (`R34_FinalData_New_v02.csv`)
  - `"cln_dat_bl"`: from "clean" item-level baseline data from main outcomes paper (`R34_Cronbach.csv`)
- To clean additional tables (e.g., DD, QOL), consider comparing Sets A and B (approach used 
here for credibility table) since other tables are not in clean data from main outcomes paper
- Further, analysis-specific cleaning will be needed for any given analysis
  - Use [`4_import_clean_data.R`](./code/4_import_clean_data.R) as a starting point for further cleaning and analysis

### Additional Item-Level Data at Baseline

**TODO: Mention item-level baseline data Julie analyzed for flexibility paper**

[Ji et al., 2024][ji-et-al-2024],
[OSF project][ji-et-al-2024-osf]




## Resources

### Appendices and Codebooks

Appendices and codebooks for the Managing Anxiety study are on the [Public Component](#public-component).

**TODO: Correct appendix/codebook issues (https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues)**





### MindTrails Wiki

This is a wiki with MindTrails Project-wide and study-specific information that is 
privately stored by the study team.

Researchers can request access to relevant wiki info by contacting 
Bethany Teachman ([bteachman@bvirginia.edu][bethany-email]).

### Other MindTrails Repositories

**TODO: Mention repos for the MA study website itself**





[^1]: This is the link to the present repo's corresponding GitHub Pages site,
which is currently being built from the `redact-and-clean-data` branch. **TODO: Update publishing source**  
[^2]: Some files exported by `R34_cleaning_script.R` are incorrect (see 
[Issue 11][ma-repo-issue11] on [MT-Data-ManagingAnxietyStudy][ma-repo]) and thus 
excluded from this [filenames comparison][ma-cleaning-repo-pages-filenames_list_flt].  
[^3]: The code to generate the `_pids` with demographic differences below is in `code/3_clean_data.R`.  
[^4]: The code to generate `set_add_vs_cln_nrow` is in `code/3_clean_data.R`.  
[^5]: The code to generate `initial_ex` and `present_ex` and the condition breakdowns is in `code/3_clean_data.R`.

[bethany-email]: mailto:bteachman@virginia.edu
[claudia]: https://github.com/cpc4tz
[jeremy]: https://github.com/jwe4ec
[ji-et-al-2021]: https://doi.org/10.1016/j.brat.2021.103864
[ji-et-al-2021-osf]: https://osf.io/3b67v
[ji-et-al-2024]: https://doi.org/10.1177/20438087241226642
[ji-et-al-2024-osf]: https://osf.io/tq3p7/?view_only=33c0ace49fe04688bf37afa556fd072d
[ma-cleaning-repo-issues]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/issues
[ma-cleaning-repo-pages]: https://jwe4ec.github.io/MT-Data-ManagingAnxietyStudy-Cleaning/
[ma-cleaning-repo-pages-filenames_list_flt]: https://jwe4ec.github.io/MT-Data-ManagingAnxietyStudy-Cleaning/docs/filenames_list_flt.html
[ma-cleaning-repo-releases]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/releases
[ma-clinical-trials]: https://clinicaltrials.gov/study/NCT02382003
[ma-repo]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy
[ma-repo-issues]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues
[ma-repo-issue9]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/9#issue-3457953028
[ma-repo-issue10]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/10#issue-3458115537
[ma-repo-issue11]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/11#issue-3491960561
[ma-repo-issue12]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/12#issue-3506306045
[ma-nih-reporter]: https://reporter.nih.gov/search/ijY8QOUKrkCEZw244HN_zQ/project-details/9025584
[ma-osf]: https://osf.io/pvd67/
[ma-osf-private]: https://osf.io/5sn2x/
[ma-osf-public]: https://osf.io/2x3jq/
[sonia]: https://github.com/soniabaee