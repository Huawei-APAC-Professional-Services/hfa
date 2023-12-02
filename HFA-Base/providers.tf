terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.57.0"
    }
  }
}

#
# Need to set HW_ACCESS_KEY and HW_SECRET_KEY environment variables for default provider
provider "huaweicloud" {
  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_network_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_network_sk
  region     = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
}

provider "huaweicloud" {
  region = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias  = "iam"

  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_sk

  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_base_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_account_name
  }
}

provider "huaweicloud" {
  region = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias  = "security"

  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_sk

  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_base_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_security_account_name
  }
}

provider "huaweicloud" {
  region = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias  = "app"

  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_sk

  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_base_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_app_account_name
  }
}

provider "huaweicloud" {
  region = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias  = "transit"

  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_sk

  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_base_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_transit_account_name
  }
}

provider "huaweicloud" {
  region = data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  alias  = "common"

  access_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_ak
  secret_key = data.terraform_remote_state.hfa_iam.outputs.hfa_iam_pipeline_base_sk

  assume_role {
    agency_name = data.terraform_remote_state.hfa_iam.outputs.hfa_base_agency_name
    domain_name = data.terraform_remote_state.hfa_iam.outputs.hfa_common_account_name
  }
}

