require 'rubygems'
require 'dogapi'
require 'awesome_print'

api_key='afb2feaca6e3a41a44f8123b5e21f9c4'
app_key='d7ce31f7cbaa9e2e0e9ffe230cbf2041f6b5cfef'

dog = Dogapi::Client.new(api_key, app_key)

hosts =
  ['1265430',
   '1265434',
  ]

#ap dog.update_tags(host, ['elbgroup:aso-production'])
hosts.each do |host|
  ap dog.host_tags(host)
end
