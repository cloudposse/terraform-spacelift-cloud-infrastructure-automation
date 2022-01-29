package spacelift

username := input.session.login

# case sensitive names of collaborators
view_only_collaborators := { "nitrocode", "Nuru", "osterman", "aknysh" }

read {
  view_only_collaborators[username]
}
