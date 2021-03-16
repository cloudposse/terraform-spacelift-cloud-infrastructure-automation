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
ignore  {
    not tf_affected
    not config_affected
}
ignore  { input.push.tag != "" }

# Fetch all of our affected files
filepath := input.push.affected_files

# Check if any Terraform files were modified in a project
tf_affected {
    startswith(filepath[_], input.stack.project_root)
    endswith(filepath[_], ".tf")
}

# Check if any Terraform json files were modified in a project
tf_affected {
    startswith(filepath[_], input.stack.project_root)
    endswith(filepath[_], ".tf.json")
}

# Check if any .tfvars files were modified in a project
tf_affected {
    startswith(filepath[_], input.stack.project_root)
    endswith(filepath[_], ".tfvars")
}

# Check if any .yaml files were modified in a project
tf_affected {
    startswith(filepath[_], input.stack.project_root)
    endswith(filepath[_], ".yaml")
}

# Split our stack name into a list for matching below
stack_name := split(input.stack.name, "-")

# Check if our global settings have been modified
config_affected {
    contains(filepath[_], "/globals.yaml")
}

# Check if our environment globals have been modified
config_affected {
    contains(filepath[_], concat("-", [stack_name[0], "globals"]))
}

# Check if our environment has been modified
config_affected {
    contains(filepath[_], concat("-", [stack_name[0], stack_name[1]]))
}
