data "huaweicloud_identity_custom_role" "hfa_state_kms" {
  name = "hfa_terraform_kms"
}

// HFA-Base
resource "huaweicloud_identity_group" "hfa_iam_pipeline_base" {
  name        = var.hfa_iam_account_pipeline_base_group_name
  description = "Allow apply HFA-Base module"
}

resource "huaweicloud_identity_role" "hfa_iam_pipeline_base" {
  name = huaweicloud_identity_group.hfa_iam_pipeline_base.name
  type = "AX"
  policy = jsonencode({
    "Version" : "1.1",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:agencies:assume",
          "iam:tokens:assume"
        ],
        "Resource" : {
          "uri" : [
            "/iam/agencies/${module.security_account_iam.hfa_base_agency_id}",
            "/iam/agencies/${module.transit_account_iam.hfa_base_agency_id}",
            "/iam/agencies/${module.common_account_iam.hfa_base_agency_id}",
            "/iam/agencies/${module.app_account_iam.hfa_base_agency_id}",
            "/iam/agencies/${module.iam_account_iam.hfa_base_agency_id}"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_iam_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:AbortMultipartUpload",
          "obs:object:DeleteObject",
          "obs:object:PutObject",
          "obs:object:ModifyObjectMetaData",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_base_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:bucket:HeadBucket",
          "obs:bucket:ListBucket"
        ]
        "Resource" : [
          "OBS:*:*:bucket:${var.hfa_terraform_state_bucket}"
        ]
      }
    ]
  })
  description = "Allowing Assume Role and access state file"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = huaweicloud_identity_role.hfa_iam_pipeline_base.id
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

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_kms" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_custom_role.hfa_state_kms.id
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

// HFA-Network
resource "huaweicloud_identity_group" "hfa_iam_pipeline_network" {
  name        = var.hfa_iam_account_pipeline_network_group_name
  description = "network Group in Central IAM Account allowing network operations in member account"
}

resource "huaweicloud_identity_role" "hfa_iam_pipeline_network" {
  name = huaweicloud_identity_group.hfa_iam_pipeline_network.name
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
            "/iam/agencies/${module.security_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.transit_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.common_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.app_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.iam_account_iam.hfa_network_admin_agency_id}"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_iam_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_app_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:AbortMultipartUpload",
          "obs:object:DeleteObject",
          "obs:object:PutObject",
          "obs:object:ModifyObjectMetaData",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_workloads_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:bucket:HeadBucket",
          "obs:bucket:ListBucket"
        ]
        "Resource" : [
          "OBS:*:*:bucket:${var.hfa_terraform_state_bucket}"
        ]
      }
    ]
  })
  description = "Allowing Assume Role and access state file"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_network" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_network.id
  role_id    = huaweicloud_identity_role.hfa_iam_pipeline_network.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_network_kms" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_network.id
  role_id    = data.huaweicloud_identity_custom_role.hfa_state_kms.id
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

// HFA-Integration
resource "huaweicloud_identity_group" "hfa_iam_pipeline_integration" {
  name        = var.hfa_iam_account_pipeline_integration_group_name
  description = "Integration Group in Central IAM Account allowing integrate separated resource together"
}

resource "huaweicloud_identity_role" "hfa_iam_pipeline_integration" {
  name = huaweicloud_identity_group.hfa_iam_pipeline_integration.name
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
            "/iam/agencies/${module.security_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.transit_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.common_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.app_account_iam.hfa_network_admin_agency_id}",
            "/iam/agencies/${module.iam_account_iam.hfa_network_admin_agency_id}"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_iam_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_app_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_workloads_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:AbortMultipartUpload",
          "obs:object:DeleteObject",
          "obs:object:PutObject",
          "obs:object:ModifyObjectMetaData",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_integration_state_key}",
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:bucket:HeadBucket",
          "obs:bucket:ListBucket"
        ]
        "Resource" : [
          "OBS:*:*:bucket:${var.hfa_terraform_state_bucket}"
        ]
      }
    ]
  })
  description = "Allowing Assume Role and access state file"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_integration" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_integration.id
  role_id    = huaweicloud_identity_role.hfa_iam_pipeline_integration.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_integration_kms" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_integration.id
  role_id    = data.huaweicloud_identity_custom_role.hfa_state_kms.id
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

// HFA-App
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

resource "huaweicloud_identity_role" "hfa_iam_pipeline_app" {
  name = huaweicloud_identity_group.hfa_iam_pipeline_app.name
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
            "/iam/agencies/${huaweicloud_identity_agency.hfa_app_admin.id}"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_iam_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_state_key}",
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_network_workloads_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:object:GetObject",
          "obs:object:AbortMultipartUpload",
          "obs:object:DeleteObject",
          "obs:object:PutObject",
          "obs:object:ModifyObjectMetaData",
          "obs:object:GetObjectVersion",
        ]
        "Resource" : [
          "OBS:*:*:object:${var.hfa_terraform_state_bucket}/${var.hfa_app_state_key}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "obs:bucket:HeadBucket",
          "obs:bucket:ListBucket"
        ]
        "Resource" : [
          "OBS:*:*:bucket:${var.hfa_terraform_state_bucket}"
        ]
      }
    ]
  })
  description = "Allowing Assume Role and access state file"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_app" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_app.id
  role_id    = huaweicloud_identity_role.hfa_iam_pipeline_app.id
  project_id = "all"
}

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_app_kms" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_app.id
  role_id    = data.huaweicloud_identity_custom_role.hfa_state_kms.id
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

output "hfa_terraform_state_bucket" {
  value = var.hfa_terraform_state_bucket
}