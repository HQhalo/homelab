variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "pm_tls_insecure" {}
variable "target_node" { default = "pve" }
variable "vmid" { default = 153 }
variable "lxc_template" { default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst" }
variable "container_ip" { default = "192.168.123.153" }
variable "gateway" { default = "192.168.123.1" }
variable "storage" { default = "local" }
variable "ssh_public_keys" {}
variable "ssh_private_key" {}