output "public_ip" {
  value = "${scaleway_ip.jump_host.ip}"
}