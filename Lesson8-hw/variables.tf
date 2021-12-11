variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "wordpress"
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "wordpress-pw"
  sensitive   = true
}

variable "home_ip" {
  type    = list(string)
  default = ["93.77.16.26/32"]
}

variable "ssh_key_name" {
  type    = string
  default = "MySSHKey"
}
