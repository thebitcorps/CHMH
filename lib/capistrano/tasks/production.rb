set :ssh_options, {
  user: 'deployer',
  keys: %w{~/.ssh/x.pem ~/.ssh/y.pem},
  forward_agent: true,
  auth_methods: %w{publickey}
}
