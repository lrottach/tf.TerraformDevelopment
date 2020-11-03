variable "resource_location" {
  type = string
  description = "The Azure region used to deploy resources"
  default = "switzerlandnorth"
}

variable "resource_tags" {
  type = map
  default = {
    Environment = "Production"
    CreatedBy = "lrottach@darkcontoso.io"
    CreatedOn = "03/11/2020"
  }
}