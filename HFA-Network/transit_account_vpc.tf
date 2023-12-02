locals {
  hfa_transit_ingress_prod_public_cidr = cidrsubnet(var.hfa_transit_ingress_prod_cidr, 4, 0)
  hfa_transit_ingress_prod_er_cidr     = cidrsubnet(var.hfa_transit_ingress_prod_cidr, 8, 16)
  hfa_transit_egress_prod_public_cidr  = cidrsubnet(var.hfa_transit_egress_prod_cidr, 4, 0)
  hfa_transit_egress_prod_er_cidr      = cidrsubnet(var.hfa_transit_egress_prod_cidr, 8, 16)
}
// ingress VPC in transit account
resource "huaweicloud_vpc" "hfa_transit_ingress_prod" {
  provider = huaweicloud.transit
  name     = "hfa_ingress_prod"
  cidr     = var.hfa_transit_ingress_prod_cidr

  tags = { "Name" : "hfa_ingress_prod" }
}

//public subnet in ingress vpc for public resources
resource "huaweicloud_vpc_subnet" "hfa_transit_ingress_prod_public" {
  provider   = huaweicloud.transit
  name       = "hfa_transit_ingress_prod_public"
  cidr       = local.hfa_transit_ingress_prod_public_cidr
  gateway_ip = cidrhost(local.hfa_transit_ingress_prod_public_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_transit_ingress_prod.id

  tags = { "Name" : "hfa_transit_ingress_prod_public" }
}

resource "huaweicloud_vpc_subnet" "hfa_transit_ingress_prod_er" {
  provider   = huaweicloud.transit
  name       = "hfa_transit_ingress_prod_er"
  cidr       = local.hfa_transit_ingress_prod_er_cidr
  gateway_ip = cidrhost(local.hfa_transit_ingress_prod_er_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_transit_ingress_prod.id

  tags = { "Name" : "hfa_transit_ingress_prod_er" }
}

// egress vpc in transit account
resource "huaweicloud_vpc" "hfa_transit_egress_prod" {
  provider = huaweicloud.transit
  name     = "hfa_transit_egress_prod"
  cidr     = var.hfa_transit_egress_prod_cidr

  tags = { "Name" : "hfa_transit_egress_prod" }
}

resource "huaweicloud_vpc_subnet" "hfa_transit_egress_prod_public" {
  provider   = huaweicloud.transit
  name       = "hfa_transit_egress_prod_public"
  cidr       = local.hfa_transit_egress_prod_public_cidr
  gateway_ip = cidrhost(local.hfa_transit_egress_prod_public_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_transit_egress_prod.id

  tags = { "Name" : "hfa_transit_egress_prod_public" }
}

resource "huaweicloud_vpc_subnet" "hfa_transit_egress_prod_er" {
  provider   = huaweicloud.transit
  name       = "hfa_transit_egress_prod_er"
  cidr       = local.hfa_transit_egress_prod_er_cidr
  gateway_ip = cidrhost(local.hfa_transit_egress_prod_er_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_transit_egress_prod.id

  tags = { "Name" : "hfa_transit_egress_prod_er" }
}

output "hfa_transit_ingress_prod_id" {
  value = huaweicloud_vpc.hfa_transit_ingress_prod.id
}

output "hfa_transit_ingress_prod_public_id" {
  value = huaweicloud_vpc_subnet.hfa_transit_ingress_prod_public.ipv4_subnet_id
}