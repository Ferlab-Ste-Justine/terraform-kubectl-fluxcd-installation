//Because of the way terraform works, it is very hard to apply the result of "flux_install" directly on "kubectl_manifest" with a for_each
//Something about the inability of for_each to handle input that is indeterministic at code analysis time

//To circumvent this, we are generating the flux manifest with the terraform snipet below

data "flux_install" "flux" {
  #The first argument doesn't seem to matter (completely absent from generated output). Don't lose sleep over it
  target_path = "prod-cluster"
  cluster_domain = "__CLUSTER_DOMAIN__"
  namespace = "__FLUX_NAMESPACE__"
  components_extra = ["image-reflector-controller", "image-automation-controller"]
  version = "v0.41.1"
}

resource "local_file" "flux" {
  content = replace(replace(replace(data.flux_install.flux.content, "$${", "$$${"), "__FLUX_NAMESPACE__", "$${flux_namespace}"), "__CLUSTER_DOMAIN__", "$${cluster_domain}")
  filename = "${path.module}/../fluxcd-install-manifests/manifest-template.yml"
  file_permission = "0600"
}