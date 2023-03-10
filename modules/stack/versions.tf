terraform {
  required_version = ">= 0.13.0"

  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 0.1.27"
    }
  }
}
