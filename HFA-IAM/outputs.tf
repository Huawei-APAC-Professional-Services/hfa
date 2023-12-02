output "hfa_security_admin_agency_name" {
  value = var.hfa_security_admin_agency_name
}

output "hfa_network_admin_agency_name" {
  value = var.hfa_network_admin_agency_name
}

output "hfa_base_agency_name" {
  value = var.hfa_base_agency_name
}

output "hfa_main_region" {
  value = var.hfa_main_region
}

output "hfa_cts_log_transfer_agency_name" {
  value = var.hfa_cts_log_transfer_agency_name
}

output "hfa_all_accounts" {
  value = zipmap(
    [var.hfa_iam_account_name, var.hfa_security_account_name, var.hfa_transit_account_name, var.hfa_common_account_name, var.hfa_app_account_name],
    [module.iam_account_iam.hfa_account_id, module.security_account_iam.hfa_account_id, module.transit_account_iam.hfa_account_id, module.common_account_iam.hfa_account_id, module.app_account_iam.hfa_account_id]
  )
}

output "hfa_log_account_name" {
  value = local.hfa_log_account_name
}