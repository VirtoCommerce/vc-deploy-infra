terraform {
  backend "gcs" {
    credentials = "./terraform-gke-keyfile.json"
    bucket      = "virto-k8s-bucket"
    prefix      = "terraform/state"
  }
}
