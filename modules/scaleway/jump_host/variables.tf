variable "image_name" {
  description = "Image name to match for deployment (please build image with packer)"
}

variable "instance_arch" {
  description = "Type of architecture for the chosen instance"
  default     = "x86_64"
}

variable "instance_type" {
  default     = "START1-XS"
  description = "Scaleway Instance type"
}

variable "private_key" {
  description = "Used to ssh from jump host to other hosts without password"
}

variable "instance_security_group" {
  description = "Security group"
  default = false
}
