# Proxmox Full-Clone
resource "proxmox_vm_qemu" "coolify" {
    # VM General Settings
    target_node = "pve"
    vmid = 101  # VMID should be an integer
    name = "Coolify"
    desc = "Coolify Platform"

    # VM Advanced General Settings
    onboot = true 
    boot = "order=scsi0"
    hotplug  = "network,disk,usb"

    # VM OS Settings
    clone = "ubuntu-24-04-cloud"
    full_clone = true

    # VM System Settings
    agent = 1  # Enables QEMU Guest Agent

    # VM CPU Settings
    cores = 2
    sockets = 2
    # cpu = "host"    

    # VM Memory Settings
    memory = 8192
    cloudinit_cdrom_storage = "local-lvm"
    scsihw = "virtio-scsi-single"

    vga {
        type = "virtio"
    }

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Disk Settings
    disk {
        backup  = true
        cache   = "none"
        format  = "raw"
        size    = "200G"
        storage = "local-lvm"
        type    = "scsi"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # Cloud-Init Network Configuration
    ipconfig0 = "ip=192.168.0.106/24,gw=192.168.0.1"
    nameserver = "192.168.0.1"

    # Cloud-Init User Configuration
    ciuser = "coolify"
    cipassword = "coolify"

    # SSH Key Setup
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIcwVHhxKi48DxzVQQQcTGTsR3qzCKIButh4+qfLCjr76HvTgmHMhR2BOM4SJhxeroloeHPPcqk7L4sxkh+k+WKZ4vj2FJ/Sd3kjzZvJa6VWB5/g2+kmlkQAjmq18HK9n7QwQo229C0QIp29F/Sk2i1d0bodXkEWYHfiJxSUxA/KNL/d8++z9akbxZv1x7Y8D56cOz+FIeMPtO3QscOLCUKgMKCsRY8F2KgyfO+3slB6B5Rrxlw53dQBzW1RPKacN3T6t35JdsisaD3bh7+FIAcNHryokkzjBS4iw/TSmAMxrUnynBxSQFTNiDBvFn0MZQix+ZSLhQqEqGuKPpyXN9MEJOYMaurZH63d7aXnlK5Ul/If6e3wactkgV0/EmSWRyd4/1bNWsFH7tBYnKL8B35uEmNGP6fLYEd18+MFflchtNTq1KouU/FxBqlitJ3L4nPmGkey0ssN1Nzg135mFenWSTXCq7An6eAZqSvUPPJMgswxw0YSi0V9TeIny3ZFU= admin@DESKTOP-OHGNB46
    EOF

    # Wait for the Cloud-Init configuration to be applied
    provisioner "remote-exec" {
        inline = [
            "sleep 30",  # Wait for Cloud-Init to apply changes
            "sudo ip a",
        ]
        connection {
            type     = "ssh"
            user     = "coolify"
            password = "coolify"
            host     = "192.168.0.106"
            timeout  = "5m"  # Allow 5 minutes for SSH to be ready
        }
    }
}
