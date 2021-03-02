# frozen_string_literal: true

lock '~> 3.14'

set :application, 'st-pax'
set :repo_url, 'https://github.com/umts/st-pax.git'
set :branch, :master
set :deploy_to, "/srv/#{fetch :application}"

set :log_level, :info

append :linked_files,
       'config/database.yml',
       'config/application.yml'

append :linked_dirs, '.bundle', 'log', 'node_modules'

set :passenger_restart_with_sudo, true
