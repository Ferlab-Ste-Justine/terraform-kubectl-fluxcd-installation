terraform {
  required_version = ">= 1.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.11.0"
    }
  }
}