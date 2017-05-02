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
  # Node attr is nil... abort
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
end
