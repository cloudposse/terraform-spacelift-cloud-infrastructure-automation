<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | >= 0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_spacelift"></a> [spacelift](#provider\_spacelift) | >= 0.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stacks"></a> [stacks](#module\_stacks) | ./modules/stack | n/a |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_yaml_stack_config"></a> [yaml\_stack\_config](#module\_yaml\_stack\_config) | cloudposse/stack-config/yaml//modules/spacelift | 0.17.0 |

## Resources

| Name | Type |
|------|------|
| [spacelift_policy.custom](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy.default](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy.trigger_administrative](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy) | resource |
| [spacelift_policy_attachment.trigger_administrative](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy_attachment) | resource |
| [spacelift_current_stack.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/data-sources/current_stack) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_id"></a> [access\_policy\_id](#input\_access\_policy\_id) | ID of an existing Access policy to override the default | `string` | `null` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_administrative_trigger_policy_enabled"></a> [administrative\_trigger\_policy\_enabled](#input\_administrative\_trigger\_policy\_enabled) | Flag to enable/disable the global administrative trigger policy | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_autodeploy"></a> [autodeploy](#input\_autodeploy) | Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration) | `bool` | `false` | no |
| <a name="input_branch"></a> [branch](#input\_branch) | Specify which branch to use within your infrastructure repo | `string` | `"main"` | no |
| <a name="input_component_deps_processing_enabled"></a> [component\_deps\_processing\_enabled](#input\_component\_deps\_processing\_enabled) | Boolean flag to enable/disable processing stack config dependencies for the components in the provided stack | `bool` | `true` | no |
| <a name="input_components_path"></a> [components\_path](#input\_components\_path) | The relative pathname for where all components reside | `string` | `"components"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_external_execution"></a> [external\_execution](#input\_external\_execution) | Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example) | `bool` | `false` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_imports_processing_enabled"></a> [imports\_processing\_enabled](#input\_imports\_processing\_enabled) | Enable/disable processing stack imports | `bool` | `false` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_local_preview_enabled"></a> [local\_preview\_enabled](#input\_local\_preview\_enabled) | Indicates whether local preview runs can be triggered on this Stack | `bool` | `false` | no |
| <a name="input_manage_state"></a> [manage\_state](#input\_manage\_state) | Global flag to enable/disable manage\_state settings for all project stacks | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_plan_policy_id"></a> [plan\_policy\_id](#input\_plan\_policy\_id) | ID of an existing Plan policy to override the default | `string` | `null` | no |
| <a name="input_policies_available"></a> [policies\_available](#input\_policies\_available) | List of available default policies to create in Spacelift (these policies will not be attached to Spacelift stacks by default, use `var.policies_enabled`) | `list(string)` | <pre>[<br>  "access.default",<br>  "git_push.default",<br>  "plan.default",<br>  "trigger.dependencies",<br>  "trigger.retries"<br>]</pre> | no |
| <a name="input_policies_by_id_enabled"></a> [policies\_by\_id\_enabled](#input\_policies\_by\_id\_enabled) | List of existing policy IDs to attach to all Spacelift stacks. These policies must be created outside of this module | `list(string)` | `[]` | no |
| <a name="input_policies_by_name_path"></a> [policies\_by\_name\_path](#input\_policies\_by\_name\_path) | Path to the catalog of external Rego policies. The Rego files must exist in the caller's code at the path. The module will create Spacelift policies from the external Rego definitions | `string` | `""` | no |
| <a name="input_policies_enabled"></a> [policies\_enabled](#input\_policies\_enabled) | List of default policies to attach to all Spacelift stacks | `list(string)` | <pre>[<br>  "git_push.default",<br>  "plan.default",<br>  "trigger.dependencies"<br>]</pre> | no |
| <a name="input_policies_path"></a> [policies\_path](#input\_policies\_path) | Path to the catalog of default policies | `string` | `"catalog/policies"` | no |
| <a name="input_push_policy_id"></a> [push\_policy\_id](#input\_push\_policy\_id) | ID of an existing Push policy to override the default | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The name of your infrastructure repo | `string` | n/a | yes |
| <a name="input_runner_image"></a> [runner\_image](#input\_runner\_image) | The full image name and tag of the Docker image to use in Spacelift | `string` | `null` | no |
| <a name="input_stack_config_path"></a> [stack\_config\_path](#input\_stack\_config\_path) | Relative path to YAML config files | `string` | `"./stacks"` | no |
| <a name="input_stack_config_path_template"></a> [stack\_config\_path\_template](#input\_stack\_config\_path\_template) | Stack config path template | `string` | `"stacks/%s.yaml"` | no |
| <a name="input_stack_deps_processing_enabled"></a> [stack\_deps\_processing\_enabled](#input\_stack\_deps\_processing\_enabled) | Boolean flag to enable/disable processing all stack dependencies in the provided stack | `bool` | `false` | no |
| <a name="input_stacks"></a> [stacks](#input\_stacks) | A list of stack configs | `list(any)` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Specify the version of Terraform to use for the stack | `string` | `null` | no |
| <a name="input_terraform_version_map"></a> [terraform\_version\_map](#input\_terraform\_version\_map) | A map to determine which Terraform patch version to use for each minor version | `map(string)` | `{}` | no |
| <a name="input_trigger_dependency_policy_id"></a> [trigger\_dependency\_policy\_id](#input\_trigger\_dependency\_policy\_id) | ID of an existing Trigger dependency policy to override the default | `string` | `null` | no |
| <a name="input_trigger_retries_policy_id"></a> [trigger\_retries\_policy\_id](#input\_trigger\_retries\_policy\_id) | ID of an existing Trigger retries policy to override the default | `string` | `null` | no |
| <a name="input_webhook_enabled"></a> [webhook\_enabled](#input\_webhook\_enabled) | Flag to enable/disable the webhook endpoint to which Spacelift sends the POST requests about run state changes | `bool` | `false` | no |
| <a name="input_webhook_endpoint"></a> [webhook\_endpoint](#input\_webhook\_endpoint) | Webhook endpoint to which Spacelift sends the POST requests about run state changes | `string` | `null` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret used to sign each POST request so you're able to verify that the requests come from Spacelift | `string` | `null` | no |
| <a name="input_worker_pool_id"></a> [worker\_pool\_id](#input\_worker\_pool\_id) | The immutable ID (slug) of the worker pool | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stacks"></a> [stacks](#output\_stacks) | Generated stacks |
<!-- markdownlint-restore -->
