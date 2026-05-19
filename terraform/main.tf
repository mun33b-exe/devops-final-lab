terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "devops_lab" {
  name         = "mun33bexe/devops-lab:latest"
  keep_locally = true
}

resource "docker_container" "devops_lab" {
  image    = docker_image.devops_lab.image_id
  name     = "devops-lab-tf"
  hostname = "devops-lab-tf"

  ports {
    internal = 3000
    external = 3001
  }

  restart = "unless-stopped"

  labels {
    label = "managed_by"
    value = "terraform"
  }
  labels {
    label = "project"
    value = "devops-lab"
  }
}

output "container_id" {
  value       = docker_container.devops_lab.id
  description = "The ID of the provisioned container"
}

output "container_name" {
  value       = docker_container.devops_lab.name
  description = "The container name"
}

output "app_url" {
  value       = "http://localhost:3001"
  description = "Where the app is reachable"
}
