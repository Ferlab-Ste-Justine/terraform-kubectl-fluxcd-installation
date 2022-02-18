resource "kubernetes_namespace" "fluxcd" {
  metadata {
    name = var.fluxcd_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_secret" "git_trusted_keys"  {
  count = var.git_trusted_keys != "" ? 1 : 0
  metadata {
    namespace = var.fluxcd_namespace
    name =      "${var.fluxcd_resources_name}-trusted-keys"
  }

  data = {
    "keys.asc" = var.git_trusted_keys
  }

  depends_on = [kubernetes_namespace.fluxcd]
}

resource "kubernetes_secret" "git_ssh_key" {
  metadata {
    namespace = var.fluxcd_namespace
    name =      "${var.fluxcd_resources_name}-key"
  }

  data = {
    identity    = var.git_identity
    known_hosts = var.git_known_hosts
  }

  depends_on = [kubernetes_namespace.fluxcd]
}

locals {
  install_resources = toset(split("---\n", templatefile(
    "${path.module}/fluxcd-install-manifests/manifest-template.yml",
    {
      flux_namespace = var.fluxcd_namespace,
      cluster_domain = var.cluster_domain
    }
  )))
  bootstrap_repo_resources = toset(split("---\n", templatefile(
    "${path.module}/bootstrap-repo-manifests/manifest-template.yml",
    {
      flux_namespace = var.fluxcd_namespace,
      flux_resources_name = var.fluxcd_resources_name
      repo_url = var.repo_url,
      repo_branch = var.repo_branch
      repo_path = var.repo_path
      repo_recurse_submodules = var.repo_recurse_submodules
      trusted_keys_verification = var.git_trusted_keys != ""
    }
  )))
}

resource "kubectl_manifest" "install" {
  for_each   = local.install_resources
  depends_on = [kubernetes_namespace.fluxcd, kubernetes_secret.git_ssh_key]
  yaml_body  = each.value
}

resource "kubectl_manifest" "bootstrap_repo" {
  for_each   = local.bootstrap_repo_resources
  depends_on = [kubectl_manifest.install]
  yaml_body  = each.value
}