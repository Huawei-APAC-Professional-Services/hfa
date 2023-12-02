resource "huaweicloud_identity_group" "hfa_iam_pipeline_network" {
  name        = var.hfa_iam_account_pipeline_network_group_name
  description = "network Group in Central IAM Account allowing network operations in member account"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_network_agent_operator" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_network.id
  role_id    = data.huaweicloud_identity_role.agent_operator.id
  project_id = "all"
}

resource "huaweicloud_identity_user" "hfa_iam_pipeline_network" {
  name        = var.hfa_iam_account_pipeline_network_user_name
  description = "A IAM user for HFA network operations"
  enabled     = true
  access_type = "programmatic"
  pwd_reset   = false
}

resource "huaweicloud_identity_group_membership" "hfa_iam_pipeline_network" {
  group = huaweicloud_identity_group.hfa_iam_pipeline_network.id
  users = [
    huaweicloud_identity_user.hfa_iam_pipeline_network.id
  ]
}

resource "huaweicloud_identity_access_key" "hfa_iam_pipeline_network" {
  user_id     = huaweicloud_identity_user.hfa_iam_pipeline_network.id
  secret_file = "/doesntexists/secrest"
}

output "hfa_iam_pipeline_network_ak" {
  value = huaweicloud_identity_access_key.hfa_iam_pipeline_network.id
}

output "hfa_iam_pipeline_network_sk" {
  sensitive = true
  value     = huaweicloud_identity_access_key.hfa_iam_pipeline_network.secret
}