resource "oci_core_vcn" "idjo_vcn_master" {
  compartment_id = var.compartment_id

  display_name = "idjo-vcn-master"

  cidr_blocks = [
    "10.0.0.0/16"
  ]

  dns_label = "idjo"
}
