#
# Cookbook Name:: cpe_remotedesktop
# Resource:: cpe_remotedesktop
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_remotedesktop
default_action :run

action :run do
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_remotedesktop']['config']
  # binary
  kickstart = ::File.join(
    '/System',
    'Library',
    'CoreServices',
    'RemoteManagement',
    'ARDAgent.app',
    'Contents',
    'Resources',
    'kickstart',
  )
  # Options
  options = node['cpe_remotedesktop']['options'].join(' ')
  # Node is nil? ...don't manage. Allows user to override.
  return if options.to_s.nil?
  # LaunchDaemon
  prefix = node['cpe_profiles']['prefix']
  node.default['cpe_launchd']["#{prefix}.remotedesktop"] = {
    'program_arguments' => [
      '/bin/sh',
      '-c',
      "sleep 10; pgrep -f Remote\\ Desktop || #{kickstart} #{options}; exit 0",
    ],
    'run_at_load' => true,
    'start_interval' => node['cpe_remotedesktop']['interval'],
  }
  # Cache
  directory '/opt/ard' do
    mode '0755'
    owner 'root'
    group 'wheel'
  end
  # ARD resource
  return unless node['cpe_remotedesktop']['admin']
  cookbook_file '/opt/ard/Remote Desktop.zip' do
    source 'Remote Desktop.zip'
    owner 'root'
    group 'admin'
    mode '0755'
    notifies :run, 'execute[ard_install]', :delayed
    not_if { ::File.exist?('/Applications/Remote Desktop.app') }
    action :create
  end
  # ARD Install
  execute 'ard_install' do
    command '/usr/bin/unzip /opt/ard/Remote\ Desktop.zip -d /Applications/'
    action :nothing
  end
end
