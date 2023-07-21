
data "template_file" "init" {
  template = file("${path.module}/scripts/init.sh")

  vars = {
    name  = "ocean"
    fqdn  = var.fqdn
    email = var.email
  }
}

resource "digitalocean_droplet" "vm" {
  image  = "ubuntu-22-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    var.ssh_fingerprint
  ]

  user_data = data.template_file.init.rendered

  tags = ["web"]
}


# Create a record
resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = digitalocean_droplet.vm.ipv4_address
  type    = "A"
  # ttl     = 3600
  ttl     = 60
  proxied = false
}
