## GKE Cluster
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "9.3.0"
  kubernetes_version         = "1.16.13-gke.401"
  regional                   = false
  create_service_account     = false
  remove_default_node_pool   = true
  network_policy             = true
  project_id                 = var.project_id
  region                     = var.region
  zones                      = var.zones
  name                       = var.name
  network                    = "default"
  subnetwork                 = "default"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = true
  horizontal_pod_autoscaling = true

  node_pools = [
    {
      name               = "virto-node-pool"
      local_ssd_count    = 0
      image_type         = "ubuntu"
      machine_type       = var.machine_type
      min_count          = var.min_count
      max_count          = var.max_count
      disk_size_gb       = var.disk_size_gb
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = false
      service_account    = var.service_account
      preemptible        = false
      initial_node_count = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "virto-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "virto-node-pool",
    ]
  }

}
