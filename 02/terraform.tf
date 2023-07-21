terraform {

  required_providers {

    template = {
      source  = "hashicorp/template"
      version = "> 2"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

  }

  backend "s3" {
    bucket = "ngm-tfstate"
    key    = "demos/do/terraform.tfstate"
    region = "eu-central-1"
  }

  required_version = "> 1.5.0"
}

provider "digitalocean" {
  token = var.apikey
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
