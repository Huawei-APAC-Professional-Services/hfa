resource "huaweicloud_nat_gateway" "hfa_transit_egress_prod" {
  provider    = huaweicloud.transit
  name        = var.nat_gateway_name
  description = "egress for hfa"
  spec        = var.nat_gateway_spec
  vpc_id      = huaweicloud_vpc.hfa_transit_egress_prod.id
  subnet_id   = huaweicloud_vpc_subnet.hfa_transit_egress_prod_public.id
}

resource "huaweicloud_vpc_eip" "hfa_transit_egress_prod_eip" {
  provider = huaweicloud.transit
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "hfa_transit_egress_prod_eip"
    size        = 300
    charge_mode = "traffic"
  }
}

output "hfa_transit_egress_prod_nat_id" {
  value = huaweicloud_nat_gateway.hfa_transit_egress_prod.id
}

output "hfa_transit_egress_prod_eip_app_id" {
  value = huaweicloud_vpc_eip.hfa_transit_egress_prod_eip.id
}