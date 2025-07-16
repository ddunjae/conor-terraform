terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  tenant_id       = "153f08bb-dab8-42cf-bc92-e02e110ca6aa"
  subscription_id = "f2b66090-fe4b-433b-b09a-804dbcfcce74"
  client_id       = "cf5ba3a6-8bf7-4ce0-bff0-d8246c980b46"
  client_secret   = "ZgW8Q~37biVbYqrfjAJTB.ZFszOtKvxakLmI0aio"

}
