variable "service_principal_client_id" {
  description = "The Client ID for the Service Principal"
}

variable "service_principal_client_secret" {
  description = "The Client Secret for the Service Principal"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}


variable location {
  default = "eastus"
}

variable resource_group_name {
  default = "cloud-platform"
}

variable db_password {}

variable tenant_id {}

variable subscription_id {}

variable ad_db_login {
  default = "sqladmin"
}

variable ad_tenant_id {}
variable ad_object_id {}

variable dns_prefix {}