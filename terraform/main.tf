provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_container_cluster" "primary" {
  name     = "facmcp-gke-cluster"
  location = var.gcp_region

  network    = "default"
  subnetwork = "default"


  enable_autopilot = true


  release_channel {
    channel = "REGULAR"
  }


  remove_default_node_pool = true
  initial_node_count       = null

  
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # Configuration de la journalisation et de la surveillance
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  # Configuration de l'authentification (facultatif, mais recommandé pour Workload Identity)
  # Pour cet exemple simple, nous nous appuyons sur les permissions du compte de service par défaut
  # ou du compte utilisé par Terraform.

  # Activer Workload Identity (recommandé pour la sécurité)
  # Pour une configuration complète, cela nécessiterait plus de ressources IAM.
  # workload_identity_config {
  #   workload_pool_id = "${var.gcp_project_id}.svc.id.goog"
  # }

  # Configuration IP Aliases (recommandé pour la mise en réseau)
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

# Variables pour le projet et la région
variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region for the GKE cluster."
  type        = string
  default     = "europe-west1"
}

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "The location (region or zone) of the GKE cluster."
  value       = google_container_cluster.primary.location
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = google_container_cluster.primary.endpoint
}
