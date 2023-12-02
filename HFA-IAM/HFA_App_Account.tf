module "app_account_iam" {
  source                           = "github.com/Huawei-APAC-Professional-Services/terraform-module/hfa-iam"
  hfa_iam_account_name             = var.hfa_iam_account_name
  hfa_security_admin_agency_name   = var.hfa_security_admin_agency_name
  hfa_network_admin_agency_name    = var.hfa_network_admin_agency_name
  hfa_base_agency_name             = var.hfa_base_agency_name
  hfa_log_account_name             = local.hfa_log_account_name
  hfa_cts_log_transfer_agency_name = var.hfa_cts_log_transfer_agency_name
  providers = {
    huaweicloud = huaweicloud.app
  }
}

module "app_account_iam_baseline" {
  source = "github.com/Huawei-APAC-Professional-Services/terraform-module/hfa-iam-baseline"
  providers = {
    huaweicloud = huaweicloud.app
  }
}

output "hfa_app_account_name" {
  value = var.hfa_app_account_name
}

output "hfa_app_account_id" {
  value = module.app_account_iam.hfa_account_id
}