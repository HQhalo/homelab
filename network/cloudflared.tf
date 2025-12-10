resource "proxmox_lxc" "cloudflared" {
  target_node  = var.target_node
  ostemplate   = var.lxc_template
  hostname     = "cloudflared"
  vmid         = 154

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
	
	nameserver 	= "${var.techitium_ip} 192.168.123.1"

	network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.cloudflared_ip}/24"
    gw     = var.gateway
  }
  network {
    name   = "eth1"
    bridge = "vmbr1"
    ip     = "${var.k8s_network_cloudflared_ip}/24"
    gw     = var.k8s_network_gateway
  }

  features {
    nesting = true
  }

  ssh_public_keys = base64decode(var.ssh_public_keys)
}


resource "null_resource" "setup_cloudflared" {
  provisioner "remote-exec" {
    inline = [
      "mkdir -p --mode=0755 /usr/share/keyrings",
      "apt install -y curl supervisor",
      "curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null",
			"echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | tee /etc/apt/sources.list.d/cloudflared.list",
			"apt-get update &&  apt-get install cloudflared",
      <<-EOT
      cat <<EOF >/etc/supervisor/conf.d/cloudflared.conf
      [program:cloudflared]
      command=/usr/bin/cloudflared tunnel run --token ${var.cloudflared_key}
      autostart=true
      autorestart=true
      EOF
			EOT
      ,
      "supervisorctl reread",
      "supervisorctl update",
    ]
  }    

  connection {
      type        = "ssh"
      port        = 22
      host        = var.cloudflared_ip
      user        = "root"
      private_key = base64decode(var.ssh_private_key)
  }

  depends_on = [
    proxmox_lxc.cloudflared
  ]
}