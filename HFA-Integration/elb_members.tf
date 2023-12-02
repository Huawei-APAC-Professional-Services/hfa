resource "huaweicloud_elb_member" "hfa_app_prod_nginx_01" {
  provider      = huaweicloud.transit
  address       = data.terraform_remote_state.hfa_app.outputs.hfa_app_nginx_ip
  protocol_port = 80
  pool_id       = data.terraform_remote_state.hfa_network.outputs.hfa_transit_nginx_pool_id
}

output "nginx_access_address" {
  value = "http://${data.terraform_remote_state.hfa_network.outputs.hfa_transit_ingress_elb_ip}"
}