provider "google" {
  project = var.prod_host_project_id
  region  = var.region
  zone    = var.zone
}
