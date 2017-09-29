# frozen_string_literal: true

lock '~> 3.9.0'

set :application, 'st-pax'

set :repo_url, 'https://github.com/umts/st-pax.git'
set :branch, :master

set :keep_releases, 5

set :deploy_to, "/srv/#{fetch :application}"

set :log_level, :info

set :whenever_command, %i[sudo bundle exec whenever]

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log'
)
