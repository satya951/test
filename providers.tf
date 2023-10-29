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
  access_key = "AKIARWXJJP45NMI5KLSN"
  secret_key = "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"
}
