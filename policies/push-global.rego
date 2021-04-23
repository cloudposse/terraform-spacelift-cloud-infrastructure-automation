# https://docs.spacelift.io/concepts/policy/git-push-policy

package spacelift

# Update tracking for affected Terraform files
track {
    tf_affected
    input.push.branch == input.stack.branch
}

# Update tracking for affected stack config files
track {
    config_affected
    input.push.branch == input.stack.branch
}

# Only trigger a stack run if the Terraform files were modified
notrigger {
    config_affected
    not tf_affected
}

propose { tf_affected }

# Ignore if any of the `ignore` rules evaluate to `true`
ignore  {
    not tf_affected
    not config_affected
}

ignore  { input.push.tag != "" }

# If pre-commit hooks make changes, they are not semantic changes
# and can and should be ignored.
ignore  { input.push.message == "pre-commit fixes" }

# Fetch all of our affected files
affected_files := input.push.affected_files

# Check if any Terraform files were modified in a project
tf_affected {
    startswith(affected_files[_], input.stack.project_root)
    endswith(affected_files[_], ".tf")
}

# Check if any Terraform json files were modified in a project
tf_affected {
    startswith(affected_files[_], input.stack.project_root)
    endswith(affected_files[_], ".tf.json")
}

# Check if any .tfvars files were modified in a project
tf_affected {
    startswith(affected_files[_], input.stack.project_root)
    endswith(affected_files[_], ".tfvars")
}

# Check if any .yaml files were modified in a project
tf_affected {
    startswith(affected_files[_], input.stack.project_root)
    endswith(affected_files[_], ".yaml")
}

# Get stack-related configs from `labels`
label := input.stack.labels[0]
config := json.unmarshal(label)
stack_deps := config.stack_deps
imports := config.imports


# Split our stack name into a list for matching below
stack_name := split(input.stack.name, "-")

# Check if our global settings have been modified
config_affected {
    contains(affected_files[_], "/globals.yaml")
}

# Check if our environment globals have been modified
config_affected {
    contains(affected_files[_], concat("-", [stack_name[0], "globals"]))
}

# Check if our environment has been modified
config_affected {
    contains(affected_files[_], concat("-", [stack_name[0], stack_name[1]]))
}
