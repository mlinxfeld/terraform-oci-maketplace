resource "oci_core_instance" "FoggyKitchenRocketChat" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id = var.compartment_ocid
  display_name = "FoggyKitchenRocketChat"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
  source_details {
    source_type = "image"
    source_id = lookup(data.oci_core_app_catalog_listing_resource_version.FoggyKitchen_App_Catalog_Listing_Resource_Version, "listing_resource_id")
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
     assign_public_ip = true 
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenRocketChat_VNIC1_attach" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id = var.compartment_ocid
  instance_id = oci_core_instance.FoggyKitchenRocketChat.id
}

data "oci_core_vnic" "FoggyKitchenRocketChat_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenRocketChat_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenRocketChatPublicIP" {
   value = [data.oci_core_vnic.FoggyKitchenRocketChat_VNIC1.public_ip_address]
}
