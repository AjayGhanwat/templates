resource "proxmox_vm_qemu" "coolify_resource" {
    target_node = "pve"
    vmid = 102
    name = "CoolifyResource"
    desc = "Coolify Resource Server"

    onboot = true 
    boot = "order=scsi0"
    hotplug  = "network,disk,usb"

    clone = "ubuntu-24-04-cloud"
    full_clone = true

    agent = 1 

    cores = 2
    sockets = 2

    memory = 8192
    scsihw = "virtio-scsi-single"

    vga {
        type = "virtio"
    }

    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disks {
        scsi {
            scsi0 {
                disk {
                    backup  = true
                    cache   = "none"
                    format  = "raw"
                    size    = "200G"
                    storage = "local-lvm"
                }
            }
        }
        ide {
            ide3 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
    }

  serial {
    id   = 0
    type = "socket"
  }

    os_type = "cloud-init"

    ipconfig0 = "ip=192.168.0.107/24,gw=192.168.0.1"
    nameserver = "192.168.0.1"

    ciuser = "coolify"
    cipassword = "coolify"

    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIcwVHhxKi48DxzVQQQcTGTsR3qzCKIButh4+qfLCjr76HvTgmHMhR2BOM4SJhxeroloeHPPcqk7L4sxkh+k+WKZ4vj2FJ/Sd3kjzZvJa6VWB5/g2+kmlkQAjmq18HK9n7QwQo229C0QIp29F/Sk2i1d0bodXkEWYHfiJxSUxA/KNL/d8++z9akbxZv1x7Y8D56cOz+FIeMPtO3QscOLCUKgMKCsRY8F2KgyfO+3slB6B5Rrxlw53dQBzW1RPKacN3T6t35JdsisaD3bh7+FIAcNHryokkzjBS4iw/TSmAMxrUnynBxSQFTNiDBvFn0MZQix+ZSLhQqEqGuKPpyXN9MEJOYMaurZH63d7aXnlK5Ul/If6e3wactkgV0/EmSWRyd4/1bNWsFH7tBYnKL8B35uEmNGP6fLYEd18+MFflchtNTq1KouU/FxBqlitJ3L4nPmGkey0ssN1Nzg135mFenWSTXCq7An6eAZqSvUPPJMgswxw0YSi0V9TeIny3ZFU= admin@DESKTOP-OHGNB46
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgXNiBXY46HeHAqPog2wM7BqDsG8D28sLaklQvCQbIV root@Coolify
    EOF
}
