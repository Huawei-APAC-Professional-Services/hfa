locals {
  hfa_app_prod_er_cidr               = cidrsubnet(var.hfa_app_prod_cidr, 8, 0)
  hfa_app_prod_web_cidr              = cidrsubnet(var.hfa_app_prod_cidr, 8, 1)
  hfa_transit_er_prod_id             = data.terraform_remote_state.hfa_network.outputs.hfa_transit_er_prod_id
  hfa_transit_er_prod_rt_id          = data.terraform_remote_state.hfa_network.outputs.hfa_transit_er_prod_rt_id
  hfa_transit_egress_prod_nat_id     = data.terraform_remote_state.hfa_network.outputs.hfa_transit_egress_prod_nat_id
  hfa_transit_egress_prod_eip_app_id = data.terraform_remote_state.hfa_network.outputs.hfa_transit_egress_prod_eip_app_id
}
// ingress VPC in transit account
resource "huaweicloud_vpc" "hfa_app_prod" {
  provider = huaweicloud.app
  name     = "hfa_app_prod"
  cidr     = var.hfa_app_prod_cidr

  tags = { "Name" : "hfa_app_prod" }
}

resource "huaweicloud_vpc_route" "app_vpc_to_er" {
  provider    = huaweicloud.app
  vpc_id      = huaweicloud_vpc.hfa_app_prod.id
  destination = "0.0.0.0/0"
  type        = "er"
  nexthop     = data.terraform_remote_state.hfa_network.outputs.hfa_transit_er_prod_id
  depends_on  = [huaweicloud_er_association.hfa_app_prod, huaweicloud_er_vpc_attachment.hfa_app_prod, huaweicloud_er_propagation.hfa_er_to_app]
}

resource "huaweicloud_er_propagation" "hfa_er_to_app" {
  provider       = huaweicloud.transit
  instance_id    = local.hfa_transit_er_prod_id
  route_table_id = local.hfa_transit_er_prod_rt_id
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_app_prod.id
}

resource "huaweicloud_nat_snat_rule" "hfa_transit_egress_public_rule" {
  provider       = huaweicloud.transit
  nat_gateway_id = local.hfa_transit_egress_prod_nat_id
  floating_ip_id = local.hfa_transit_egress_prod_eip_app_id
  cidr           = var.hfa_app_prod_cidr
}

//public subnet in ingress vpc for public resources
resource "huaweicloud_vpc_subnet" "hfa_app_prod_web" {
  provider   = huaweicloud.app
  name       = "hfa_app_prod_web"
  cidr       = local.hfa_app_prod_web_cidr
  gateway_ip = cidrhost(local.hfa_app_prod_web_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_app_prod.id

  tags = { "Name" : "hfa_app_prod_web" }
}

resource "huaweicloud_vpc_subnet" "hfa_app_prod_er" {
  provider   = huaweicloud.app
  name       = "hfa_app_prod_er"
  cidr       = local.hfa_app_prod_er_cidr
  gateway_ip = cidrhost(local.hfa_app_prod_er_cidr, 1)
  vpc_id     = huaweicloud_vpc.hfa_app_prod.id

  tags = { "Name" : "hfa_app_prod_er" }
}

resource "huaweicloud_er_vpc_attachment" "hfa_app_prod" {
  provider    = huaweicloud.app
  instance_id = local.hfa_transit_er_prod_id
  vpc_id      = huaweicloud_vpc.hfa_app_prod.id
  subnet_id   = huaweicloud_vpc_subnet.hfa_app_prod_er.id

  name                   = "hfa_app_prod"
  description            = "VPC attachment created by terraform"
  auto_create_vpc_routes = false
}

resource "huaweicloud_er_association" "hfa_app_prod" {
  provider       = huaweicloud.transit
  instance_id    = local.hfa_transit_er_prod_id
  route_table_id = local.hfa_transit_er_prod_rt_id
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_app_prod.id
}

#resource "huaweicloud_er_propagation" "hfa_app_prod" {
#  provider = huaweicloud.transit
#  instance_id    = huaweicloud_er_instance.hfa_transit_prod.id
#  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
#  attachment_id  = huaweicloud_er_vpc_attachment.hfa_app_prod.id
#}

resource "huaweicloud_networking_secgroup" "hfa_app_prod_nginx_secgroup" {
  provider    = huaweicloud.app
  name        = "hfa_app_prod_nginx_secgroup"
  description = "vpc security group for nginx server"
}

resource "huaweicloud_networking_secgroup_rule" "hfa_app_prod_nginx_secgroup_allow_http" {
  provider          = huaweicloud.app
  security_group_id = huaweicloud_networking_secgroup.hfa_app_prod_nginx_secgroup.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
}

output "hfa_app_prod_nginx_secgroup_id" {
  value = huaweicloud_networking_secgroup.hfa_app_prod_nginx_secgroup.id
}

output "hfa_app_prod_subnet_id" {
  value = huaweicloud_vpc_subnet.hfa_app_prod_web.id
}