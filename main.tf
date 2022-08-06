terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
   token = var.do_token
#  token = "dop_v1_9e5dbadea3c4dc3af3d45f5256c0f704125653c8f0cb2f56fa66bb76c797936a"
}

resource "digitalocean_kubernetes_cluster" "aula3" {
  name = var.k8s_name
  # name   = "aula3"
  # region = "nyc1"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3

  }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.aula3.id
  name       = "premium"
  size       = "s-4vcpu-8gb"
  node_count = 2
}

variable "do_token" {
  
}

variable "k8s_name" {
  
}

variable "region" {
  
}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.aula3.endpoint
}

resource "local_file" "kube_config" {
  content = digitalocean_kubernetes_cluster.aula3.kube_config.0.raw_config
  filename = "kube_config.yaml"
}
