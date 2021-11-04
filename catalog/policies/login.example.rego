package spacelift
# See https://docs.spacelift.io/concepts/policy/login-policy for implementation details.
# Note: Login policies don't affect GitHub organization or SSO admins.
# Note 2: Enabling SSO requires that all users have an IdP (G Suite) account, so we'll just use
#          GitHub authentication in the meantime while working with external collaborators.
# Map session input data to human friendly variables to use in policy evaluation
username	:= input.session.login
member_of   := input.session.teams

github_org   := input.session.member

# Define GitHub usernames of non-github_org org external collaborators with admin vs. user access
admin_collaborators := { "osterman", "aknysh", "Nuru", "nitrocode" } # case sensitive names of collaborators

user_collaborators  := { "Customer Github Org" } # case sensitive name of the github org

# Grant admin access to github_org org members in the non cloud posse case-sensitive team
# Do not use the slug here, use the name shown in github.com/org/teams
admin {
  github_org
  member_of[_] == "YOUR-CASE-SENSITIVE-TEAM-NAME"
}

# Grant admin access to github_org org members in the Cloud Posse group
# Do not use the slug here, use the name shown in github.com/org/teams
admin {
  github_org
  member_of[_] == "CLOUDPOSSE-CASE-SENSITIVE-TEAM-NAME"
}

# Grant admin access to non-github_org org accounts in the admin_collaborators set
admin {
  # not github_org
  admin_collaborators[username]
}

# Grant user access to accounts in the user_collaborators set
allow {
  # not github_org
  user_collaborators[username]
}

# Deny access to any non-github_org org accounts who aren't defined in external collaborators sets
deny {
  not github_org
  not user_collaborators[username]
  not admin_collaborators[username]
}
