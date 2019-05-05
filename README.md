# AWS Localstack setup using Terraform Step Functions and Lambda

This repository is a POC of building a fully local-emulated instance of Step Functions using Lambda Tasks inside a demonstrative Workflow.

## Setup

### Install Tools
 * install [Localstack](https://github.com/localstack/localstack) an AWS Local emulator.
 * install [Terraform](https://www.terraform.io/) an [IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) Technology.

### Start Localstack Service

In this case I prefer to use the "docker" way, because it will be useful if you need to integrate it into a CD/CI pipeline to perform some integration tests.

```bash
> LAMDBA_EXECUTOR=docker localstack start --docker
```

### Terraform 
```bash
> terraform init
> terraform apply -lock=false -auto-approve
```
