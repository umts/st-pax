# frozen_string_literal: true

remote_user = Net::SSH::Config.for('af-transit-app4.admin.umass.edu')[:user] ||
              ENV['USER']
server 'af-transit-app4.admin.umass.edu',
       roles: %w[app db web],
       user: remote_user,
       ssh_options: { forward_agent: false }
