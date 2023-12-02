resource "huaweicloud_er_instance" "hfa_transit_prod" {
  provider                       = huaweicloud.transit
  availability_zones             = var.hfa_er_prod_azs
  auto_accept_shared_attachments = true

  name = var.hfa_er_prod_name
  asn  = var.hfa_er_prod_asn
}

// prod ingress
resource "huaweicloud_er_vpc_attachment" "hfa_transit_ingress_prod" {
  provider    = huaweicloud.transit
  instance_id = huaweicloud_er_instance.hfa_transit_prod.id
  vpc_id      = huaweicloud_vpc.hfa_transit_ingress_prod.id
  subnet_id   = huaweicloud_vpc_subnet.hfa_transit_ingress_prod_er.id

  name                   = "hfa_transit_ingress_prod"
  description            = "VPC attachment created by terraform"
  auto_create_vpc_routes = true
}

resource "huaweicloud_er_route_table" "hfa_transit_prod" {
  provider    = huaweicloud.transit
  instance_id = huaweicloud_er_instance.hfa_transit_prod.id
  name        = "hfa_prod"
  description = "Route table created by terraform"
}

resource "huaweicloud_er_static_route" "hfa_egress_nat_prod" {
  provider       = huaweicloud.transit
  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
  destination    = "0.0.0.0/0"
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_transit_egress_prod.id
}

resource "huaweicloud_er_association" "hfa_transit_ingress_prod" {
  provider       = huaweicloud.transit
  instance_id    = huaweicloud_er_instance.hfa_transit_prod.id
  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_transit_ingress_prod.id
}

resource "huaweicloud_er_propagation" "hfa_er_prod_ingress" {
  provider       = huaweicloud.transit
  instance_id    = huaweicloud_er_instance.hfa_transit_prod.id
  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_transit_ingress_prod.id
}

#resource "huaweicloud_er_propagation" "hfa_transit_ingress_prod" {
#  provider = huaweicloud.transit
#  instance_id    = huaweicloud_er_instance.hfa_transit_prod.id
#  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
#  attachment_id  = huaweicloud_er_vpc_attachment.hfa_transit_ingress_prod.id
#}

// prod egress
resource "huaweicloud_er_vpc_attachment" "hfa_transit_egress_prod" {
  provider    = huaweicloud.transit
  instance_id = huaweicloud_er_instance.hfa_transit_prod.id
  vpc_id      = huaweicloud_vpc.hfa_transit_egress_prod.id
  subnet_id   = huaweicloud_vpc_subnet.hfa_transit_egress_prod_er.id

  name                   = "hfa_transit_egress_prod"
  description            = "VPC attachment created by terraform"
  auto_create_vpc_routes = true
}

resource "huaweicloud_er_association" "hfa_transit_egress_prod" {
  provider       = huaweicloud.transit
  instance_id    = huaweicloud_er_instance.hfa_transit_prod.id
  route_table_id = huaweicloud_er_route_table.hfa_transit_prod.id
  attachment_id  = huaweicloud_er_vpc_attachment.hfa_transit_egress_prod.id
}

output "hfa_transit_er_prod_id" {
  value = huaweicloud_er_instance.hfa_transit_prod.id
}

output "hfa_transit_er_prod_rt_id" {
  value = huaweicloud_er_route_table.hfa_transit_prod.id
}
