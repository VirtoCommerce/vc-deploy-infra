variable cluster_name {}

variable resource_group_name {}

variable location {}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable client_id {}

variable client_secret {}

variable node_count {}

variable vm_size {}

variable subnet_default {}

variable min_count {}

variable max_count {}

variable dns_prefix {}
