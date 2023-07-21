
resource "digitalocean_ssh_key" "default" {
  name       = "sshkey"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = "web-1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  user_data = file("setup.sh")
}
