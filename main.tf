locals {
  install_resources_values = compact(split("---\n", templatefile(
    "${path.module}/fluxcd-install-manifests/manifest-template.yml",
    {
      flux_namespace = var.fluxcd_namespace,
      cluster_domain = var.cluster_domain
    }
  )))
  install_resources_keys = [for elem_outer in [for elem_inner in local.install_resources_values: yamldecode(elem_inner)]: "${elem_outer.apiVersion}/${elem_outer.kind}/${lookup(elem_outer.metadata, "namespace", "default")}/${elem_outer.metadata.name}"]

  # we do the following instead of a zipmap to preserve the order of resources
  install_resources_tuple = [
    for idx in range(length(local.install_resources_keys)) : {
      key   = local.install_resources_keys[idx]
      value = local.install_resources_values[idx]
    }
  ]
  install_resources = { for key, value in local.install_resources_tuple : key => value }
}

resource "kubectl_manifest" "install" {
  for_each  = local.install_resources
  yaml_body = each.value.value
}