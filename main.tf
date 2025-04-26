terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = "DEFAULT"
  region              = "ap-singapore-1"
}

module "master" {
  source = "./master"

  compartment_id = var.compartment_id
}
