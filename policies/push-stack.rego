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

# Here's a definition of an affected file - its path must both:
#
# a) start with the Stack's project root, and;
# b) end with ".tf", indicating that it's a Terraform source file;
affected {
    filepath := input.push.affected_files[_]

    startswith(filepath, input.stack.project_root)
    endswith(filepath, ".tf")
}
