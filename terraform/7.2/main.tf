provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1gphqa115k3rktslgbr"
  folder_id                = "b1glsnabp3rfdvma8i68"
  zone                     = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform-netology"
  hostname    = "terraform-netology.local"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "f2eh8sclblvdlq7iarqv"
      type     = "network-hdd"
      size     = "15"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
