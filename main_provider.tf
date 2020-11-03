# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "remote" {
    organization = "dark-contoso"

    workspaces {
      name = "terraform-development"
    }
  }
}