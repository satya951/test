terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIASZ7NEBVUH4IXFN25"
  secret_key = "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"
}