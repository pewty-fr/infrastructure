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

variable "external_device" {
  type = map(object({
    wg_ip = string
  }))
  default     = {}
  description = "description"
}

variable "default_user" {
  type = object({
    username = string
    email    = string
  })
}

variable "applications" {
  type = map(object({
    domain    = string
    is_public = bool
    zone = string
  }))
}

variable "scw_access_key" {
  sensitive = true
  type      = string
}

variable "scw_secret_key" {
  sensitive = true
  type      = string
}
