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

## How it Works

#### Localstack
LocalStack spins up the following core Cloud APIs on your local machine

 * **API Gateway** at http://localhost:4567
 * **Kinesis** at http://localhost:4568
 * **DynamoDB** at http://localhost:4569
 * **DynamoDB Streams** at http://localhost:4570
 * **Elasticsearch** at http://localhost:4571
 * **S3** at http://localhost:4572
 * **Firehose** at http://localhost:4573
 * **Lambda** at http://localhost:4574
 * **SNS** at http://localhost:4575
 * **SQS** at http://localhost:4576
 * **Redshift** at http://localhost:4577
 * **ES** (Elasticsearch Service) at http://localhost:4578
 * **SES** at http://localhost:4579
 * **Route53* at http://localhost:4580
 * **CloudFormation** at http://localhost:4581
 * **CloudWatch** at http://localhost:4582
 * **SSM** at http://localhost:4583
 * **SecretsManager** at http://localhost:4584
 * **StepFunctions** at http://localhost:4585
 * **CloudWatch** Logs at http://localhost:4586
 * **STS** at http://localhost:4592
 * **IAM** at http://localhost:4593



#### Terraform
With Terraform this example uses the [AWS Custom Provider Endpoints](https://github.com/terraform-providers/terraform-provider-openstack/pull/501) feature that allow us to override all the default provider endpoints with my emulated ones. So that is when things start working together.

Terraform AWS Provider Version should be grater than "2.9.0" because of this compatibility [Issue](https://github.com/terraform-providers/terraform-provider-aws/pull/8467)

Some other settings are for prevent some unwanted incompatibilities during emulation.

```terraform
provider "aws" {
  version = ">2.9.0"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  endpoints {
    ses = "http://localhost:4579"
    cloudwatchlogs = "http://localhost:4586"
    redshift = "http://localhost:4577"
    cloudformation = "http://localhost:4581"
    firehose = "http://localhost:4573"
    route53 = "http://localhost:4580"
    es = "http://localhost:4578"
    iam = "http://localhost:4593"
    dynamodb = "http://localhost:4570"
    s3 = "http://localhost:4572"
    cloudwatch = "http://localhost:4582"
    dynamodb = "http://localhost:4569"
    kinesis = "http://localhost:4568"
    sqs = "http://localhost:4576"
    ssm = "http://localhost:4583"
    sns = "http://localhost:4575"
    apigateway = "http://localhost:4567"
    secretsmanager = "http://localhost:4584"
    sts = "http://localhost:4592"
    stepfunctions = "http://localhost:4585"
    lambda = "http://localhost:4574"
  }
}
```
