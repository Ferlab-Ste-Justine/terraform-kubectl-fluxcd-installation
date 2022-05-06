# About

This Terraform module installs fluxcd version 2 on an existing kubernetes cluster.

By the time the module has run, you will have:
- The fluxcd resource definitions created and its controller running

# Referenced Resource

We tried to follow the instructions here: https://registry.terraform.io/providers/fluxcd/flux/latest/docs/guides/github

However, we found it to be quite an adventure, hence this module.

# Usage

## Input

The module takes the following input variables:

- **fluxcd_namespace**: Namespace the flux controllers. Defaults to "flux-system".
- **cluster_domain**: Internal domain of the kubernetes cluster flux will run in. Defaults to "cluster.local".

## Example

```
module "flux_installation" {
  source = "git::https://github.com/Ferlab-Ste-Justine/fluxcd-installation.git"
}
```

## Dependencies

This repo is dependent on the following providers being defined and pointing to your kubernetes cluster:
- hashicorp/kubernetes
- gavinbunney/kubectl