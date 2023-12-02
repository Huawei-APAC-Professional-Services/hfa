resource "huaweicloud_identity_agency" "hfa_app_admin" {
  provider              = huaweicloud.app
  name                  = "hfa_app_admin"
  description           = "Manage all resources except network and security"
  delegated_domain_name = var.hfa_iam_account_name

  all_resources_roles = [
    "VPC ReadOnlyAccess",
    "CCI FullAccess",
    "ECS FullAccess",
    "EVS FullAccess",
    "ELB FullAccess"
  ]
}

resource "huaweicloud_identity_group" "hfa_iam_pipeline_app" {
  name        = var.hfa_iam_account_app_admin_group_name
  description = "app Group in Central IAM Account allowing app operations in member account"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_app_agnet_operator" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_app.id
  role_id    = data.huaweicloud_identity_role.agent_operator.id
  project_id = "all"
}

resource "huaweicloud_identity_user" "hfa_iam_pipeline_app" {
  name        = var.hfa_iam_account_pipeline_app_user_name
  description = "A IAM user for HFA APP Account operations"
  enabled     = true
  access_type = "programmatic"
  pwd_reset   = false
}

resource "huaweicloud_identity_group_membership" "hfa_iam_pipeline_app" {
  group = huaweicloud_identity_group.hfa_iam_pipeline_app.id
  users = [
    huaweicloud_identity_user.hfa_iam_pipeline_app.id
  ]
}

resource "huaweicloud_identity_access_key" "hfa_iam_pipeline_app" {
  user_id     = huaweicloud_identity_user.hfa_iam_pipeline_app.id
  secret_file = "/doesntexists/secrest"
}

output "hfa_iam_app_admin_agency_name" {
  value = huaweicloud_identity_agency.hfa_app_admin.name
}

output "hfa_iam_pipeline_app_ak" {
  value = huaweicloud_identity_access_key.hfa_iam_pipeline_app.id
}

output "hfa_iam_pipeline_app_sk" {
  sensitive = true
  value     = huaweicloud_identity_access_key.hfa_iam_pipeline_app.secret
}

