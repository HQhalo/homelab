resource "proxmox_lxc" "technitium" {
  target_node  = var.target_node
  ostemplate   = var.lxc_template
  hostname     = "technitiumdns"
  vmid         = 153

  unprivileged = true

  cores        = 1
  memory       = 512
  swap         = 0
  start        = true
  onboot       = true

  rootfs {
    storage = var.storage
    size    = "2G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.techitium_ip}/24"
    gw     = var.gateway
  }

  features {
    nesting = true
  }

  ssh_public_keys = base64decode(var.ssh_public_keys)


  provisioner "remote-exec" {
    inline = [
      "apt install -y curl",
      "curl -sSL https://download.technitium.com/dns/install.sh | bash"
    ]
    connection {
      type        = "ssh"
      port        = 22
      host        = var.techitium_ip
      user        = "root"
      private_key = base64decode(var.ssh_private_key)
    }
  }
}
