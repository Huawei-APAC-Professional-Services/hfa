terraform {
  backend "s3" {}
}

data "terraform_remote_state" "hfa_iam" {
  backend = "s3"
  config = {
    bucket                      = var.hfa_terraform_state_bucket
    key                         = var.hfa_iam_state_key
    region                      = var.hfa_terraform_state_region
    endpoint                    = var.hfa_terraform_state_obs_endpoint
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}