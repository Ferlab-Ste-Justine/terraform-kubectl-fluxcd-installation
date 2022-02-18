variable "fluxcd_namespace" {
  description = "Namespace flux controller will run in"
  type = string
  default = "fluxcd-system"
}

variable "fluxcd_resources_name" {
  description = "Name to give to generated bootstrap resources"
  type = string
  default = "fluxcd"
}


variable "cluster_domain" {
  description = "Cluster domain of the kubernetes cluster fluxcd will run on"
  type = string
  default = "cluster.local"
}

variable "git_trusted_keys" {
  description = "Concatenated public keys of all trusted git authors"
  type = string
  default = ""
}

variable "git_identity" {
  description = "Git ssh key to access repo"
  type = string
}

variable "git_known_hosts" {
  description = "Git host fingerprint, in the format expected by fluxcd"
  type = string
}

variable "repo_url" {
  description = "Url of the repo"
  type = string
}

variable "repo_branch" {
  description = "Branch to use on the repo"
  type = string
  default = "main"
}

variable "repo_path" {
  description = "Path in the repo to run kustomize on"
  type = string
  default = "./"
}

variable "repo_recurse_submodules" {
  description = "Whether to clone the gitsubmodules of the repo"
  type = bool
  default = false
}