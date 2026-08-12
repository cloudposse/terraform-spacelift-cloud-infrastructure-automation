terraform {
  required_version = ">= 0.13.0"

  required_providers {
    # v1.32+ embeds Atmos v1.207+ which changed empty base_path resolution
    # from CWD to git root, breaking callers that run from a subdirectory.
    utils = {
      source  = "cloudposse/utils"
      version = "< 1.36.0"
    }
  }
}
