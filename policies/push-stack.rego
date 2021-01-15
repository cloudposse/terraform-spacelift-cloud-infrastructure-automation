package spacelift

# You can read more about push policies here:
#
# https://docs.spacelift.io/concepts/policy/git-push-policy

track {
    affected
    input.push.branch == input.stack.branch
}

propose { affected }
ignore  { not affected }
ignore  { input.push.tag != "" }

affected {
    filepath := input.push.affected_files[_]

    startswith(filepath, input.stack.project_root)
    endswith(filepath, ".tf")
}

affected {
    filepath := input.push.affected_files[_]
    stack_name := split(input.stack.name, "-")
    
    contains(filepath, "/globals.yaml")
}

affected {
    filepath := input.push.affected_files[_]
    stack_name := split(input.stack.name, "-")
    
    contains(filepath, concat("-", [stack_name[0], "globals"]))
}

affected {
    filepath := input.push.affected_files[_]
    stack_name := split(input.stack.name, "-")
    
    contains(filepath, concat("-", [stack_name[0], stack_name[1]]))
}