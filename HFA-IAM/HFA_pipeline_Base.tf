// This IAM group has necessary permissions for Base Level execution
resource "huaweicloud_identity_group" "hfa_iam_pipeline_base" {
  name        = var.hfa_iam_account_pipeline_base_group_name
  description = "Allow apply HFA-Base module"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_base_agent_operator" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_role.agent_operator.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_iamread" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_role.readonly.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_ctsadmin" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_role.cts_administrator.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_obsadmin" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_role.obs_administrator.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_smnadmin" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_role.smn_fullaccess.id
  project_id = "all"
}

resource "huaweicloud_identity_user" "hfa_iam_pipeline_base" {
  name        = var.hfa_iam_account_pipeline_base_user_name
  description = "A IAM user for HFA-Base module"
  enabled     = true
  access_type = "programmatic"
  pwd_reset   = false
}

resource "huaweicloud_identity_group_membership" "hfa_iam_pipeline_base" {
  group = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  users = [
    huaweicloud_identity_user.hfa_iam_pipeline_base.id
  ]
}

resource "huaweicloud_identity_access_key" "hfa_iam_pipeline_base" {
  user_id     = huaweicloud_identity_user.hfa_iam_pipeline_base.id
  secret_file = "/doesntexists/secrest"
}


output "hfa_iam_pipeline_base_ak" {
  value = huaweicloud_identity_access_key.hfa_iam_pipeline_base.id
}

output "hfa_iam_pipeline_base_sk" {
  sensitive = true
  value     = huaweicloud_identity_access_key.hfa_iam_pipeline_base.secret
}