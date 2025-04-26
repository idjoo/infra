terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region              = "ap-singapore-1"
  auth                = "SecurityToken"
  config_file_profile = "DEFAULT"
}

module "master" {
  source = "./master"

  compartment_id = var.compartment_id
}
