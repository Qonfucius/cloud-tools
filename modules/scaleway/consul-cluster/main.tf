# Not tested on previous versions
terraform {
  required_version = ">= 0.11.7"
}

data "scaleway_image" "consulImage" {
  architecture = "${var.instance_arch}"
  name_filter = "${var.image_name}"
}

resource "scaleway_server" "consulServer" {
  name  = "${var.cluster_name}-${count.index + 1}"
  image = "${data.scaleway_image.consulImage.id}"
  type  = "${var.instance_type}"
  count = "${var.cluster_size}"
  tags = ["${var.cluster_tag}"]

  dynamic_ip_required = true

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
    inline = [
      <<EOC
        /opt/consul/bin/run-consul \
          --server \
          --cluster-size ${var.cluster_size} \
          --cluster-tag ${var.cluster_tag} \
          --organization ${var.scw_organization} \
          --token ${var.scw_token}
      EOC
    ]
  }
}
