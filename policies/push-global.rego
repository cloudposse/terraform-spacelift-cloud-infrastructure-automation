package spacelift

# Update tracking for affected Terraform files
track {
    affected
    input.push.branch == input.stack.branch
}

propose { affected }
ignore  {
    not affected
}
ignore  { input.push.tag != "" }

# Fetch all of our affected files
filepath := input.push.affected_files

# Check if any Terraform files were modified in a project
affected {
    startswith(filepath[_], input.stack.project_root)
    endswith(filepath[_], ".tf")
}