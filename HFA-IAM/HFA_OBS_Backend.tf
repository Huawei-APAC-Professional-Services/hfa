data "huaweicloud_identity_custom_role" "hfa_state_kms" {
  name = "hfa_terraform_kms"
}

// HFA-Base
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

resource "huaweicloud_identity_group_role_assignment" "hfa_iam_pipeline_base_kms" {
  group_id   = huaweicloud_identity_group.hfa_iam_pipeline_base.id
  role_id    = data.huaweicloud_identity_custom_role.hfa_state_kms.id
  project_id = "all"
}

// HFA-Network
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

// HFA-Integration
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

// HFA-App
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

output "hfa_terraform_state_bucket" {
  value = var.hfa_terraform_state_bucket
}