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

variable "pool_def" {
  type = object({
    net     = string
    mask    = string
    az_name = string
  })
}

variable "az" {
  type = object({
    wg_net          = string
    wg_mask         = string
    private_net     = string
    private_mask    = string
    private_net_v6  = string
    private_mask_v6 = string
    k3s_master = map(object({
      wg_ip      = string
      private_ip = string
    }))
    k3s_worker = map(object({
      wg_ip      = string
      private_ip = string
    }))
  })
  description = "description"
}

variable "wg_server" {
  type = object({
    k3s_master = map(object({
      id        = string
      ip_id     = string
      name      = string
      public_ip = string
    }))
    k3s_worker = map(object({
      id    = string
      ip_id = string
      name  = string
    }))
  })
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}
