<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| spacelift | ~> 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| spacelift | ~> 1.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autodeploy | Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration) | `bool` | `false` | no |
| branch | Specify which branch to use within your infrastructure repo | `string` | `"main"` | no |
| components\_path | The relative pathname for where all components reside | `string` | `"components"` | no |
| external\_execution | Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example). | `bool` | `false` | no |
| manage\_state | Global flag to enable/disable manage\_state settings for all project stacks. | `bool` | `true` | no |
| repository | The name of your infrastructure repo | `string` | n/a | yes |
| runner\_image | The full image name and tag of the Docker image to use in Spacelift | `string` | `null` | no |
| stack\_config\_path | Relative path to YAML config files | `string` | `null` | no |
| stack\_config\_pattern | File pattern used to locate configuration files | `string` | `"*.yaml"` | no |
| terraform\_version | Specify the version of Terraform to use for the stack | `string` | `null` | no |
| worker\_pool\_id | The immutable ID (slug) of the worker pool | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| stacks | A list of generated stacks. |

<!-- markdownlint-restore -->
