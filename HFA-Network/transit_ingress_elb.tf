data "huaweicloud_elb_flavors" "hfa_transit_ingress_prod_elb_flavor" {
  provider        = huaweicloud.transit
  type            = "L4"
  max_connections = 500000
  cps             = 10000
  bandwidth       = 50
}

resource "huaweicloud_vpc_eip" "hfa_transit_ingress_prod_elb_eip" {
  provider = huaweicloud.transit
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "hfa_transit_ingress_prod_elb_eip"
    size        = 300
    charge_mode = "traffic"
  }
}

resource "huaweicloud_elb_loadbalancer" "hfa_transit_prod_ingress" {
  provider          = huaweicloud.transit
  name              = "hfa_transit_prod_ingress"
  description       = "central ingress"
  cross_vpc_backend = true

  vpc_id         = huaweicloud_vpc.hfa_transit_ingress_prod.id
  ipv4_subnet_id = huaweicloud_vpc_subnet.hfa_transit_ingress_prod_public.ipv4_subnet_id

  l4_flavor_id = data.huaweicloud_elb_flavors.hfa_transit_ingress_prod_elb_flavor.ids[0]

  availability_zone = var.hfa_er_prod_azs

  ipv4_eip_id = huaweicloud_vpc_eip.hfa_transit_ingress_prod_elb_eip.id
}

resource "huaweicloud_lb_listener" "hfa_transit_prod_ingress_80" {
  provider        = huaweicloud.transit
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.hfa_transit_prod_ingress.id
}

resource "huaweicloud_lb_pool" "hfa_transit_prod_ingress_nginx" {
  provider    = huaweicloud.transit
  protocol    = "TCP"
  lb_method   = "SOURCE_IP"
  listener_id = huaweicloud_lb_listener.hfa_transit_prod_ingress_80.id
}

output "hfa_transit_nginx_pool_id" {
  value = huaweicloud_lb_pool.hfa_transit_prod_ingress_nginx.id
}

output "hfa_transit_ingress_elb_ip" {
  value = huaweicloud_vpc_eip.hfa_transit_ingress_prod_elb_eip.address
}