resource "huaweicloud_identity_group" "hfa_iam_account_security" {
  name        = var.hfa_iam_acccount_security_group_name
  description = "Security Group in Central IAM Account allowing security operations in member account"
}

resource "huaweicloud_identity_role" "hfa_iam_account_security_group_allow_assumerole" {
  name = var.hfa_iam_acccount_security_group_name
  type = "AX"
  policy = jsonencode({
    "Version" : "1.1",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:agencies:assume"
        ],
        "Resource" : {
          "uri" : [
            "/iam/agencies/${module.security_account_iam.hfa_security_admin_agency_id}",
            "/iam/agencies/${module.transit_account_iam.hfa_security_admin_agency_id}",
            "/iam/agencies/${module.common_account_iam.hfa_security_admin_agency_id}",
            "/iam/agencies/${module.app_account_iam.hfa_security_admin_agency_id}",
            "/iam/agencies/${module.iam_account_iam.hfa_security_admin_agency_id}"
          ]
        }
      }
    ]
  })
  description = "Allowing Assume Role"
}

data "huaweicloud_identity_role" "iam_tenant_guest" {
  display_name = "Tenant Guest"
}

data "huaweicloud_identity_role" "iam_iam_readonly" {
  display_name = "IAM ReadOnlyAccess"
}

data "huaweicloud_identity_role" "iam_lts_fullaccess" {
  display_name = "LTS FullAccess"
}

data "huaweicloud_identity_role" "iam_cts_fullaccess" {
  display_name = "CTS FullAccess"
}

data "huaweicloud_identity_role" "iam_security_administrator" {
  display_name = "Security Administrator"
  name         = "secu_admin"
}

resource "huaweicloud_identity_group_role_assignment" "iam_account_security_allow_assumerole" {
  group_id   = huaweicloud_identity_group.hfa_iam_account_security.id
  role_id    = huaweicloud_identity_role.hfa_iam_account_security_group_allow_assumerole.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "iam_account_usergroup_tenantguest" {
  group_id   = huaweicloud_identity_group.hfa_iam_account_security.id
  role_id    = data.huaweicloud_identity_role.iam_tenant_guest.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "iam_account_usergroup_cts" {
  group_id   = huaweicloud_identity_group.hfa_iam_account_security.id
  role_id    = data.huaweicloud_identity_role.iam_cts_fullaccess.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "iam_account_usergroup_securityadmin" {
  group_id   = huaweicloud_identity_group.hfa_iam_account_security.id
  role_id    = data.huaweicloud_identity_role.iam_security_administrator.id
  project_id = "all"
}

output "hfa_iam_account_usergroup_security_id" {
  value = huaweicloud_identity_group.hfa_iam_account_security.id
}