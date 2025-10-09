# Data Notes

These notes focus on comparing the clean data from the main outcomes paper 
(`R34_FinalData_New_v02.csv`) and Sets A and B for the tables of interest. Sets A 
and B also have other tables not listed here. Although the clean item-level baseline 
data from the main outcomes paper (`R34_Cronbach.csv`) is mentioned at one point 
below, these notes do not otherwise discuss comparisons with it.

## Clean Data From Main Outcomes Paper

- **General**
  - This is `R34_FinalData_New_v02.csv` and referred to in the present notes as "clean data"
  - Has 807 participants (no test accounts)
  - Has different numbers of rows than Sets A and B (see below)
- **Participant data**
  - Limited to CBM and imagery prime conditions
- **Demographics data**
  - Has more `NA`s for birth year than Sets A and B, weird values for education, 
  and some blanks for most items
- **BBSIQ data**
- **DASS-21-AS data**
- **DASS-21-DS data**
- **OASIS data**
  - 111 participants without multiple entries have one session skipped in OASIS 
  table (see Set A below)
- **RR data**
- **No credibility or Task Log data**

## Raw Set A

- **General**
  - Has more tables than Set B (including those, e.g., `participant`, likely from other server)
  - Has some 344-character `participantRSA` values, some of which are in `R34_cleaning_script.R`
    - Some values remain after correcting the known values
  - Is more similar than Set B to tables loaded and described in `R34.ipynb`
    - Has similar file names and same names of participant ID columns as `R34.ipynb`
    - But has fewer participants than `R34.ipynb` (so data are different), except for `demographic`
    and `task_log` tables (which have same number of participants):
      ```text
      > set_a_vs_r34.ipynb_Ns
      bbsiq   dass21_as   dass21_ds demographic          oa participant          rr    task_log 
         -1         -61          -1           0         -44         -61          -1           0
      ```
  - Has unexpected multiple entries in `dass21_as` (all are multiple screening attempts), 
  `oa`, and `task_log` (involving both `suds` and other tasks) tables
  - After restricting to shared participants in each table, Set A has more rows
  in some tables and fewer rows in others (especially for `oa`) than clean data:
    ```text
    > set_a_vs_cln_nrow
                           set_a clean diff
    bbsiq                   1234  1233    1
    dass21_as                871   875   -4
    dass21_ds               1175  1174    1
    demographic              807   807    0
    oa                      2574  2592  -18
    participant_export_dao   771   771    0
    rr                      1186  1185    1
    ```
- **Participant table**
  - Missing 36 participants in clean data listed as excluded from original analyses
  due to server error
    - Also missing in DASS-21-AS and OA tables in Set A but have DASS-21-AS and OA data in Set B
      - And their baseline DASS-21-AS and OA data in Set B matches that in `R34_Cronbach.csv`
      file on main outcomes paper OSF project
    - These participants have the same number of rows in other tables in Sets A and B
  - Otherwise, CBM condition is same as in clean data
- **Demographics table**
  - For birth year, has more weird values than Set B and fewer `NA`s than clean data
  - Otherwise identical to Set B
- **BBSIQ table**
  - Matches scores in clean data
- **DASS-21-AS table**
  - Has `sessionId`, and session column at screening has both `ELIGIBLE` and blank values
  - Matches scores in clean data
- **DASS-21-DS table**
  - Matches scores in clean data
- **OASIS table**
  - Matches scores in clean data after handling multiple entries for 41 participants 
  (all of which in Set A were missing a session and had two entries for another session)
    - Rather than keeping most recent entry, this was done by sorting each participant's 
    OASIS entries chronologically and then recoding per the expected session order for the 
    number of entries present
    - (e.g., [MT-Data-ManagingAnxietyStudy][ma-repo] Issues [1][ma-repo-issue1] and 
    [2][ma-repo-issue2])
  - But 111 others without multiple entries have one session skipped in OASIS table 
  (and in clean OASIS data)
    - 109 have S1 skipped, and 2 have S3 skipped
    - As a result, session dates in OASIS table are inconsistent with those in 
    RR table for 12 participants
      - (18 other participants have different [but not inconsistent] dates for other reasons)
    - Sessions in OASIS table differ from those for OASIS entries in Task Log table,
    unless sessions in OASIS table are recoded to be consecutive
      - In Set B, the session values in OASIS table seem to have been recoded to be consecutive
    - Seems implausible that, per sessions in OASIS table, in many cases S2 OASIS 
    was completed a few min after pretx OASIS. Seems more plausible that S1 OASIS 
    was completed a few min after pretx OASIS.
      - (Participants could start S1 right after pretx but had to wait 2 days after
      completing S1 to start S2)
- **RR table**
  - Matches scores in clean data
- **Credibility table**
  - Matches Set B
- **Task Log table**
  - Has `corrected_datetime` in addition to `date`
  - Has discrepancies between `session` and date-related values (inc. `corrected_datetime`)
  in this table versus `session` and `date` in other tables in both Sets A and B
    - In part because multiple entries and skipped sessions in Set A OASIS table haven't been 
    handled yet

## Raw Set B

- **General**
  - Has no 344-character `participantRSA` values
  - Is less similar than Set A to tables loaded and described in `R34.ipynb`
    - Has different file names and some different names of participant ID columns
    than `R34.ipynb`
    - Has far fewer participants than `R34.ipynb`:
      ```text
      > set_b_vs_r34.ipynb_Ns
      bbsiq   dass21_as   dass21_ds demographic          oa          rr 
       -436        -434        -435        -436        -434        -429
      ```
  - Has no unexpected multiple entries
  - After restricting to shared participants in each table, Set B has more rows in some 
  tables and fewer rows in others (especially for `dass21_as`) than clean data:
    ```text
    > set_b_vs_cln_nrow
                set_b clean diff
    bbsiq        1233  1233    0
    dass21_as     807   913 -106
    dass21_ds    1174  1174    0
    demographic   807   807    0
    oa           2661  2679  -18
    rr           1185  1185    0
    ```
  - Although `imagery_prime` table has `prime` condition, no table has CBM condition
    - Perhaps could be derived from `trial_dao` table by computing proportion of
    positive scenarios (see `positive` column)
- **No participant table**
- **Demographics table**
  - For birth year, has fewer weird values than Set A and fewer `NA`s than clean data
  - Otherwise identical to Set A
- **BBSIQ table**
  - Matches scores in clean data
- **DASS-21-AS table**
  - Lacks `sessionId`, and session column at screening has only `ELIGIBLE` values
  - 58 participants (not in Set A and including all 36 listed as excluded from original 
  analyses due to server error but now in clean data) have dates that are 11:14 characters
  - Matches scores in clean data
- **DASS-21-DS table**
  - Matches scores in clean data
- **OASIS table**
  - 42 participants (not in Set A and including all 36 noted above) have dates that are 
  11:14 characters
  - No participants have skipped sessions in OASIS table
    - As a result, after restricting to shared participants in clean OASIS data, 
    total scores seem discrepant for 24 participants. However, in each case the 
    total scores are the same, but sessions are mismatched.
      - All these participants are in the 109 participants in Set A with skipped 
      S1 in OASIS table. Clean OASIS data also skips S1 (lists S2 instead), whereas 
      Set B OASIS table lists consecutive sessions.
    - Unlike in Set A, session dates in OASIS table are consistent with those in RR table,
    and sessions in Set B OASIS table are identical to those for OASIS entries in 
    Set A Task Log table
- **RR table**
  - Matches scores in clean data
- **Credibility table**
  - Matches Set A
- **No Task Log table**

[ma-repo]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy
[ma-repo-issue1]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/1#issue-403285089
[ma-repo-issue2]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/2#issue-403285690
[ma-repo-issue9]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/9#issue-3457953028
[ma-repo-issue10]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy/issues/10#issue-3458115537