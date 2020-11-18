<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0, < 0.14.0 |
| spacelift | ~> 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| spacelift | ~> 1.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| branch | Specify which branch to use within your infrastructure repo | `string` | `"main"` | no |
| components\_path | The relative pathname for where all components reside | `string` | `"components"` | no |
| external\_execution | Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example). | `bool` | `false` | no |
| manage\_state | Global flag to enable/disable manage\_state settings for all project stacks. | `bool` | `true` | no |
| repository | The name of your infrastructure repo | `string` | n/a | yes |
| stack\_config\_path | Relative path to YAML config files | `string` | `null` | no |
| stack\_config\_pattern | File pattern used to locate configuration files | `string` | `"*.yaml"` | no |

## Outputs

| Name | Description |
|------|-------------|
| stacks | A list of generated stacks. |

<!-- markdownlint-restore -->
