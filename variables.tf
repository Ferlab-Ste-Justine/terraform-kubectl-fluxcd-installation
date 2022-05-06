variable "fluxcd_namespace" {
  description = "Namespace fluxcd controller will run in"
  type = string
  default = "fluxcd-system"
}

variable "cluster_domain" {
  description = "Cluster domain of the kubernetes cluster fluxcd will run on"
  type = string
  default = "cluster.local"
}