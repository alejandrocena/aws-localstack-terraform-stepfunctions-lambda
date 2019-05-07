
provider "aws" {
  version = ">=2.9.0"
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

data "archive_file" "lambda_one" {
    type          = "zip"
    source_dir    = "src/lambda-one"
    output_path   = "lambda-one.zip"
}

resource "aws_lambda_function" "lambda_one" {
  filename         = "lambda-one.zip"
  function_name    = "lambda-one"
  role             = "rolo"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_one.output_base64sha256}"
  runtime          = "nodejs8.10"
  environment {
    variables = {
      foo = "bar"
    }
  }
}


data "archive_file" "lambda_two" {
    type          = "zip"
    source_dir    = "src/lambda-two"
    output_path   = "lambda-two.zip"
}

resource "aws_lambda_function" "lambda_two" {
  filename         = "lambda-two.zip"
  function_name    = "lambda-two"
  role             = "rolo"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_two.output_base64sha256}"
  runtime          = "nodejs8.10"
  environment {
    variables = {
      foo = "bar"
    }
  }
}

data "archive_file" "lambda_three" {
    type          = "zip"
    source_dir    = "src/lambda-three"
    output_path   = "lambda-three.zip"
}

resource "aws_lambda_function" "lambda_three" {
  filename         = "lambda-three.zip"
  function_name    = "lambda-three"
  role         = "rolo"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_three.output_base64sha256}"
  runtime          = "nodejs8.10"
  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_sfn_state_machine" "all_ok_saga" {
  name     = "all_ok_saga"
  role_arn     = "arn:aws:iam::123123123123:role/some_role",

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "StepOne",
  "States": {
    "StepOne": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_one.arn}",
      "Catch": [        
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.StepOneError",
          "Next": "StepOne"
        }
      ],
      "ResultPath": "$.StepOneResult",
      "Next":"StepTwo"
    },
    "StepTwo": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_two.arn}",
      "Catch": [        
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.StepTwoError",
          "Next": "StepTwo"
        }
      ],
      "ResultPath": "$.StepTwoResult",
      "Next":"StepThree"
    },
    "StepThree": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_three.arn}",
      "Catch": [        
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.StepThreeError",
          "Next": "StepThree"
        }
      ],
      "ResultPath": "$.StepThreeResult",
      "End": true
    }
  }
}
EOF
}
