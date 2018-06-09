provider "scaleway" {
  version = "~> 1.4.1"
  organization = "${var.scw_organization}"
  token        = "${var.scw_token}"
  region       = "${var.scw_region}"
}

data "scaleway_image" "jumpImage" {
  architecture = "${var.instance_arch}"
  name_filter = "${var.image_name}"
}

resource "scaleway_server" "jump_host" {
  name                = "jump-host"
  image               = "${data.scaleway_image.jumpImage.id}"
  type                = "${var.instance_type}"
  dynamic_ip_required = true

  tags = ["jump_host"]

  connection {
    type     = "ssh"
    user     = "root"
    private_key = "${var.private_key}"
  }
}

resource "scaleway_ip" "jump_host" {
  server = "${scaleway_server.jump_host.id}"
}