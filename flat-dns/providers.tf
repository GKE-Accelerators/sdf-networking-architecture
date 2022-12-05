provider "google" {
  project = var.prod_host_project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}