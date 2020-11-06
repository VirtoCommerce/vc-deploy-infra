provider "google" {
  version     = "~> 3.16.0"
  credentials = "${file(var.credentials)}"
  region      = var.region
  project     = var.project_id
}
provider "google-beta" {
  version     = "~> 3.16.0"
  credentials = "${file(var.credentials)}"
  project     = var.project_id
  region      = var.region
}
