locals {
  install_resources_values = split("---\n", templatefile(
    "${path.module}/fluxcd-install-manifests/manifest-template.yml",
    {
      flux_namespace = var.fluxcd_namespace,
      cluster_domain = var.cluster_domain
    }
  ))
  install_resources_keys = [for elem_outer in [for elem_inner in local.install_resources_values: yamldecode(elem_inner)]: "${elem_outer.apiVersion}/${elem_outer.kind}/${lookup(elem_outer.metadata, "namespace", "default")}/${elem_outer.metadata.name}"]
  install_resources = zipmap(local.install_resources_keys, local.install_resources_values)
}

resource "kubectl_manifest" "install" {
  for_each   = local.install_resources
  yaml_body  = each.value
}