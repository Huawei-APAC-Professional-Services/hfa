// Name prefix for obs bucket in every regions that will be used to store CTS logs
// The centralized bucket in main region or designated region name format: ${hfa_cts_bucket}-${uuid}(hfa-archive-f09fd9be-a2aa-34ea-d825-d5c6111e1d40)
// The regional bucket name format: ${hfa_cts_bucket}-${region}-${uuid}（hfa-archive-ap-southeast-3-f09fd9be-a2aa-34ea-d825-d5c6111e1d40）
//  All the logs in regional bucket will be kept 7 days and replicated to centralized bucket
variable "hfa_cts_bucket_prefix" {
  type        = string
  description = "OBS Bucket for storing security related logs"
  default     = "hfa-archive"
  validation {
    condition     = var.hfa_cts_bucket_prefix != "" || can(regex("^[a-z0-9-.]+$", var.hfa_cts_bucket_prefix))
    error_message = "Invalid Bucket Name, can only contains lower letters,hyphens,period"
  }
}

variable "hfa_cts_log_region" {
  type    = string
  default = null
}

variable "hfa_config_log_region" {
  type    = string
  default = null
}

variable "hfa_allowed_regions" {
  type    = set(string)
  default = ["ap-southeast-1", "ap-southeast-3", "ap-southeast-2"]
}

variable "hfa_config_bucket_prefix" {
  type    = string
  default = "hfa-config"
}

variable "hfa_config_topic_name" {
  type    = string
  default = "hfa-config"
}

variable "hfa_config_topic_display_name" {
  type    = string
  default = "hfa config"
}

variable "hfa_config_topic_region" {
  type    = string
  default = null
}

// Config aggregator name in security account
variable "hfa_config_aggregator_name" {
  type    = string
  default = "hfa"
}