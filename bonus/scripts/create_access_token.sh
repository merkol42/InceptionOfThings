gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api', 'read_user', 'read_repository', 'write_repository', 'sudo', 'admin_mode'], name: 'Automation token', expires_at: 365.days.from_now); token.set_token('glpat-q1tdxDFFNz_NZ9MtyJxz'); token.save!"
