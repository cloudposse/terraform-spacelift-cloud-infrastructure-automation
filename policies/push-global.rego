# https://docs.spacelift.io/concepts/policy/git-push-policy

package spacelift

# Ignore if any of the `ignore` rules evaluates to `true`
ignore  {
    not project_affected
    not stack_config_affected
}

ignore {
    input.push.tag != ""
}

# If pre-commit hooks make changes, they are not semantic changes and can and should be ignored
ignore  {
    input.push.message == "pre-commit fixes"
}

propose {
    project_affected
}

# Track if project files are affected
track {
    project_affected
    input.push.branch == input.stack.branch
}

# Track if stack config files are affected
track {
    stack_config_affected
    input.push.branch == input.stack.branch
}

# Get all of the affected files
affected_files := input.push.affected_files

# Track these extensions in the project folder
tracked_extensions := {".tf", ".tf.json", ".tfvars", ".yaml"}

project_root := input.stack.project_root

# Check if any of the tracked extensions were modified in the project folder
# https://www.openpolicyagent.org/docs/latest/policy-language/#some-keyword
# https://www.openpolicyagent.org/docs/latest/policy-language/#variable-keys
# https://www.openpolicyagent.org/docs/latest/policy-reference/#iteration
project_affected {
    some i, j
    startswith(affected_files[i], project_root)
    endswith(affected_files[i], tracked_extensions[j])
}

# Split the stack name into a list
stack_name_parts := split(input.stack.name, "-")

# Check if the environment has been modified
stack_config_affected {
    contains(affected_files[_], concat("-", [stack_name_parts[0], stack_name_parts[1]]))
}

# Get labels
labels := input.stack.labels

# Get imports from the provided `labels`
# https://www.openpolicyagent.org/docs/latest/policy-language/#comprehensions
imports := [imp | startswith(labels[i], "import:"); imp := split(labels[i], ":")[1]]

# Check if any of the imports have been modified
stack_config_affected {
    endswith(affected_files[_], imports[_])
}

# Get component stack dependencies from the provided `labels`
stack_deps := [dep | startswith(labels[i], "stack-deps:"); dep := split(labels[i], ":")[1]]

# Check if any of the stack dependencies have been modified
stack_config_affected {
    endswith(affected_files[_], stack_deps[_])
}
