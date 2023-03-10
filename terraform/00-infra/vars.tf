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

variable "image" {
  type        = string
  description = "Image for scw k3s instance"
}

variable "pool" {
  type = object({
    net  = string
    mask = string
    AZs = map(object({
      wg_net          = string
      wg_mask         = string
      private_net_v6  = string
      private_mask_v6 = string
      private_net     = string
      private_mask    = string
      db = map(object({
        private_ip = string
      }))
      k3s_master = map(object({
        wg_ip         = string
        private_ip_v6 = string
        private_ip    = string
      }))
      k3s_worker = map(object({
        wg_ip         = string
        private_ip_v6 = string
        private_ip    = string
      }))
    }))
  })
  description = "List of instances in a given network"
}

variable "instance_state" {
  type    = string
  default = "started"
}

