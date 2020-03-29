terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket  = "infra.vince"
    encrypt = "true"
  }
}

provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = var.role_arns[var.app_env]
  }
}

data "aws_iam_policy" "lambda_basic_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "lambda_vpc_access_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_caller_identity" "caller_identity" {}

