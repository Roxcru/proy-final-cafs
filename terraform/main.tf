terraform {
  required_version = ">= 1.6.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.104"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "jenkins" {
  name       = "jenkins-cafs-key"
  public_key = file(var.ssh_public_key_path)
}

resource "digitalocean_droplet" "jenkins" {
  name   = "jenkins-cafs"
 region = "lon1"
  size   = "s-2vcpu-2gb"
  image  = "ubuntu-24-04-x64"

  ssh_keys = [
    digitalocean_ssh_key.jenkins.fingerprint
  ]

  user_data = file("${path.module}/cloud-init.yaml")

  tags = [
    "jenkins",
    "cafs"
  ]
}

resource "digitalocean_firewall" "jenkins" {
  name = "jenkins-cafs-firewall"

  droplet_ids = [
    digitalocean_droplet.jenkins.id
  ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "50000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "aws_s3_bucket" "backup" {
  bucket = "bucket-codigo-backup-final-proyect"
}