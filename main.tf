resource "kubernetes_namespace" "fluxcd" {
  metadata {
    name = var.flux_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_secret" "git_ssh_key" {
  metadata {
    namespace = var.flux_namespace
    name =      "root-repo-fluxcd-key"
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
      flux_namespace = var.flux_namespace,
      cluster_domain = var.cluster_domain
    }
  )))
  bootstrap_repo_resources = toset(split("---\n", templatefile(
    "${path.module}/bootstrap-repo-manifests/manifest-template.yml",
    {
      flux_namespace = var.flux_namespace,
      root_repo_url = var.root_repo_url,
      root_repo_branch = var.root_repo_branch
      root_repo_path = var.root_repo_path
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