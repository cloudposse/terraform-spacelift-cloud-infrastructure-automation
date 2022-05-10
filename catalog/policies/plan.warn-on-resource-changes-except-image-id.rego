package spacelift

sample { true }

warn["This is changing more than one resource"] {
  input.spacelift.run.changes[_].action == "changed"
  count(input.spacelift.run.changes) > 1
}

warn["This is changing the aws_launch_template besides its image_id"] {
  input.spacelift.run.changes[_].action == "changed"
  not input.spacelift.run.changes[_].entity.type == "aws_launch_template"
  input.terraform.resource_changes[_].change.after.image_id == input.terraform.resource_changes[_].change.before.image_id
}
