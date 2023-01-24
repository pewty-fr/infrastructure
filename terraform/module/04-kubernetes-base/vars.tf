variable "region" {
  type        = string
  description = "Scaleway region"
}

variable "zone" {
  type        = string
  description = "Scaleway zone"
}

variable "project" {
  type        = string
  description = "Scaleway project"
}

variable "scw_access_key" {
  sensitive = true
  type      = string
}

variable "scw_secret_key" {
  sensitive = true
  type      = string
}

variable "k3s_master_name" {
  type        = string
  description = "description"
}


variable "default_user" {
  type = object({
    username = string
    email    = string
  })
}
