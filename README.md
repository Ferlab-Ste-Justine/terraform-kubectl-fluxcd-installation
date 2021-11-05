# About

This Terraform is to boostrap fluxcd version 2 on an existing kubernetes cluster.

By the time the module has run, you will have:
- The fluxcd resource definitions created and its controller running
- A GitRepo and Kustomize resource created for a root repo. This repo may be used for all orchestrations or otherwise, further resources pointing to downstream repos could be created in this repo.

# Referenced Resource

We tried to follow the instructions here: https://registry.terraform.io/providers/fluxcd/flux/latest/docs/guides/github

However, we found it to be quite an adventure, hence this module.

# Usage

## Input

The module takes the following input variables:

- **flux_namespace**: Namespace the flux controller and resources pointing to the root repo will exist in. Defaults to "flux-system".
- **cluster_domain**: Internal domain of the kubernetes cluster flux will run in. Defaults to "cluster.local".
- **git_identity**: Git ssh key to access root repo
- **git_known_hosts**: Git host fingerprint, in the format expected by fluxcd
- **root_repo_url**: Ssh url of the root repo
- **root_repo_branch**: Branch to clone in the root repo. Defaults to "main".
- **root_repo_path**: Path in the root repo containing the root kustomization or ortherwise the manifest files. Defaults to the root of the repo.
- **root_repo_recurse_submodules**: If set to true, git submodules will be recursed in the root repo. Defaults to false.

## Example

```
resource "tls_private_key" "root_orchestration_repo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "root_repo" {
  title      = "Fluxcd deploy key for some repo"
  repository = "my-root-repo"
  key        = tls_private_key.root_orchestration_repo.public_key_openssh
  read_only  = "false"
}

module "flux_installation" {
  source = "git::https://github.com/Ferlab-Ste-Justine/fluxcd-installation.git"
  git_identity = tls_private_key.root_orchestration_repo.private_key_pem
  git_known_hosts = "github.com ssh-rsa <look it up>"
  root_repo_url = "ssh://git@github.com:22/my-org/my-root-repo.git"
  root_repo_path = "some-path-in-root-repo"
}
```

## Dependencies

This repo is dependent on the following providers being defined and pointing to your kubernetes cluster:
- hashicorp/kubernetes
- gavinbunney/kubectl