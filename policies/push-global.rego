# https://docs.spacelift.io/concepts/policy/git-push-policy
# https://www.openpolicyagent.org/docs/latest/policy-language/#variable-keys
# https://www.openpolicyagent.org/docs/latest/policy-reference/#iteration

package spacelift

# Track if Terraform files are affected
track {
    tf_affected
    input.push.branch == input.stack.branch
}

# Track if stack config files are affected
track {
    config_affected
    input.push.branch == input.stack.branch
}

# Only trigger a stack run if the Terraform files were modified
notrigger {
    config_affected
    not tf_affected
}

propose { 
    tf_affected 
}

# Ignore if any of the `ignore` rules evaluate to `true`
ignore  {
    not tf_affected
    not config_affected
}

ignore  { 
    input.push.tag != "" 
}

# If pre-commit hooks make changes, they are not semantic changes
# and can and should be ignored.
ignore  { 
    input.push.message == "pre-commit fixes" 
}

# Get all of the affected files
affected_files := input.push.affected_files

# Track these extensions in the project folder
tracked_extensions := {".tf", ".tf.json", ".tfvars", ".yaml"}

# Check if any of the tracked extensions were modified in the project folder
tf_affected {
    startswith(affected_files[_], input.stack.project_root)
    endswith(affected_files[_], tracked_extensions[_])
}

# Get stack dependencies and imports from the provided `labels`
label := input.stack.labels[0]
config := json.unmarshal(label)
stack_deps := config.stack_deps
imports := config.imports

# Split the stack name into a list
stack_name := split(input.stack.name, "-")

# Check if the environment has been modified
config_affected {
    contains(affected_files[_], concat("-", [stack_name[0], stack_name[1]]))
}

# Check if any of the imports have been modified
config_affected {
    endswith(affected_files[_], imports[_])
}
