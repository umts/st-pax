# frozen_string_literal: true

server 'af-transit-app4.admin.umass.edu',
       roles: %w[app db web],
       ssh_options: { forward_agent: false }
