#
# Cookbook Name:: cpe_cocoadialog
# Resource:: cpe_cocoadialog
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_cocoadialog
default_action :run

action :run do
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_cocoadialog']['config']
  # Cache
  directory '/opt/cocoadialog' do
    mode '0755'
    owner 'root'
    group 'wheel'
  end
  # binary
  cookbook_file '/opt/cocoadialog/cocoadialog.zip' do
    source 'cocoadialog.zip'
    owner 'root'
    group 'admin'
    mode '0755'
    notifies :run, 'execute[cocoadialog_install]', :delayed
    not_if { ::File.exist?('/Applications/Utilities/cocoadialog.app') }
    action :create
  end
  # Install
  execute 'cocoadialog_install' do
    command '/usr/bin/unzip /opt/cocoadialog/cocoadialog.zip -d /Applications/Utilities/'
    action :nothing
  end
  # Binary
  template "/usr/local/bin/cocoadialog" do
    action :create
    cookbook 'cpe_cocoadialog'
    source "cocoadialog"
    owner 'root'
    mode '0755'
  end
end
