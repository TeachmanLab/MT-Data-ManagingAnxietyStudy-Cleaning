# Citation

- [Version Numbers](#version-numbers)
- [GitHub Releases](#github-releases)
- [Zenodo DOIs](#zenodo-dois)
- [Acknowledgments](#acknowledgments)

## Version Numbers

This repo and associated [data](../README.md#data-on-osf) are versioned using the 
following adaptation of [SemVer](https://semver.org/). When a given version of the 
data are analyzed, the version of the cleaning code and data can be documented and 
cited, and prior versions can be found. This system was first used for 
[centralized cleaning for the Calm Thinking study][ct-cleaning-repo] 
([v1.0.1: Eberle et al., 2022][eberle-et-al-2022]).

Given a version number SCHEMA.CONTENT.SCRIPT (e.g., v1.0.0), increment the:

1. SCHEMA version when making incompatible changes that **affect the data schema**
   - Such changes *may break subsequent cleaning/analysis scripts*
     - Ex. Adding/removing/renaming table or column
     - Ex. Recoding/changing column meaning (e.g., adding/removing levels)

2. CONTENT version when making backwards-compatible changes that **affect the data content**
   - Such changes mean that *subsequent scripts should still run but may yield different results*
     - Ex. Adding/removing a row
     - Ex. Recoding certain cells of a variable using existing levels

3. SCRIPT version when making backwards-compatible changes that **do not affect the data schema or content**
   - Such changes mean that *subsequent scripts should still run and yield the same results*
     - Ex. Add functionality (e.g., perform new checks, highlight new issues) without changing data
     - Ex. Fix bugs (e.g., correct existing checks, clarify existing issues) without changing data

When the SCHEMA, CONTENT, or SCRIPT version is incremented, a new [tag][ma-cleaning-repo-tags] 
(e.g., "v1.0.0" is added to the repo).

When the SCHEMA or CONTENT version is incremented, a new version of the 
[data](../README.md#data-on-osf) is uploaded to OSF alongside the old version(s), 
with the ZIP file named based on the version number. There is no need to upload a 
new data version when the SCRIPT version is incremented.

## GitHub Releases

[Releases][ma-cleaning-repo-releases] are named based on the version of their corresponding 
[tag][ma-cleaning-repo-tags]. The date in the [Release Notes][ma-cleaning-repo-releases] is 
the date of the last committed change for that tag, and all changes in the release are 
bulleted in the Release Notes.

## Zenodo DOIs

### Version DOI

The [Zenodo integration with GitHub][zenodo-github] creates a new Version DOI each 
time a new GitHub release is created.

When using a given release of the cleaning code or associated [data](#data-on-osf), please 
cite the version number and Version DOI for the release. The Version DOI for a given release 
is in the [Release Notes][ma-cleaning-repo-releases]. **To get the full citation, click on 
the DOI badge in the [Release Notes][ma-cleaning-repo-releases] to go to that version's 
record on Zenodo, where the citation is in the Citation pane.**

### Concept DOI

Note: The Zenodo record for a given version will also contain a Concept DOI under 
"Cite all versions?" in the Versions pane of the Zenodo record. The Concept DOI 
represents all versions of the cleaning code and resulting data and will resolve 
to the latest Version DOI. Per [Zenodo guidance][zenodo-versioning], typically you should cite the 
[Version DOI](#version-doi). Cite the Concept DOI only "when it is desirable to 
cite an evolving research artifact, without being specific about the version."

## Acknowledgments

We thank [Sonia Baee][sonia] and [Claudia Calicho-Mamani][claudia] for their 
contributions to the initial cleaning for this study.

[claudia]: https://github.com/cpc4tz
[ct-cleaning-repo]: https://github.com/TeachmanLab/MT-Data-CalmThinkingStudy
[eberle-et-al-2022]: https://doi.org/10.5281/zenodo.6149365
[ma-cleaning-repo-releases]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/releases
[ma-cleaning-repo-tags]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/tags
[sonia]: https://github.com/soniabaee
[zenodo-github]: https://docs.github.com/en/repositories/archiving-a-github-repository/referencing-and-citing-content
[zenodo-versioning]: https://zenodo.org/help/versioning