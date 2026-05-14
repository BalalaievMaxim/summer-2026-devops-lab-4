variable "ubuntu_image_path" {
  description = "URL to Ubuntu 24.04 Cloud Image"
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
}

variable "ssh_public_key" {
  description = "Public SSH key for ansible user"
  type        = string
  sensitive   = true
}