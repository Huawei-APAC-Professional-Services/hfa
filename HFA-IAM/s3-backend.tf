terraform {
  backend "s3" {
    bucket                      = "hfa-terraform-state-now"
    key                         = "hfa-iam/terraform.tfstate"
    region                      = "ap-southeast-3"
    endpoints = {
      s3 = "https://obs.ap-southeast-3.myhuaweicloud.com"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}