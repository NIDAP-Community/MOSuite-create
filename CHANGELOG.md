# CodeOcean Capsule - MOSuite - create multiOmicDataset

## development version

- Throw a warning if multiple counts files or metadata files are found matching the patterns. (#6, @kelly-sovacool)
- The results file is now saved to `results/moo/moo-raw.rds` to prevent collisions with other capsules. (#6, @kelly-sovacool)
- The MOSuite package is now available in `code/MOSuite`. (#7)
- Use MOSuite v0.3.1.

## v6.0

- Use MOSuite v0.3.0 docker container.

## v5.0

- The output multiOmicDataSet RDS file is now saved to a subdirectory (`results/moo/moo.rds`) for easier re-use as a data asset.

<https://poc-nci.codeocean.io/capsule/6541445/tree/v5> (`4174472`)

## v4.0

Report data files found for debugging purposes.

<https://poc-nci.codeocean.io/capsule/6541445/tree/v3> (`37f3c43`)

## v3.0

Removed counts file & input file parameters -- they are instead found via regex patterns in the data directory.

<https://poc-nci.codeocean.io/capsule/6541445/tree/v3> (`04aa57b`)

## v2.0

This release is identical to v1.0, except it is a Standard app rather than a No-Code app.

<https://poc-nci.codeocean.io/capsule/6541445/tree/v2> (`a332cc8`)

## v1.0

First release of MOSuite-create as a No-Code app.

<https://poc-nci.codeocean.io/capsule/6541445/tree/v1> (`a332cc8`)