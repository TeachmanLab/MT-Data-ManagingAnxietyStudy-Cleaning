# Initial Inspection

This is an initial inspection of scripts and data obtained from Julie Ji on 9/10/2025
for the paper [Ji et al. (2024)][ji-et-al-2024].

The following three scripts seem to import eight files from Set B and two other files
(`R34_Flexibility_Claudia.csv`, `Flexibility.RR.Sample.Total.csv`). `R34_Flexibility_Claudia.csv`, 
presumably from [Claudia Calicho-Mamani][claudia], seems to have item-level RR data and scale-level 
OASIS, DASS-21-AS, DASS-21-DS, and QOL data for 939 participants, but its source script is not in 
files from Julie. Nor is `Flexibility.RR.Sample.Total.csv` and its source script.

- `Flexibility.Paper.Analysis.Demog.Cronbach.21Jan2022.r`
  - Imports:
    - Some raw tables from **Set B** (`BBSIQ_02_02_2019.csv`, `OA_02_02_2019.csv`, 
    `DASS21_AS_02_02_2019.csv`, `DASS21_DS_02_02_2019.csv`, `QOL_02_02_2019.csv`, 
    `RR_02_02_2019.csv`, `MentalHealthHxTx_02_02_2019.csv`, `Demographics_02_02_2019.csv`)[^1]
    - Tables of unknown origin (**`R34_Flexibility_Claudia.csv`**, **`Flexibility.RR.Sample.Total.csv`**)
    - Table exported from script below (`Flexibility.BBSIQ.Sample.N899.17Mar2023.csv`)
  - Exports `Flexibility.FullList.Final.csv`
- `Flexibility.Paper.Analysis.29Jun2023.R`
  - Imports:
    - Raw table from **Set B** (`BBSIQ_02_02_2019.csv`)
    - Table of unknown origin (**`R34_Flexibility_Claudia.csv`**)
    - Table exported from script above (`Flexibility.FullList.Final.csv`)
  - Exports `Flexibility.BBSIQ.Sample.N899.17Mar2023.csv` and `Flexibility.RR.Sample.N8109.17Mar2023.csv`
- `Interp.Flexibility.Analysis_v2.Rmd`
  - HTML from this seems to be on the paper's [OSF project][ji-et-al-2024-osf]
  - Imports:
    - Raw table from **Set B** (`BBSIQ_02_02_2019.csv`)
    - Tables exported from script above (`Flexibility.BBSIQ.Sample.N899.17Mar2023.csv`, 
    `Flexibility.RR.Sample.N8109.17Mar2023.csv`)

<!-- Footnotes (Note: Each must be on one line to render correctly on GitHub Pages) -->

--- <!-- Horizontal rule for GitHub Pages -->

[^1]: With the exception of the demographics table, these tables are identical to those in Set B.
The demographics table has an extra `Income.Category` column and already has cleaned values for the 
`income` column. Otherwise, it's the same as the demographics table in Set B (sort them by `id`).

<!-- Reference Links -->

[claudia]: https://github.com/cpc4tz
[ji-et-al-2024]: https://doi.org/10.1177/20438087241226642
[ji-et-al-2024-osf]: https://osf.io/tq3p7/?view_only=33c0ace49fe04688bf37afa556fd072d