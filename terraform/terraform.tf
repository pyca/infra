terraform {
  backend "s3" {
    bucket                      = "terraform-states"
    key                         = "oke/terraform.tfstate"
    shared_credentials_file     = "bucket_credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
