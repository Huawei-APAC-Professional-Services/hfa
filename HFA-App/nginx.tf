data "huaweicloud_availability_zones" "zones" {
  provider = huaweicloud.app
}

data "huaweicloud_compute_flavors" "nginxflavor" {
  provider          = huaweicloud.app
  availability_zone = data.huaweicloud_availability_zones.zones.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "ubuntuimage" {
  provider    = huaweicloud.app
  name        = "Ubuntu 20.04 server 64bit"
  most_recent = true
}

resource "huaweicloud_compute_instance" "nginx" {
  provider           = huaweicloud.app
  name               = "nginx"
  image_id           = data.huaweicloud_images_image.ubuntuimage.id
  admin_pass         = var.nginx_admin_pass
  user_data          = file("nginx_init.yaml")
  flavor_id          = data.huaweicloud_compute_flavors.nginxflavor.ids[0]
  security_group_ids = [data.terraform_remote_state.hfa_network_workload.outputs.hfa_app_prod_nginx_secgroup_id]
  availability_zone  = data.huaweicloud_availability_zones.zones.names[0]

  network {
    uuid = data.terraform_remote_state.hfa_network_workload.outputs.hfa_app_prod_subnet_id
  }
}

output "hfa_app_nginx_ip" {
  value = huaweicloud_compute_instance.nginx.access_ip_v4
}