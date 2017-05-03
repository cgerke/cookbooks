#
# Cookbook Name:: cpe_yo
# Resource:: cpe_yo
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_yo
default_action :run

action :run do
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_yo']['config']
  # Cache
  directory '/opt/yo' do
    mode '0755'
    owner 'root'
    group 'wheel'
  end
  # binary
  cookbook_file '/opt/yo/yo.zip' do
    source 'yo.zip'
    owner 'root'
    group 'admin'
    mode '0755'
    notifies :run, 'execute[yo_install]', :delayed
    not_if { ::File.exist?('/Applications/Utilities/yo.app') }
    action :create
  end
  # Install
  execute 'yo_install' do
    command 'unzip /opt/yo/yo.zip -d /Applications/Utilities/'
    action :nothing
  end
  # Binary
  template '/usr/local/bin/yo' do
    action :create
    cookbook 'cpe_yo'
    source 'yo'
    owner 'root'
    mode '0755'
  end
end
