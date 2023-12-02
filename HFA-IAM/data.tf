locals {
  hfa_log_account_name = var.hfa_security_account_name
}

// This file fetch all system defined role data
data "huaweicloud_identity_role" "readonly" {
  display_name = "IAM ReadOnlyAccess"
}

data "huaweicloud_identity_role" "cts_administrator" {
  display_name = "CTS Administrator"
}

data "huaweicloud_identity_role" "obs_administrator" {
  display_name = "OBS Administrator"
}

data "huaweicloud_identity_role" "smn_fullaccess" {
  display_name = "SMN FullAccess"
}

data "huaweicloud_identity_role" "rms_fullaccess" {
  display_name = "RMS FullAccess"
}

data "huaweicloud_identity_role" "agent_operator" {
  display_name = "Agent Operator"
}