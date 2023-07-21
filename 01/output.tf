

output "sshkey_fingerprint" {
  value = digitalocean_ssh_key.default.fingerprint
}

output "IP" {
  value = digitalocean_droplet.web.ipv4_address
}
