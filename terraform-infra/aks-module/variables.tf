variable "service_principal_client_id" {
  description = "The Client ID for the Service Principal"
}

variable "service_principal_client_secret" {
  description = "The Client Secret for the Service Principal"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "name" {}

variable location {
    default = "westus"
}

variable db_login {}

variable db_password {}

variable node_count { default = 1}

variable vm_size { default = "Standard_D2s_v3"}

variable log_analytics_workspace_name {
    default = "k8s-log-analytics"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}

variable ad_db_login { 
    default = "sqladmin"
}

variable ad_tenant_id {}
variable ad_object_id {}
