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

## Modules

| Name | Source | Version |
|------|--------|---------|
| spacelift_environment | ./modules/environment |  |
| this | cloudposse/label/null | 0.24.1 |
| yaml_stack_config | cloudposse/stack-config/yaml | 0.10.0 |

## Resources

| Name |
|------|

| spacelift_current_stack

| spacelift_policy

| spacelift_policy_attachment

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| autodeploy | Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration) | `bool` | `false` | no |
| branch | Specify which branch to use within your infrastructure repo | `string` | `"main"` | no |
| components\_path | The relative pathname for where all components reside | `string` | `"components"` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>    label_key_case      = string<br>    label_value_case    = string<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| external\_execution | Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example). | `bool` | `false` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`. <br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation). <br>Default value: `lower`. | `string` | `null` | no |
| manage\_state | Global flag to enable/disable manage\_state settings for all project stacks. | `bool` | `true` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| repository | The name of your infrastructure repo | `string` | n/a | yes |
| runner\_image | The full image name and tag of the Docker image to use in Spacelift | `string` | `null` | no |
| stack\_config\_files | A list of stack config files | `list(any)` | `[]` | no |
| stack\_config\_path | Relative path to YAML config files | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| terraform\_version | Specify the version of Terraform to use for the stack | `string` | `null` | no |
| terraform\_version\_map | A map to determine which Terraform patch version to use for each minor version | `map` | `{}` | no |
| worker\_pool\_id | The immutable ID (slug) of the worker pool | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| environments | A list of generated stacks. |
<!-- markdownlint-restore -->
