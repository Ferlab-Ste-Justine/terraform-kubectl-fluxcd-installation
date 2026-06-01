locals {
  _cli = { for k, v in {
    image = var.components.cli.image
    tag   = var.components.cli.tag
  } : k => v if v != null }

  _helm_controller = { for k, v in {
    image        = var.components.helm_controller.image
    tag          = var.components.helm_controller.tag
    nodeSelector = var.components.helm_controller.node_selector
  } : k => v if v != null }

  _kustomize_controller = { for k, v in {
    image        = var.components.kustomize_controller.image
    tag          = var.components.kustomize_controller.tag
    nodeSelector = var.components.kustomize_controller.node_selector
  } : k => v if v != null }

  _source_controller = { for k, v in {
    image        = var.components.source_controller.image
    tag          = var.components.source_controller.tag
    nodeSelector = var.components.source_controller.node_selector
  } : k => v if v != null }

  _notification_controller = { for k, v in {
    image        = var.components.notification_controller.image
    tag          = var.components.notification_controller.tag
    nodeSelector = var.components.notification_controller.node_selector
  } : k => v if v != null }

  _image_automation_controller = { for k, v in {
    create       = var.components.image_automation_controller.create
    image        = var.components.image_automation_controller.image
    tag          = var.components.image_automation_controller.tag
    nodeSelector = var.components.image_automation_controller.node_selector
  } : k => v if v != null }

  _image_reflection_controller = { for k, v in {
    create       = var.components.image_reflection_controller.create
    image        = var.components.image_reflection_controller.image
    tag          = var.components.image_reflection_controller.tag
    nodeSelector = var.components.image_reflection_controller.node_selector
  } : k => v if v != null }

  helm_values = merge(
    { clusterDomain = var.cluster_domain },
    { for k, v in {
      cli                       = local._cli
      helmController            = local._helm_controller
      kustomizeController       = local._kustomize_controller
      sourceController          = local._source_controller
      notificationController    = local._notification_controller
      imageAutomationController = local._image_automation_controller
      imageReflectionController = local._image_reflection_controller
    } : k => v if length(v) > 0 }
  )
}

resource "helm_release" "fluxcd" {
  name             = "fluxcd"
  namespace        = var.fluxcd_namespace
  create_namespace = true
  chart            = "flux2"
  repository       = "https://fluxcd-community.github.io/helm-charts"
  version          = var.chart_version

  values = [yamlencode(local.helm_values)]
}
