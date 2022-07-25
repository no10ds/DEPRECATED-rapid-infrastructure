# Contributing

Guides for developing in this repository

## Initial setup

Configure the custom git hooks location with `make init-hooks`

You will also need to install [terraform-docs](https://terraform-docs.io/). This can be done with: `brew install terraform-docs`.

## Service Images

We have enabled lifecycle management for the rAPId service images in ECR, [ecr](../../blocks/ecr/main.tf). Our rules:

- Maintain up to 10 images that contain a version.
- Maintain up to 3 images that do not contain versions.

To change the lifecycle please follow
the [AWS Docs](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html) on lifecycle policies.

## Secrets

We are using the python package [detect-secrets](https://github.com/Yelp/detect-secrets) to analyse all files tracked by
git for anything that looks like a secret that might be at risk of being committed.

Secrets detection is run at pre-commit with a custom hook.

There is a `.secrets.baseline` file that defines any secrets (and their location) that were found in the repo, which are
not deemed a risk and ignored (e.g.: false positives)

To check the repo for secrets during development run `make detect-secrets`. This compares any detected secrets with the
baseline files and throws an error if a new one is found.

⚠️ Firstly, REMOVE ANY SECRETS!

However, if the scan incorrectly detects a secret run: `make ignore-secrets` to update the baseline file. **This file
should be added and committed**.

## Clean up

To clean up all the infra blocks just run `make destroy block={block-to-destroy}`

To clean the dynamically created resources follow [this guide](clean_up_dynamically_created_resources.md)


## Releasing

The guide for how to perform a release of the service image.

### Context

The product of the rAPId team is the service image that departments can pull and run in their own infrastructure.

Performing a release fundamentally involves tagging the image of a version of the service with a specific version number
so that departments can reference the version that 

### Prerequisites

- Download the GitHub CLI with `brew install gh`
- Then run `gh auth login` and follow steps

### Steps

1. Decide on the new version number following the [semantic versioning approach](https://semver.org/)
2. Update and commit the [Changelog](../../../changelog.md) (you can follow
   the [template](../../../changelog_release_template.md))
3. Run `make release commit=<commit_hash> version=vX.X.X`


Now the release pipeline will run automatically, build the image off that version of the code, tag it and push it to ECR
