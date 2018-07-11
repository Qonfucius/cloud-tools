data "scaleway_image" "jumpImage" {
  architecture = "${var.instance_arch}"
  name_filter = "${var.image_name}"
}

resource "scaleway_server" "jump_host" {
  name                = "jump-host"
  image               = "${data.scaleway_image.jumpImage.id}"
  type                = "${var.instance_type}"
  dynamic_ip_required = true

  security_group      = "${var.instance_security_group}"

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