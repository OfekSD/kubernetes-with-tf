packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "example" {
  image = "rockylinux:9"
  export_path = "image.tar"
}

build {
  name = "k8s node"
  sources = ["source.docker.example"]
  provisioner "shell" {
    inline = [
      "dnf update -y",
      "dnf upgrade -y",
      "dnf install -y python3 python3-pip sudo",
    ]
  }
  provisioner "ansible"{
    playbook_file = "./initial-install.yml"
  }
}
