resource "oci_core_vcn" "idjo_vcn_master" {
  compartment_id = var.compartment_id

  display_name = "idjo-vcn-master"

  cidr_blocks = [
    "10.0.0.0/16"
  ]

  dns_label = "idjo"
}

resource "oci_core_subnet" "idjo_subnet_private" {
  display_name = "idjo-subnet-private"

  compartment_id = var.compartment_id

  vcn_id         = oci_core_vcn.idjo_vcn_master.id
  route_table_id = oci_core_vcn.idjo_vcn_master.default_route_table_id

  cidr_block = "10.0.1.0/24"
  dns_label  = "private"
  security_list_ids = [
    oci_core_security_list.idjo_sl_private.id,
    oci_core_security_list.idjo_sl_private_nlb.id
  ]
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_security_list" "idjo_sl_private" {
  display_name = "idjo-sl-private"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.idjo_vcn_master.id

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "idjo_sl_private_nlb" {
  display_name = "idjo-sl-private-nlb"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.idjo_vcn_master.id

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 30000
      max = 32767
    }
  }
}

resource "oci_core_subnet" "idjo_subnet_public" {
  display_name = "idjo-subnet-public"

  compartment_id = var.compartment_id

  vcn_id         = oci_core_vcn.idjo_vcn_master.id
  route_table_id = oci_core_vcn.idjo_vcn_master.default_route_table_id

  cidr_block = "10.0.0.0/24"
  dns_label  = "public"
  security_list_ids = [
    oci_core_security_list.idjo_sl_public.id
  ]
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_security_list" "idjo_sl_public" {
  display_name = "idjo-sl-public"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.idjo_vcn_master.id

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
}
