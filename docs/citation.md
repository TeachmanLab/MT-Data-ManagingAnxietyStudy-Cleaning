# Citation

## Versioning

This repository and associated [data](../README.md#data-on-osf) are versioned using 
the following adaptation of [SemVer](https://semver.org/). When a given version of 
the data are analyzed, the version of the cleaning scripts and data can be documented 
and cited, and previous versions can be found by version number.

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

When the SCHEMA, CONTENT, or SCRIPT version is incremented, a new [tag][tags] 
(e.g., "v1.0.0" is added to the repo).

When the SCHEMA or CONTENT version is incremented, a new version of the 
[data](../README.md#data-on-osf) is uploaded to OSF alongside the old version(s), 
with the ZIP file named based on the version number. There is no need to upload a 
new data version when the SCRIPT version is incremented.

## GitHub Releases

Releases are named based on the version of their corresponding tag. The date in the 
[Release Notes][ma-cleaning-releases] is the date of the last committed change for 
that tag, and all changes in the release are bulleted in the Release Notes.

For example, [release 1.0.0][ma-cleaning-release-v1.0.0] is for tag v1.0.0. Although 
the release itself was created on **TODO: YYYY-MM-DD**, the date of the last commit 
was **TODO: YYYY-MM-DD**.

## Zenodo DOIs

### Version DOI

The [Zenodo integration with GitHub][zenodo-github] creates a new Version DOI each 
time a new GitHub release is created.

When using the cleaning scripts or resulting data, please cite the Version DOI for 
the version of the scripts and data used. The Version DOI for a given release is in 
the [Release Notes][ma-cleaning-releases].

For example, to cite [release 1.0.0][ma-cleaning-release-v1.0.0], use the citation 
in the Share pane of the [Zenodo record for release 1.0.0][zenodo-v1.0.0].

### Concept DOI

The following Concept DOI represents all versions of the cleaning scripts and resulting 
datasets and will resolve to the latest Version DOI.

Per **TODO: [Zenodo guidance](https://help.zenodo.org/#versioning)**, typically you should 
cite the [Version DOI](#version-doi). Cite the Concept DOI only "when it is desirable to 
cite an evolving research artifact, without being specific about the version."

**TODO: Update badge below**
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6149365.svg)](https://doi.org/10.5281/zenodo.6149365)

## Acknowledgments

We thank [Sonia Baee][sonia] and [Claudia Calicho-Mamani][claudia] for their 
contributions to the initial cleaning for this study.

[claudia]: https://github.com/cpc4tz
[ma-cleaning-releases]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/releases
[ma-cleaning-release-v1.0.0]: https://github.com/TeachmanLab/MT-Data-ManagingAnxietyStudy-Cleaning/releases/tag/v1.0.0
[sonia]: https://github.com/soniabaee
[tags]: https://docs.github.com/en/repositories/releasing-projects-on-github/viewing-your-repositorys-releases-and-tags
[zenodo-github]: https://docs.github.com/en/repositories/archiving-a-github-repository/referencing-and-citing-content
[zenodo-v1.0.0]: **TODO**