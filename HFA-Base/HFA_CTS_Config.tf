locals {
  central_cts_region         = var.hfa_cts_log_region == null ? data.terraform_remote_state.hfa_iam.outputs.hfa_main_region : var.hfa_cts_log_region
  cts_regional_list          = toset(compact([for v in var.hfa_allowed_regions : v == local.central_cts_region ? "" : v]))
  cts_regional_obs           = { for v in huaweicloud_obs_bucket.hfa_cts_log : v.region => v.id }
  cts_all_regions_obs_config = merge(local.cts_regional_obs, zipmap([huaweicloud_obs_bucket.hfa_cts_centralized_log.region], [huaweicloud_obs_bucket.hfa_cts_centralized_log.id]))
  /*
  smn_allow_accounts_list = join(",", [
    "urn:csp:iam::${data.terraform_remote_state.hfa_iam.outputs.hfa_app_account_id}:root",
    "urn:csp:iam::${data.terraform_remote_state.hfa_iam.outputs.hfa_common_account_id}:root",
    "urn:csp:iam::${data.terraform_remote_state.hfa_iam.outputs.hfa_iam_account_id}:root",
    "urn:csp:iam::${data.terraform_remote_state.hfa_iam.outputs.hfa_security_account_id}:root",
    "urn:csp:iam::${data.terraform_remote_state.hfa_iam.outputs.hfa_transit_account_id}:root"
  ])
  */
}

resource "random_uuid" "bucket_suffix" {}

resource "huaweicloud_obs_bucket" "hfa_cts_centralized_log" {
  provider   = huaweicloud.security
  bucket     = "${var.hfa_cts_bucket_prefix}-${random_uuid.bucket_suffix.result}"
  region     = local.central_cts_region
  versioning = true
}

resource "huaweicloud_obs_bucket" "hfa_cts_log" {
  for_each   = local.cts_regional_list
  provider   = huaweicloud.security
  bucket     = "${var.hfa_cts_bucket_prefix}-${each.value}-${random_uuid.bucket_suffix.result}"
  region     = each.value
  versioning = true
}

resource "huaweicloud_obs_bucket" "hfa_config_log" {
  provider   = huaweicloud.security
  bucket     = "${var.hfa_config_bucket_prefix}-${random_uuid.bucket_suffix.result}"
  region     = var.hfa_config_log_region != null ? var.hfa_config_log_region : data.terraform_remote_state.hfa_iam.outputs.hfa_main_region
  versioning = true
}

resource "huaweicloud_obs_bucket_acl" "hfa_cts_log" {
  for_each   = local.cts_all_regions_obs_config
  region     = each.key
  provider   = huaweicloud.security
  depends_on = [huaweicloud_obs_bucket.hfa_cts_log]
  bucket     = each.value

  dynamic "account_permission" {
    for_each = local.all_except_security_accounts
    content {
      access_to_bucket = ["READ", "WRITE"]
      access_to_acl    = ["READ_ACP", "WRITE_ACP"]
      account_id       = account_permission.value
    }
  }
}

resource "huaweicloud_obs_bucket_acl" "hfa_config_log" {
  region   = huaweicloud_obs_bucket.hfa_config_log.region
  provider = huaweicloud.security
  bucket   = huaweicloud_obs_bucket.hfa_config_log.id

  dynamic "account_permission" {
    for_each = local.all_except_security_accounts
    content {
      access_to_bucket = ["READ", "WRITE"]
      access_to_acl    = ["READ_ACP", "WRITE_ACP"]
      account_id       = account_permission.value
    }
  }
}

// Currently will be created in security account
// change as neccessary
resource "huaweicloud_smn_topic" "hfa_config_topic" {
  provider              = huaweicloud.security
  region                = var.hfa_config_topic_region == null ? data.terraform_remote_state.hfa_iam.outputs.hfa_main_region : var.hfa_config_topic_region
  name                  = var.hfa_config_topic_name
  display_name          = var.hfa_config_topic_display_name
  users_publish_allowed = local.config_smn_topic_allow_accounts_list
  introduction          = "created for hfa"
}


// Currently cross region replication is not support between oversea regions
/*
resource "huaweicloud_obs_bucket_replication" "cts_obs_replication" {
  for_each = local.cts_regional_buckets
  provider = huaweicloud.security
  region = local.central_cts_region
  bucket             = each.value
  destination_bucket = huaweicloud_obs_bucket.hfa_cts_centralized_log.id
  agency             = data.terraform_remote_state.hfa_iam.outputs.hfa_security_account_obs_replication_agency_name
}
*/

#resource "huaweicloud_obs_bucket_policy" "hfa_config_bucket_policy" {
#  provider = huaweicloud.security
#  bucket = huaweicloud_obs_bucket.hfa_config_log.id
#  region = huaweicloud_obs_bucket.hfa_config_log.region
#  policy = jsonencode({
#    Statement = [
#      {
#        Sid = "Allow config to dump the data"
#        Effect = "Allow"
#        Principal = {
#          ID = [
#            "${data.terraform_remote_state.hfa_iam.outputs.hfa_app_account_name}/${data.terraform_remote_state.hfa_iam.outputs.hfa_app_account_id}:agency/rms_tracker_agency",
#            "${data.terraform_remote_state.hfa_iam.outputs.hfa_common_account_name}/${data.terraform_remote_state.hfa_iam.outputs.hfa_common_account_id}:agency/rms_tracker_agency",
#            "${data.terraform_remote_state.hfa_iam.outputs.hfa_iam_account_name}/${data.terraform_remote_state.hfa_iam.outputs.hfa_iam_account_id}:agency/rms_tracker_agency",
#            "${data.terraform_remote_state.hfa_iam.outputs.hfa_transit_account_name}/${data.terraform_remote_state.hfa_iam.outputs.hfa_transit_account_id}:agency/rms_tracker_agency"
#          ]
#        }
#        Action = [
#          "PutObject"
#        ]
#        Resource = [
#          "${huaweicloud_obs_bucket.hfa_config_log.id}/RMSLogs/*/Snapshot/*",
#          "${huaweicloud_obs_bucket.hfa_config_log.id}/RMSLogs/*/Notification/*"
#        ]
#      }
#    ]
#  })
#}