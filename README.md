# Getting started with Terraform and Azure

Personal notes containing my experience and learnings ... about Terraform development and deployment.

## Documentation

+ [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
+ [Azure Getting Started](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/azure-get-started)
+ [Terraform Documentation](https://www.terraform.io/docs/index.html)

## Commands

Using Azure CLI to authenticate against Microsoft Azure.
```bash=a
az login
```

Create a dedicated directory which contains all of the Terraform files.
Create the initial main.tf file which initiates the required provider and deploys a Azure Resource Group.

```json=
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

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}
```

Initialize the Terraform directory using the following command.
```bash=a
terraform init
```

Generate the execution plan using the following command.
```bash=a
terraform plan
```

The output of that command will show what exactly Terraform will do to achieve the planned infrastructure.
```bash=
+ create: Marks resources which will be created during deployment
- delete: Indicates resources which will be deleted
~ update: Resources which will be changed
```


To apply the planned changes and deploy the Azure resources run the following command
```bash=a
terraform apply
```

All of the generated data will be written to a file called terraform.tfstate. Note: The state file could contain sensitive information. Make sure to exclude it from any kind of source control (Tipp: [gitignore.io](https://www.toptal.com/developers/gitignore)).
The state could be reviewed using the `terraform show` command.
