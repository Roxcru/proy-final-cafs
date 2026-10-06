output "jenkins_ip" {
  description = "IP publica del servidor Jenkins"
  value       = digitalocean_droplet.jenkins.ipv4_address
}

output "jenkins_url" {
  description = "URL de Jenkins"
  value       = "http://${digitalocean_droplet.jenkins.ipv4_address}:8080"
}