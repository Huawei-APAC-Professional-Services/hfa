variable "hfa_main_region" {
  type        = string
  description = "default region for Huawei Cloud Terraform Provider"
  default     = "ap-southeast-3"
}

variable "hfa_iam_base_agency_name" {
  type        = string
  description = "HFA base agency in every acount except Central IAM Account for delegating permission to Terraform for automation"
  default     = "hfa_iam_base"
}

/*
The following variables define the account structure of the HFA.
You need to add or remove the variables according to your account structure.
Information related to master account are moved to another HFA_Master_Account.tf for workshop purpose and in comment state, if you are implementing HFA by yourself, Please include the master account information.
*/
variable "hfa_iam_account_name" {
  type        = string
  description = "name of centralied IAM account"
}

variable "hfa_security_account_name" {
  type        = string
  description = "name of security account"
}

variable "hfa_transit_account_name" {
  type        = string
  description = "name of transit account"
}

variable "hfa_common_account_name" {
  type        = string
  description = "name of common account"
}

variable "hfa_app_account_name" {
  type        = string
  description = "name of application account"
}

variable "hfa_iam_acccount_security_group_name" {
  type    = string
  default = "hfa_security"
}

variable "hfa_iam_account_pipeline_network_group_name" {
  type    = string
  default = "hfa_pipeline_network"
}

variable "hfa_iam_account_pipeline_network_user_name" {
  type    = string
  default = "hfa_pipeline_network"
}

variable "hfa_iam_account_app_admin_group_name" {
  type    = string
  default = "hfa_pipeline_app"
}

variable "hfa_iam_account_pipeline_app_user_name" {
  type    = string
  default = "hfa_pipeline_app"
}

variable "hfa_iam_account_pipeline_integration_group_name" {
  type    = string
  default = "hfa_pipeline_integration"
}

variable "hfa_iam_account_pipeline_integration_user_name" {
  type    = string
  default = "hfa_pipeline_integration"
}

variable "hfa_security_admin_agency_name" {
  type    = string
  default = "hfa-security-admin"
}

variable "hfa_network_admin_agency_name" {
  type    = string
  default = "hfa-network-admin"
}

variable "hfa_iam_account_pipeline_base_group_name" {
  type    = string
  default = "hfa_pipeline_base"
}

variable "hfa_iam_account_pipeline_base_user_name" {
  type    = string
  default = "hfa_pipeline_base"
}

variable "hfa_base_agency_name" {
  type    = string
  default = "hfa_base"
}

variable "hfa_cts_log_transfer_agency_name" {
  type    = string
  default = "hfa_log_transfer"
}