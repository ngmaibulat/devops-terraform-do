
output "ip" {
  value = digitalocean_droplet.vm.ipv4_address
}

output "dns" {
  value = cloudflare_record.www.hostname
}
