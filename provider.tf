# Declare the Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    #  azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "=3.0.0"
    # }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"

}


