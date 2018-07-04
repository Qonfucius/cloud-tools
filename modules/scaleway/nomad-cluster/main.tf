# Not tested on previous versions
terraform {
  required_version = ">= 0.11.7"
}


provider "scaleway" {
  version = "~> 1.4.1"
  organization = "${var.scw_organization}"
  token        = "${var.scw_token}"
  region       = "${var.scw_region}"
}

data "scaleway_image" "nomadImage" {
  architecture = "${var.instance_arch}"
  name_filter = "${var.image_name}"
}

resource "scaleway_server" "nomadServer" {
  name  = "${var.cluster_name}-${count.index + 1}"
  image = "${data.scaleway_image.nomadImage.id}"
  type  = "${var.instance_type}"
  count = "${var.cluster_size}"
  tags = ["${var.cluster_tag}"]
  dynamic_ip_required = true

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
          --client \
          --cluster-tag ${var.consul_cluster_tag} \
          --organization ${var.scw_organization} \
          --token ${var.scw_token}
      EOC
      ,
      <<EOC
        /opt/nomad/bin/run-nomad \
          --${var.nomad_role} \
          ${var.nomad_role == "server" ? "--num-servers ${var.cluster_size}" : ""} \
          ${var.nomad_role == "client" ? "--use-sudo" : ""} \
          ${var.nomad_meta_exposed != false ? "--exposed ${var.nomad_meta_exposed}" : ""} \
          ${var.nomad_params}
      EOC
    ]
  }
}
