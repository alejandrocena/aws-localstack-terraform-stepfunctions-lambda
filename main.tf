provider "aws" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    s3_force_path_style         = true
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
  role             = "rolo"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_three.output_base64sha256}"
  runtime          = "nodejs8.10"
  environment {
    variables = {
      foo = "bar"
    }
  }
}

/*

resource "aws_api_gateway_rest_api" "LocalDemoApi" {
  name        = "LocalDemoApi"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.LocalDemoApi.id}"
  parent_id   = "${aws_api_gateway_rest_api.LocalDemoApi.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.LocalDemoApi.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.LocalDemoApi.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.test_lambda.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.LocalDemoApi.id}"
  resource_id   = "${aws_api_gateway_rest_api.LocalDemoApi.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.LocalDemoApi.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.test_lambda.invoke_arn}"
}

*/