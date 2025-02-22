terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }

    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }

    archive = {
      source = "hashicorp/archive"
      version = "2.4.2"
    }
  }
}

provider "aws" {
  region = "<region>"
  profile = "default"
}

provider "tls" {
}

provider "local" {
}

provider "archive" {
}

data "aws_caller_identity" "caller" {
}