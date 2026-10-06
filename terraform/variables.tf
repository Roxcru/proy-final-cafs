variable "do_token" {
  description = "DigitalOcean Personal Access Token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Ruta de la clave publica SSH"
  type        = string
}

variable "region" {
  description = "Region de DigitalOcean"
  type        = string
  default     = "nyc1"
}