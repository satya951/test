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
  access_key = "AKIARWXJJP45NEUVPKHH"
  secret_key = "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"
}
