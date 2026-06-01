variable "fluxcd_namespace" {
  description = "Namespace fluxcd controllers will run in"
  type        = string
  default     = "fluxcd-system"
}

variable "cluster_domain" {
  description = "Internal domain of the kubernetes cluster. Passed to the Helm chart as clusterDomain."
  type        = string
  default     = "cluster.local"
}

variable "chart_version" {
  description = "Version of the fluxcd-community/flux2 Helm chart to install"
  type        = string
  default     = "2.18.3"
}

variable "components" {
  description = <<-EOT
    Per-controller image, tag and nodeSelector overrides. Any field left unset
    falls back to the Helm chart default for that field.

    For image_automation_controller and image_reflection_controller, the create
    field can be set to true or false to explicitly enable or disable the
    controller. When left unset, the Helm chart default applies.
  EOT
  type = object({
    cli = optional(object({
      image = optional(string)
      tag   = optional(string)
    }), {})
    helm_controller = optional(object({
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
    kustomize_controller = optional(object({
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
    source_controller = optional(object({
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
    notification_controller = optional(object({
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
    image_automation_controller = optional(object({
      create        = optional(bool)
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
    image_reflection_controller = optional(object({
      create        = optional(bool)
      image         = optional(string)
      tag           = optional(string)
      node_selector = optional(map(string))
    }), {})
  })
  default = {}
}
