variable "flux_namespace" {
  description = "Namespace flux controller will run in"
  type = string
  default = "flux-system"
}

variable "cluster_domain" {
  description = "Cluster domain of the kubernetes cluster fluxcd will run on"
  type = string
  default = "cluster.local"
}

variable "git_identity" {
  description = "Git ssh key to access root repo"
  type = string
}

variable "git_known_hosts" {
  description = "Git host fingerprint, in the format expected by fluxcd"
  type = string
}

variable "root_repo_url" {
  description = "Url of the root repo"
  type = string
}

variable "root_repo_branch" {
  description = "Branch to use on the root repo"
  type = string
  default = "main"
}

variable "root_repo_path" {
  description = "Path in the root repo to run kustomize on"
  type = string
  default = "./"
}