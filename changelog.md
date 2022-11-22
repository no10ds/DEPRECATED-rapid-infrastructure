# Changelog

All notable changes to this project will be documented in this file. This project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v4.1.0 - _2022-11-20_
See [v4.1.0] changes

### Added
- Read in optional project details for CDDo federated API model
- New global secondary index column for jobs DynamoDB table

## v4.0.0 - _2022-09-21_
See [v4.0.0] changes

### Fixed
- Query results expiry time

### Added
- DynamoDB resource for job status management

## v3.0.0 - _2022-08-26_

See [v3.0.0] changes

### Fixed
- Oversized requests handling

### Added
- Lifecycle policy to ECR

### Changed
- Allow service task to delete parquet files

### Removed
- Custom csv classifier

## v2.0.0 - _2022-08-19_

See [v2.0.0] changes

### Added
- DynamoDB resources for new authorisation structure

### Removed
- Custom permission scopes

### Security
- Handle oversized requests in WAF manually until terraform is updated

## v1.3.0 - _2022-07-25_

See [v1.3.0] changes

### Added
- Documentation and usage guides can be found [here](https://github.com/no10ds/rapid-infrastructure/tree/master/docs)
- First full application release
- Features:
  - Build rapid infrastructure
  - Add release mechanism see [release](https://github.com/no10ds/rapid-infrastructure/blob/main/docs/guides/contributing.md#releasing)

## v1.0.0 - _2022-07-20_

See [v1.0.0] changes

### Added
- Documentation and usage guides can be found [here](https://github.com/no10ds/rapid-infrastructure/tree/master/docs)
- First full application release
- Features:
  - Build rapid infrastructure

[Unreleased changes]: https://github.com/no10ds/rapid-infrastructure/compare/v4.1.0...HEAD
[v4.1.0]: https://github.com/no10ds/rapid-infrastructure/compare/v4.0.0...v4.1.0
[v4.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v3.0.0...v4.0.0
[v3.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v2.0.0...v3.0.0
[v2.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v1.3.0...v2.0.0
[v1.3.0]: https://github.com/no10ds/rapid-infrastructure/compare/v1.0.0...v1.3.0
[v1.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/5298389...v1.0.0
