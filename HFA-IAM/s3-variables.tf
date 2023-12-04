/*
Currently using OBS for terraform state storage.
Because there is no state-locking support from OBS storage, there following backends are also recoomended depends on the customer environment:
  1. consul
  2. kubernetes
  3. PostGreSQL 
*/
variable "hfa_terraform_state_bucket" {
  type        = string
  description = "OBS Bucket for storing terraform state"
}

variable "hfa_terraform_state_obs_endpoint" {
  type        = string
  default     = "https://obs.ap-southeast-3.myhuaweicloud.com"
  description = "OBS endpoint for terraform state storage"
}

variable "hfa_iam_state_key" {
  type        = string
  default     = "hfa-iam/terraform.tfstate"
  description = "default key for storing state of HFA-IAM module in OBS"
}

variable "hfa_base_state_key" {
  type        = string
  default     = "hfa-base/terraform.tfstate"
  description = "default key for storing state of HFA-Base module in OBS"
}

variable "hfa_network_state_key" {
  type        = string
  default     = "hfa-network/terraform.tfstate"
  description = "default key for storing state of HFA-Network module in OBS"
}

variable "hfa_network_workloads_state_key" {
  type        = string
  default     = "hfa-network-workloads/terraform.tfstate"
  description = "default key for storing state of HFA-Network-workloads module in OBS"
}

variable "hfa_app_state_key" {
  type        = string
  default     = "hfa-app/terraform.tfstate"
  description = "default key for storing state of HFA-App module in OBS"
}

variable "hfa_integration_state_key" {
  type        = string
  default     = "hfa-integration/terraform.tfstate"
  description = "default key for storing state of HFA-Integration module in OBS"
}
