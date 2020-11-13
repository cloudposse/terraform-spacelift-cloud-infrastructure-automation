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
| config\_file\_path | Relative path to YAML config files | `string` | `null` | no |
| config\_file\_pattern | File pattern used to locate configuration files | `string` | `"*.yaml"` | no |
| projects\_path | The relative pathname for where all projects reside | `string` | `"projects"` | no |
| repository | The name of your infrastructure repo | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| stacks | A list of generated stacks. |

<!-- markdownlint-restore -->