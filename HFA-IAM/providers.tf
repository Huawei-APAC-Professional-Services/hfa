terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.60.0"
    }
  }
}

provider "huaweicloud" {
  region = var.hfa_main_region
}

provider "huaweicloud" {
  region = var.hfa_main_region
  alias  = "security"

  assume_role {
    agency_name = var.hfa_iam_base_agency_name
    domain_name = var.hfa_security_account_name
  }
}

provider "huaweicloud" {
  region = var.hfa_main_region
  alias  = "transit"

  assume_role {
    agency_name = var.hfa_iam_base_agency_name
    domain_name = var.hfa_transit_account_name
  }
}

provider "huaweicloud" {
  region = var.hfa_main_region
  alias  = "common"

  assume_role {
    agency_name = var.hfa_iam_base_agency_name
    domain_name = var.hfa_common_account_name
  }
}

provider "huaweicloud" {
  region = var.hfa_main_region
  alias  = "app"

  assume_role {
    agency_name = var.hfa_iam_base_agency_name
    domain_name = var.hfa_app_account_name
  }
}