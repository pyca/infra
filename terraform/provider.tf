provider "oci" {
  fingerprint  = var.api_fingerprint
  private_key  = file(var.api_private_key_path)
  region       = var.region
  tenancy_ocid = var.tenancy_id
  user_ocid    = var.user_id
}
