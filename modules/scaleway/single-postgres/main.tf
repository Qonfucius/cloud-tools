# Not tested on previous versions
terraform {
  required_version = ">= 0.11.7"
}

provider "scaleway" {
  version = "~> 1.5.0"
  organization = "${var.scw_organization}"
  token        = "${var.scw_token}"
  region       = "${var.scw_region}"
}

data "scaleway_image" "postgresImage" {
  architecture = "${var.instance_arch}"
  name_filter = "${var.image_name}"
}

resource "scaleway_server" "postgresServer" {
  name  = "${var.cluster_name}-${count.index + 1}"
  image = "${data.scaleway_image.postgresImage.id}"
  type  = "${var.instance_type}"
  tags = ["${var.cluster_tag}"]

  security_group      = "${var.instance_security_group}"

  connection {
    type         = "ssh"
    agent        = true

    host         = "${self.private_ip}"
    user         = "root"
    private_key = "${var.bastion_private_key}"

    bastion_host = "${var.bastion_host}"
    bastion_user = "root"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "remote-exec" {
    inline = []
  }
}