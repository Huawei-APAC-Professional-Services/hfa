terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.57.0"
    }
  }
}


# Need to set HW_ACCESS_KEY and HW_SECRET_KEY environment variables for default provider
# Default provider which will have access to Central IAM accounts, all ohter provider will be 
# assuming agency to access other accounts 
provider "huaweicloud" {
  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_app_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_app_sk
  region     = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
}

provider "huaweicloud" {
  region     = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias      = "app"
  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_app_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_app_sk
  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_app_admin_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_app_account_name
  }
}