locals {
  hfa_accounts_id         = [for k, v in data.terraform_remote_state.hfa_iam.outputs.hfa_all_accounts : v]
  hfa_security_account_id = data.terraform_remote_state.hfa_iam.outputs.hfa_security_account_id

  config_aggregator_account_id = local.hfa_security_account_id
  config_member_account_ids    = [for account in local.hfa_accounts_id : account if account != local.config_aggregator_account_id]

  all_except_security_accounts = [for account in local.hfa_accounts_id : account if account != local.hfa_security_account_id]

  config_smn_topic_allow_accounts_list = join(",", [for account in local.hfa_accounts_id : "urn:csp:iam::${account}:root"])
}
