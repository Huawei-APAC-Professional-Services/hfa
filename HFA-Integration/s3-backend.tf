terraform {
  backend "s3" {
    bucket                      = "hfa-terraform-state-now"
    key                         = "hfa-integration/terraform.tfstate"
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

data "terraform_remote_state" "hfa_iam" {
  backend = "s3"
  config = {
    bucket                      = "hfa-terraform-state-now"
    key                         = "hfa-iam/terraform.tfstate"
    region                      = "ap-southeast-3"
    endpoints = {
      s3 = "https://obs.ap-southeast-3.myhuaweicloud.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

data "terraform_remote_state" "hfa_network" {
  backend = "s3"
  config = {
    bucket                      = "hfa-terraform-state-now"
    key                         = "hfa-network/terraform.tfstate"
    region                      = "ap-southeast-3"
    endpoints = {
      s3 = "https://obs.ap-southeast-3.myhuaweicloud.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

data "terraform_remote_state" "hfa_app" {
  backend = "s3"
  config = {
    bucket                      = "terraform-state-singapore"
    key                         = "hfa-app/terraform.tfstate"
    region                      = "ap-southeast-3"
    endpoints = {
      s3 = "https://obs.ap-southeast-3.myhuaweicloud.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}