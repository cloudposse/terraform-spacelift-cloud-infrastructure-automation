package spacelift

username := input.session.login

# case sensitive names of collaborators
view_only_collaborators := { "nitrocode", "Nuru", "osterman", "aknysh" }

allow {
  view_only_collaborators[username]
}
