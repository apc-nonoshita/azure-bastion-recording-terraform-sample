variable "location" {
  default     = "eastus"
  description = "The location/region where the virtual network is created."
}

variable "admin_username" {
  default   = "adminuser"
  sensitive = true
}

variable "admin_password" {
  sensitive = true
}
