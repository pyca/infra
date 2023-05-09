variable "api_fingerprint" {
  default     = ""
  description = "Fingerprint of the API private key to use with OCI API."
  type        = string
}

variable "api_private_key_path" {
  default     = ""
  description = "The path to the OCI API private key."
  type        = string
}

variable "tenancy_id" {
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
  type        = string
  default     = ""
}

variable "user_id" {
  description = "The id of the user that terraform will use to create the resources."
  type        = string
  default     = ""
}

variable "compartment_id" {
  description = "The compartment id where to create all resources."
  type        = string
  default     = ""
}
variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The OCI region where OKE resources will be created."
  type        = string
}
variable "region_key" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The three letter code for the region where OKE resources will be created"
  type = string
}
variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}
variable "ssh_public_key" {
  description = "An SSH public key to put on the nodes for debug."
  type        = string
}
variable "availability_domain" {
  description = "The availability domain for the node"
  type        = string
}