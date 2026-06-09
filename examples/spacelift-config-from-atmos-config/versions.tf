terraform {
  required_version = ">= 0.13.0"
  required_providers {
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1.7.1, < 1.32.0"
    }
  }
}
