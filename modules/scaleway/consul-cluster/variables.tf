variable "instance_type" {
  description = "Type of instance to deploy the cluster of servers"
  default     = "START1-S"

}
variable "instance_arch" {
  description = "Type of architecture for the chosen instance"
  default     = "x86_64"
}

variable "cluster_size" {
  description = "Size for the consul cluster"
  default     = "3"
}

variable "cluster_name" {
  description = "Name of the cluster"
  default     = "consul-servers"
}

variable "cluster_tag" {
  description = "Common tag for servers of the cluster"
  default     = "consul-server"
}

variable "scw_token" {
  description = "Scaleway secret key"
}

variable "scw_organization" {
  description = "Scaleway organization access key"
}

variable "image_name" {
  description = "Image name to match for deployment (please build image with packer)"
}

variable "bastion_host" {
  description = "Bastion host"
}

variable "bastion_private_key" {
  description = "Used to ssh from jump host to other hosts without password"
}

variable "instance_security_group" {
  description = "Security group"
  default = false
}