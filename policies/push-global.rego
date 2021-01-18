package spacelift

track {
    tf_affected
    input.push.branch == input.stack.branch
}

track {
    config_affected
    input.push.branch == input.stack.branch
}

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

filepath := input.push.affected_files[_]

tf_affected {
    filepath := input.push.affected_files[_]

    startswith(filepath, input.stack.project_root)
    endswith(filepath, ".tf")
}

stack_name := split(input.stack.name, "-")

config_affected {
    contains(filepath, "/globals.yaml")
}

config_affected {
    contains(filepath, concat("-", [stack_name[0], "globals"]))
}

config_affected {
    contains(filepath, concat("-", [stack_name[0], stack_name[1]]))
}