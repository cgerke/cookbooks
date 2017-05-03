#
# Cookbook Name:: cpe_ssh
# Resources:: cpe_ssh
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_ssh
default_action :run

action :run do
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_ssh']['config']
  # LaunchDaemon
  ssh = node['cpe_ssh']['setremotelogin'] ?
    node['cpe_ssh']['setremotelogin'] : 'on'
  prefix = node['cpe_profiles']['prefix']
  node.default['cpe_launchd']["#{prefix}.ssh"] = {
    'program_arguments' => [
      '/bin/sh',
      '-c',
      "/bin/sleep 10; /usr/sbin/systemsetup -setremotelogin #{ssh}",
    ],
    'run_at_load' => true,
    'start_interval' => node['cpe_ssh']['interval'],
  }
  # GLOBAL ssh_known_hosts, destructive though...
  require 'English'
  GLOBAL_KNOWN_HOSTS = '/etc/ssh/ssh_known_hosts'
  host_keys = node['cpe_ssh']['ssh_known_hosts']
  unless host_keys.nil?
    lines = []
    host_keys.each do |array|
      array.each do |val|
        lines.push(val['ip'] + ' ' + val['type'] + ' ' + val['key'] + $RS)
        file GLOBAL_KNOWN_HOSTS do
          content lines.join
        end
      end
    end
  end
  # MOTD node is nil? ...don't manage. Allows user to override.
  message_of_the_day = node['cpe_ssh']['motd']
  file '/etc/motd' do
    content message_of_the_day + "\r\n"
    mode '0644'
    not_if { message_of_the_day.nil? }
  end
  # sshrc node is nil? ...don't manage. Allows user to override.
  # FC033 : false positive hack with File.join
  ssh_alert = node['cpe_ssh']['email']
  template '/etc/ssh/sshrc' do
    source ::File.join('global', 'sshrc.erb')
    owner 'root'
    group 'wheel'
    mode '0644'
    not_if { ssh_alert.nil? }
  end
  # Won't run at loginwindow
  console_user = node.console_user()
  return if console_user == 'root'
  # Home
  console_home = '/Users/' + console_user
  # .ssh
  directory "#{console_home}/.ssh" do
    action :create
    mode '0700'
    owner console_user
  end
  # authorized_keys node is empty? ...don't manage. Allows user to override.
  authorized_keys = node['cpe_ssh']['authorized']
  template "#{console_home}/.ssh/authorized_keys" do
    action :create
    source "#{console_user}/authorized_keys.erb"
    mode '0600'
    owner console_user
    variables(:authorized_keys => authorized_keys)
    not_if { authorized_keys.to_s.empty? }
  end
  # config node is nil? ...don't manage. Allows user to override.
  ssh_config = node['cpe_ssh']['ssh_config']
  template "#{console_home}/.ssh/config" do
    action :create
    source "#{console_user}/config.erb"
    mode '0600'
    owner console_user
    variables(:config_arrays => ssh_config)
    not_if { ssh_config.nil? }
  end
  # config node is nil? ...don't manage. Allows user to override.
  ssh_id = node['cpe_ssh']['ssh_id']
  template "#{console_home}/.ssh/id_rsa" do
    action :create
    source "#{console_user}/id_rsa.erb"
    mode '0600'
    owner console_user
    only_if { ssh_id }
  end
end
