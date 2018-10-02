output "private_ip" {
  value = "${scaleway_server.postgresServer.private_ip}"
}