# Changelog

All notable changes to this project will be documented in this file. This project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v5.0.2 - _2023-03-07_
See [v5.0.2] changes

### Fixed
- Stop cerfiticate validation record duplication

## v5.0.1 - _2023-02-01_
See [v5.0.1] changes

### Fixed
- Removed the requirement to inject a API into the URL

## v5.0.0 - _2023-02-01_
See [v5.0.0] changes

### Added
- Infrastructure required to deploy new UI. It introduces two new variables. `ui_version=v5.0.0` the version of the static UI to download and `us_east_certificate_validation_arn` a new arn required to be created in `us-east-1` for Cloudfront. The following get's created
  - New S3 bucket to host static html files
  - Cloudfront hosting the API in ECS and the S3 static html files
  - Lambda edge function required for the html page routing
- Test clients are now created directly within the infrastructure

### Fixed
- Prevents ECS load balancer from getting deleted
- Removed inline policies in use
- Glue is allowed the PassRole access to allow for schema uploading
- S3 buckets now have SSL restrictions

## v4.2.0 - _2022-12-22_
See [v4.2.0] changes

### Added
- Configurable cognito password policy
- Cloudtrail creation is now optional and cloudtrail events are now consolidated into one trail

## v4.1.1 - _2022-11-23_
See [v4.1.1] changes

### Fixes
- Typo in organisation

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


[v5.0.1]: https://github.com/no10ds/rapid-infrastructure/compare/v5.0.0...HEAD
[v5.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v4.2.0...v5.0.0
[v4.2.0]: https://github.com/no10ds/rapid-infrastructure/compare/v4.1.0...v4.2.0
[v4.1.1]: https://github.com/no10ds/rapid-infrastructure/compare/v4.1.0...v4.1.1
[v4.1.0]: https://github.com/no10ds/rapid-infrastructure/compare/v4.0.0...v4.1.0
[v4.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v3.0.0...v4.0.0
[v3.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v2.0.0...v3.0.0
[v2.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/v1.3.0...v2.0.0
[v1.3.0]: https://github.com/no10ds/rapid-infrastructure/compare/v1.0.0...v1.3.0
[v1.0.0]: https://github.com/no10ds/rapid-infrastructure/compare/5298389...v1.0.0
