package spacelift

# Trigger the stack after it gets created in the `administrative` stack
trigger[stack.id] {
  stack := input.stacks[_]
  # compare a plaintext string (stack.id) to a checksum
  endswith(crypto.sha256(stack.id), id_shas_of_created_stacks[_])
}

id_shas_of_created_stacks[change.entity.data.values.id] {
  change := input.run.changes[_]
  change.action == "added"
  change.entity.type == "spacelift_stack"
  change.phase == "apply" # The change has actually been applied, not just planned
}
