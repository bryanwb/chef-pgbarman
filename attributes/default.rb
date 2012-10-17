
default['pgbarman']['home'] = "/usr/local/barman"
default['pgbarman']['ssh']['user'] = 'postgres'
default['pgbarman']['ssh']['host'] = 'localhost'
default['pgbarman']['postgres']['user'] = 'postgres'
default['pgbarman']['postgres']['host'] = 'localhost'

# Let's set the postgresql settings so we don't get 8.4
set['postgresql']['version'] = "9.0"
override['postgresql']['client']['packages'] =  [ "postgresql90", "postgresql90-devel"  ]
