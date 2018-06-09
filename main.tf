# Not tested on previous versions
terraform {
  required_version = ">= 0.11.7"
}

module "scaleway_jump_host" {
  source               = "./modules/scaleway/jump_host"

  scw_organization     = "${var.scaleway_organization}"
  scw_token            = "${var.scaleway_token}"
  scw_region           = "par1"

  image_name           = "Ubuntu Xenial"

  instance_type        = "START1-S"
  private_key          = "${file(".ssh/id_rsa")}"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CONSUL SERVER NODES
# ---------------------------------------------------------------------------------------------------------------------

module "scaleway_consul_servers" {
  source           = "./modules/scaleway/consul-cluster"

  scw_organization = "${var.scaleway_organization}"
  scw_token        = "${var.scaleway_token}"
  scw_region       = "par1"

  cluster_size     = 3
  cluster_tag      = "consul-servers"

  instance_type    = "START1-S"
  instance_arch    = "x86_64"

  image_name       = "^packer_consul_START1S"

  bastion_host     = "${module.scaleway_jump_host.public_ip}"
  bastion_private_key = "${file(".ssh/id_rsa")}"
}
