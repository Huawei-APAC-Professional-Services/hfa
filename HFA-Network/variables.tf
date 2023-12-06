variable "hfa_er_prod_asn" {
  type        = string
  default     = "64512"
  description = "Default ASN for Production ER"
}

variable "hfa_er_prod_name" {
  type        = string
  default     = "hfa_er_prod"
  description = "Default Name for Production ER"
}

variable "hfa_elb_prod_azs" {
  type        = list(string)
  default     = ["ap-southeast-3a", "ap-southeast-3e"]
  description = "Default Name for Production ER"
}

variable "nat_gateway_name" {
  type    = string
  default = "hfa_transit_egress"
}

//1: Small type, which supports up to 10,000 SNAT connections.
//2: Medium type, which supports up to 50,000 SNAT connections.
//3: Large type, which supports up to 200,000 SNAT connections.
//4: Extra-large type, which supports up to 1,000,000 SNAT connections.
variable "nat_gateway_spec" {
  type    = string
  default = "1"
}

variable "hfa_transit_ingress_prod_cidr" {
  type = string
}

variable "hfa_transit_egress_prod_cidr" {
  type = string
}