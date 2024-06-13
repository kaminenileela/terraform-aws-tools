terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.48.0"
      }
    }

    backend "s3" {
        bucket = "leela-expense-remote-state"
        key = "jenkins"
        region = "us-east-1"
        dynamodb_table = "expense-dynamo-locking"

    }
}

provider "aws" {
    
    region = "us-east-1"
}