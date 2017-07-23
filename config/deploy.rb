require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

# Change these
server '198.199.106.115', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url, 'git@github.com:thebitcorps/CHMH.git'
set :application, 'CHMH'
set :user, 'deployer'
set :puma_threads, [4, 16]
set :puma_workers, 0

# Don't change these unless you know what you're doing
# set :use_sudo, false
set :pty, true
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(/Users/rruizv/.ssh/id_rsa.pub) }
# set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :stage, :production
# set :deploy_via, :copy
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
# set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# append :linked_files, %w{config/database.yml}
# append :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
append :linked_files, %w{.env.production}
