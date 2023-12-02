resource "huaweicloud_identity_group" "hfa_iam_pipeline_integration" {
  name        = var.hfa_iam_account_pipeline_integration_group_name
  description = "Integration Group in Central IAM Account allowing integrate separated resource together"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_integration_agent_operator" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_integration.id
  role_id    = data.huaweicloud_identity_role.agent_operator.id
  project_id = "all"
}

resource "huaweicloud_identity_user" "hfa_iam_pipeline_integration" {
  name        = var.hfa_iam_account_pipeline_integration_user_name
  description = "A IAM user for HFA network operations"
  enabled     = true
  access_type = "programmatic"
  pwd_reset   = false
}

resource "huaweicloud_identity_group_membership" "hfa_iam_pipeline_integration" {
  group = huaweicloud_identity_group.hfa_iam_pipeline_integration.id
  users = [
    huaweicloud_identity_user.hfa_iam_pipeline_integration.id
  ]
}

resource "huaweicloud_identity_access_key" "hfa_iam_pipeline_integration" {
  user_id     = huaweicloud_identity_user.hfa_iam_pipeline_integration.id
  secret_file = "/doesntexists/secrest"
}

output "hfa_iam_pipeline_integration_ak" {
  value = huaweicloud_identity_access_key.hfa_iam_pipeline_integration.id
}

output "hfa_iam_pipeline_integration_sk" {
  sensitive = true
  value     = huaweicloud_identity_access_key.hfa_iam_pipeline_integration.secret
}